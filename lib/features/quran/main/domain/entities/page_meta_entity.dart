import 'package:equatable/equatable.dart';

class PageMetaEntity extends Equatable {
  final int pageNumber;
  final int surahNumber;
  final int juzNumber;
  final int? hizbNumber;

  const PageMetaEntity({
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