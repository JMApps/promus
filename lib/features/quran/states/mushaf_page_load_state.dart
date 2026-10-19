import 'package:equatable/equatable.dart';

import '../domain/entities/mushaf_page_entity.dart';

sealed class MushafPageLoadState extends Equatable {

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

  @override
  List<Object?> get props => [loaded, loading, data, error];
}

final class _Initial extends MushafPageLoadState {
  const _Initial();
}

final class _Loading extends MushafPageLoadState {
  const _Loading();
}

final class _Loaded extends MushafPageLoadState {
  @override
  final List<MushafPageEntity> data;

  const _Loaded(this.data);

  @override
  List<Object?> get props => [data];
}

final class _Error extends MushafPageLoadState {
  @override
  final Object error;

  const _Error(this.error);

  @override
  List<Object?> get props => [error];
}