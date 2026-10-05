import 'package:equatable/equatable.dart';

import '../../../../core/enums/line_type.dart';

class LayoutEntity extends Equatable {
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final int? firstWordId;
  final int? lastWordId;
  final bool isCentered;
  final int? surahNumber;

  const LayoutEntity({
    required this.pageNumber,
    required this.lineNumber,
    required this.firstWordId,
    required this.lastWordId,
    required this.lineType,
    required this.isCentered,
    required this.surahNumber,
  });

  @override
  List<Object?> get props => [
    pageNumber,
    lineNumber,
    firstWordId,
    lastWordId,
    lineType,
    isCentered,
    surahNumber,
  ];
}
