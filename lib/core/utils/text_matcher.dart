import 'dart:ui' show TextRange;

/// Поиск совпадений для подсветки и подсчёта.
/// Арабский сравнивается без огласовок, а диапазоны возвращаются
/// в координатах ОРИГИНАЛЬНОГО текста.
class TextMatcher {
  TextMatcher._();

  static final _arabic = RegExp(r'[\u0600-\u06FF]');
  static final _tokenSplit = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

  static bool containsArabic(String s) => _arabic.hasMatch(s);

  // харакаты, коранические знаки, татвиль
  static bool _isMark(int c) =>
      (c >= 0x064B && c <= 0x065F) ||
          c == 0x0670 ||
          (c >= 0x06D6 && c <= 0x06ED) ||
          c == 0x0640;

  // آ أ إ ٱ -> ا
  static bool _isAlefVariant(int c) =>
      c == 0x0622 || c == 0x0623 || c == 0x0625 || c == 0x0671;

  /// Единая нормализация: используйте и для запроса в БД, и для подсветки.
  static String normalizeArabic(String s) => _normalize(s).text;

  static ({String text, List<int> map}) _normalize(String s) {
    final buf = StringBuffer();
    final map = <int>[]; // map[i] = индекс символа в оригинале
    for (var i = 0; i < s.length; i++) {
      final c = s.codeUnitAt(i);
      if (_isMark(c)) continue;
      buf.writeCharCode(_isAlefVariant(c) ? 0x0627 : c);
      map.add(i);
    }
    return (text: buf.toString(), map: map);
  }

  static List<TextRange> findRanges({
    required String text,
    required String query,
    required bool isArabic,
  }) {
    if (text.isEmpty || query.trim().isEmpty) return const [];

    final ranges = <TextRange>[];

    if (isArabic) {
      final src = _normalize(text);
      final tokens = normalizeArabic(query).split(_tokenSplit).where((t) => t.isNotEmpty);

      for (final token in tokens) {
        var from = 0;
        while (true) {
          final i = src.text.indexOf(token, from);
          if (i == -1) break;

          final start = src.map[i];
          var end = src.map[i + token.length - 1] + 1;
          // захватываем огласовки, стоящие после последней буквы
          while (end < text.length && _isMark(text.codeUnitAt(end))) {
            end++;
          }

          ranges.add(TextRange(start: start, end: end));
          from = i + token.length;
        }
      }
    } else {
      final source = text.toLowerCase();
      final tokens = query.toLowerCase().split(_tokenSplit).where((t) => t.isNotEmpty);

      for (final token in tokens) {
        var from = 0;
        while (true) {
          final i = source.indexOf(token, from);
          if (i == -1) break;
          ranges.add(TextRange(start: i, end: i + token.length));
          from = i + token.length;
        }
      }
    }

    return _merge(ranges);
  }

  static List<TextRange> _merge(List<TextRange> ranges) {
    if (ranges.length < 2) return ranges;

    ranges.sort((a, b) => a.start.compareTo(b.start));
    final out = <TextRange>[ranges.first];

    for (final cur in ranges.skip(1)) {
      final last = out.last;
      if (cur.start <= last.end) {
        if (cur.end > last.end) {
          out[out.length - 1] = TextRange(start: last.start, end: cur.end);
        }
      } else {
        out.add(cur);
      }
    }
    return out;
  }
}