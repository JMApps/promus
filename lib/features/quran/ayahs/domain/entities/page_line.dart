import '../../../reader/domain/entities/mushaf_page_row_entity.dart';

sealed class PageLine {
  const PageLine();
}

final class SurahLine extends PageLine {
  final int surahNumber;

  const SurahLine(this.surahNumber);
}

final class BasmallahLine extends PageLine {
  const BasmallahLine();
}

final class AyahLine extends PageLine {
  final MushafPageRowEntity row;
  final int index;

  const AyahLine(this.row, this.index);
}