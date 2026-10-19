import 'package:equatable/equatable.dart';

class MushafPageMetaEntity extends Equatable {
  final int pageNumber;
  final int surahNumber;
  final int juzNumber;
  final int? hizbNumber;

  const MushafPageMetaEntity({
    required this.pageNumber,
    required this.surahNumber,
    required this.juzNumber,
    required this.hizbNumber,
  });

  @override
  List<Object?> get props => [
    pageNumber,
    surahNumber,
    juzNumber,
    hizbNumber,
  ];
}