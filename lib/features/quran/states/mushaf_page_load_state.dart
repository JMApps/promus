import '../domain/entities/mushaf_page_entity.dart';

/// Состояние загрузки одной страницы Мусхафа.
///
/// Сравнение дешёвое: `Selector` в ReaderPageList вызывает `==` на каждое
/// уведомление MushafPageState, поэтому списки строк сравниваются по ссылке,
/// а не поэлементно.
sealed class MushafPageLoadState {
  const MushafPageLoadState();

  const factory MushafPageLoadState.initial() = _Initial;
  const factory MushafPageLoadState.loading() = _Loading;
  const factory MushafPageLoadState.loaded(List<MushafPageEntity> data) = _Loaded;
  const factory MushafPageLoadState.error(Object error) = _Error;

  bool get loaded => this is _Loaded;
  bool get loading => this is _Loading;

  List<MushafPageEntity>? get data => switch (this) {
    _Loaded(:final data) => data,
    _ => null,
  };

  Object? get error => switch (this) {
    _Error(:final error) => error,
    _ => null,
  };
}

// Константные экземпляры канонизируются: все `const _Initial()` — один объект,
// поэтому стандартного сравнения по ссылке достаточно.
final class _Initial extends MushafPageLoadState {
  const _Initial();
}

final class _Loading extends MushafPageLoadState {
  const _Loading();
}

final class _Loaded extends MushafPageLoadState {
  const _Loaded(this.data);

  @override
  final List<MushafPageEntity> data;

  @override
  bool operator ==(Object other) => other is _Loaded && identical(other.data, data);

  @override
  int get hashCode => identityHashCode(data);
}

final class _Error extends MushafPageLoadState {
  const _Error(this.error);

  @override
  final Object error;

  @override
  bool operator ==(Object other) => other is _Error && other.error == error;

  @override
  int get hashCode => error.hashCode;
}