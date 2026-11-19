/// Нормализация текста для полнотекстового поиска.
///
/// Колонка ayah_normalized получена из османского текста и дополнительно
/// обработана в базе: ة → ه, «ءا» → «ا» (кроме конца слова).
/// [normalizeArabic] приводит запрос к тем же правилам. Если меняете
/// правила здесь — поменяйте и колонку, затем пересоберите fts_ayahs_arabic.
library;

/// Огласовки и коранические знаки (U+0610–061A, U+064B–065F), малый алиф (U+0670),
/// малые знаки (U+06D6–06ED), татвиль (U+0640), арабские и персидские цифры.
final _arabicDiacritics = RegExp(
  '[ؐ-ًؚ-ٰٟۖ-ۭـ٠-٩۰-۹]',
);

/// آ أ إ ٱ
final _arabicAlef = RegExp('[آأإٱ]');

/// Блок арабского письма U+0600–06FF.
final _arabicLetter = RegExp('[؀-ۿ]');

final _spaces = RegExp(r'\s+');
final _nonWord = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

const _alef = 'ا'; // ا
const _al = 'ال'; // ال

bool containsArabic(String text) => _arabicLetter.hasMatch(text);

String normalizeArabic(String text) => text
    .replaceAll(_arabicDiacritics, '')
    .replaceAll(_arabicAlef, _alef) // آ أ إ ٱ → ا
    .replaceAll('ى', 'ي') // ى → ي
    .replaceAll('ة', 'ه') // ة → ه
    .replaceAll(_spaces, ' ')
    .trim()
// В османском письме «يَٰٓأَيُّهَا» пишется одним словом.
    .replaceAll('يا ايها', 'يايها'); // يا ايها → يايها

/// Варианты написания слова в порядке проверки.
///
/// В османском тексте часть алифов не пишется (العلمين, الكتب, الصرط),
/// ة иногда передаётся через و (الصلوة), а ئ после алифа — хамзой (اسرءيل).
/// Пользователь печатает обычное написание, поэтому, если слово не нашлось
/// как есть, пробуем такие варианты. Первым всегда идёт само слово.
List<String> arabicSpellingVariants(String word) {
  final base = <String>[word];
  if (word.length > 3 && word.endsWith('اه')) {
    base.add('${word.substring(0, word.length - 2)}وه'); // صلاه → صلوه
  }
  if (word.contains('ائ')) {
    base.add(word.replaceAll('ائ', 'ء')); // اسرائيل → اسرءيل
  }

  final result = [...base];
  for (final v in base) {
    // Алиф сразу после «ال» обычно настоящий (الانسن), его пробуем сохранить.
    final keepAfterAl = v.startsWith(_al) && v.length > 3 ? 3 : 1;
    for (final candidate in [_dropInnerAlef(v, keepAfterAl), _dropInnerAlef(v, 1)]) {
      if (candidate != v && candidate.length >= 3 && !result.contains(candidate)) {
        result.add(candidate);
      }
    }
  }
  return result;
}

String _dropInnerAlef(String word, int keep) => word.length <= keep ? word : word.substring(0, keep) + word.substring(keep).replaceAll(_alef, '');

/// В переводах нет буквы ё, а токенизатор FTS не приравнивает её к е.
String normalizeRussian(String text) => text.replaceAll('ё', 'е').replaceAll('Ё', 'Е').trim();

/// Делит строку на слова: только буквы и цифры, поэтому кавычки
/// и операторы FTS из пользовательского ввода в запрос не попадут.
List<String> splitSearchWords(String text) => text.split(_nonWord).where((word) => word.isNotEmpty).toList();