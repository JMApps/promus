import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/notification_keys.dart';

class LocalNotificationService {
  LocalNotificationService._internal();

  static final LocalNotificationService _instance = LocalNotificationService._internal();

  factory LocalNotificationService() => _instance;

  static const String _icon = 'ic_app_notification';

  static const RawResourceAndroidNotificationSound _adhanSound = RawResourceAndroidNotificationSound('adhan');

  static const NotificationDetails _prayerDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      NotificationKeys.prayerChannelId,
      NotificationKeys.defaultPrayerChannelName,
      channelDescription: NotificationKeys.defaultPrayerChannelDescription,
      icon: _icon,
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: _adhanSound,
    ),
    iOS: DarwinNotificationDetails(
      presentBanner: true,
      presentList: true,
      presentSound: true,
      sound: 'adhan.caf',
    ),
  );

  static const NotificationDetails _reminderDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      NotificationKeys.reminderChannelId,
      NotificationKeys.defaultReminderChannelName,
      channelDescription: NotificationKeys.defaultReminderChannelDescription,
      icon: _icon,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentBanner: true,
      presentList: true,
      presentSound: true,
    ),
  );

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  final StreamController<String?> _tapController = StreamController<String?>.broadcast();

  bool _initialized = false;

  Stream<String?> get onTap => _tapController.stream;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

  Future<void> setupNotification({
    String prayerChannelName = NotificationKeys.defaultPrayerChannelName,
    String prayerChannelDescription = NotificationKeys.defaultPrayerChannelDescription,
    String reminderChannelName = NotificationKeys.defaultReminderChannelName,
    String reminderChannelDescription = NotificationKeys.defaultReminderChannelDescription,
  }) async {
    if (_initialized) return;

    tz.initializeTimeZones();
    await refreshTimezone();

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings(_icon),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: _onResponse,
    );

    final android = _android;

    if (android != null) {
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          NotificationKeys.prayerChannelId,
          prayerChannelName,
          description: prayerChannelDescription,
          importance: Importance.max,
          playSound: true,
          sound: _adhanSound,
        ),
      );
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          NotificationKeys.reminderChannelId,
          reminderChannelName,
          description: reminderChannelDescription,
          importance: Importance.high,
        ),
      );
    }

    _initialized = true;
  }

  Future<void> refreshTimezone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e) {
      debugPrint('Failed to detect local timezone, keeping current: $e');
    }
  }

  void _onResponse(NotificationResponse response) {
    _tapController.add(response.payload);
  }

  Future<String?> getLaunchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details?.notificationResponse?.payload;
    }
    return null;
  }

  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      return await _android?.areNotificationsEnabled() ?? false;
    }
    if (Platform.isIOS) {
      final options = await _ios?.checkPermissions();
      return options?.isEnabled ?? false;
    }
    return false;
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final android = _android;
      final granted = await android?.requestNotificationsPermission() ?? false;
      if (granted) {
        final canExact = await android?.canScheduleExactNotifications() ?? true;
        if (!canExact) {
          await android?.requestExactAlarmsPermission();
        }
      }
      return granted;
    }
    if (Platform.isIOS) {
      return await _ios?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    return false;
  }

  Future<bool> schedulePrayer({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) {
    return _schedule(
      id: id,
      title: title,
      body: body,
      dateTime: dateTime,
      payload: payload,
      details: _prayerDetails,
      preferredMode: AndroidScheduleMode.alarmClock,
    );
  }

  Future<bool> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
    DateTimeComponents? repeat,
  }) {
    return _schedule(
      id: id,
      title: title,
      body: body,
      dateTime: dateTime,
      payload: payload,
      details: _reminderDetails,
      preferredMode: .exactAllowWhileIdle,
      repeat: repeat,
    );
  }

  Future<bool> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    required NotificationDetails details,
    required AndroidScheduleMode preferredMode,
    String? payload,
    DateTimeComponents? repeat,
  }) async {
    if (!_initialized) {
      debugPrint('LocalNotificationService is not initialized, skip #$id');
      return false;
    }

    final scheduled = tz.TZDateTime.from(dateTime, tz.local);

    if (repeat == null && !scheduled.isAfter(tz.TZDateTime.now(tz.local))) {
      return false;
    }

    Future<void> run(AndroidScheduleMode mode) => _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: details,
      androidScheduleMode: mode,
      payload: payload,
      matchDateTimeComponents: repeat,
    );

    try {
      try {
        await run(preferredMode);
      } on PlatformException catch (e) {
        if (e.code != 'exact_alarms_not_permitted') rethrow;
        await run(AndroidScheduleMode.inexactAllowWhileIdle);
      }
      return true;
    } catch (e, st) {
      debugPrint('Failed to schedule notification #$id: $e\n$st');
      return false;
    }
  }

  Future<void> cancelNotificationWithId(int id) => _plugin.cancel(id: id);

  Future<void> cancelNotifications(Iterable<int> ids) async {
    for (final id in ids) {
      await _plugin.cancel(id: id);
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<Set<int>> pendingIds() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.map((r) => r.id).toSet();
  }
}
