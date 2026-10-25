import 'package:equatable/equatable.dart';

import 'surah_name_entity.dart';

class LastOpenedSurahEntity extends Equatable {
  const LastOpenedSurahEntity({
    required this.surah,
    required this.pageNumber,
  });

  final SurahNameEntity surah;
  final int pageNumber;

  @override
  List<Object?> get props => [
    surah,
    pageNumber,
  ];
}
