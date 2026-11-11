import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce/hive.dart';

import '../constants/notification_keys.dart';
import '../services/local_notification_service.dart';
import 'models.dart';
import 'notification_planner.dart';
import 'notification_prefs.dart';

/// Возвращает источник времён намазов для текущего города и параметров
/// расчёта, или `null`, если город ещё не выбран.
typedef PrayerTimesSourceLoader = FutureOr<PrayerTimesSource?> Function();

/// Возвращает конвертер в хиджру с текущим пользовательским смещением.
typedef HijriResolverLoader = FutureOr<HijriResolver> Function();

/// Держит запланированные уведомления в соответствии с настройками.
///
/// Принцип: на любое изменение строится полный план «как должно быть»
/// и сравнивается с уже запланированным. Отменяется только лишнее,
/// планируется только недостающее или изменившееся. Уже показанные
/// уведомления в шторке не трогаются.
class NotificationScheduler with WidgetsBindingObserver {
  NotificationScheduler({
    required this._service,
    required Box notificationsBox,
    required this._loadPrayerTimes,
    required this._loadHijri,
    this._planner = const NotificationPlanner(),
    this.debounce = const Duration(milliseconds: 400),
    this.maxHorizonDays = 30,
    int? maxPending,
  }) : _box = notificationsBox,
        maxPending = maxPending ?? (Platform.isIOS ? 64 : 150);

  final LocalNotificationService _service;
  final Box _box;
  final PrayerTimesSourceLoader _loadPrayerTimes;
  final HijriResolverLoader _loadHijri;
  final NotificationPlanner _planner;

  final Duration debounce;
  final int maxHorizonDays;

  /// iOS хранит не больше 64 ожидающих уведомлений.
  /// На Android 150 — это около 13 дней при всех включённых типах.
  final int maxPending;

  final List<StreamSubscription<BoxEvent>> _subscriptions = [];
  final List<Listenable> _listenables = [];

  Timer? _debounceTimer;
  Future<void>? _running;
  bool _dirty = false;
  bool _started = false;
  bool _disposed = false;

  /// Подписывается на всё, что влияет на расписание, и делает первую синхронизацию.
  ///
  /// [watchBoxes] — boxes с городом, методом расчёта, мазхабом, поправками,
  /// смещением хиджры. Box настроек уведомлений отслеживается всегда.
  /// [watchListenables] — если что-то из этого хранится не в Hive, а в ChangeNotifier.
  void start({
    Iterable<Box> watchBoxes = const [],
    Iterable<Listenable> watchListenables = const [],
  }) {
    if (_started || _disposed) return;
    _started = true;

    WidgetsBinding.instance.addObserver(this);

    for (final box in {_box, ...watchBoxes}) {
      _subscriptions.add(box.watch().listen((_) => requestSync()));
    }
    for (final listenable in watchListenables) {
      listenable.addListener(requestSync);
      _listenables.add(listenable);
    }

    unawaited(syncNow());
  }

  /// Синхронизация с задержкой: серия изменений (прокрутка минут,
  /// сброс настроек по умолчанию) превращается в один прогон.
  void requestSync() {
    if (_disposed) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () => unawaited(syncNow()));
  }

  /// Синхронизация сразу. Если прогон уже идёт, после него будет ещё один,
  /// а возвращённый Future завершится, когда отработают оба.
  Future<void> syncNow() {
    _debounceTimer?.cancel();
    final running = _running;
    if (running != null) {
      _dirty = true;
      return running;
    }
    final future = _loop().whenComplete(() => _running = null);
    _running = future;
    return future;
  }

  Future<void> requestPermissionsOnce() async {
    if (_box.get(NotificationKeys.keyPermissionAsked) == true) return;
    await _box.put(NotificationKeys.keyPermissionAsked, true);

    await _service.setupNotification();
    final granted = await _service.requestPermissions();
    if (granted) await _service.requestExactAlarmsPermission();

    await syncNow();
  }

  Future<void> _loop() async {
    do {
      _dirty = false;
      try {
        await _syncOnce();
      } catch (e, st) {
        debugPrint('[NotificationScheduler] sync failed: $e\n$st');
      }
    } while (_dirty && !_disposed);
  }

  Future<void> _syncOnce() async {
    await _service.setupNotification();
    await _service.refreshTimezone();

    final prefs = NotificationPrefs.fromBox(_box);
    final exact = await _service.canScheduleExactAlarms();
    final times = await _loadPrayerTimes();

    final plan = times == null
        ? const <PlannedNotification>[]
        : _planner.build(
      now: DateTime.now(),
      prefs: prefs,
      times: times,
      hijri: await _loadHijri(),
      exact: exact,
      maxCount: maxPending,
      maxHorizonDays: maxHorizonDays,
    );

    await _apply(plan, exact: exact);
  }

  Future<void> _apply(List<PlannedNotification> plan, {required bool exact}) async {
    final pending = await _service.pendingRequests();
    final current = {for (final r in pending) r.id: r};
    final desired = {for (final n in plan) n.id: n};

    // Сначала отмена: на iOS иначе можно упереться в лимит 64.
    final toCancel = [
      for (final r in pending)
        if (!desired.containsKey(r.id) && _isManaged(r)) r.id,
    ];
    await _service.cancelNotifications(toCancel);

    var scheduled = 0;
    for (final n in plan) {
      final existing = current[n.id];
      if (existing != null &&
          existing.title == n.title &&
          existing.body == n.body &&
          existing.payload == n.payload) {
        continue;
      }
      // Тот же id просто заменяет старое уведомление, отменять заранее не нужно.
      final ok = await _service.schedule(
        channel: n.channel,
        id: n.id,
        title: n.title,
        body: n.body,
        dateTime: n.at,
        payload: n.payload,
        exact: exact,
      );
      if (ok) scheduled++;
    }

    debugPrint(
      '[NotificationScheduler] plan=${plan.length}, cancelled=${toCancel.length}, '
          'scheduled=$scheduled, exact=$exact, until=${plan.isEmpty ? '-' : plan.last.at.toLocal()}',
    );
  }

  /// «Свои» уведомления: новый формат payload или старые фиксированные id.
  /// Чужие (если появятся другие функции) планировщик не отменяет.
  bool _isManaged(PendingNotificationRequest r) =>
      NotificationPayload.tryDecode(r.payload) != null || NotificationKeys.legacyIds.contains(r.id);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // При возврате: обновить часовой пояс и продлить окно вперёд.
    // Сюда же попадает возврат из системных настроек после выдачи разрешений.
    if (state == AppLifecycleState.resumed) unawaited(syncNow());
  }

  void dispose() {
    _disposed = true;
    _debounceTimer?.cancel();
    if (_started) WidgetsBinding.instance.removeObserver(this);
    for (final s in _subscriptions) {
      unawaited(s.cancel());
    }
    _subscriptions.clear();
    for (final l in _listenables) {
      l.removeListener(requestSync);
    }
    _listenables.clear();
  }
}