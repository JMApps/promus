/// Нормализация текста для полнотекстового поиска.
///
/// Правила [normalizeArabic] должны совпадать символ в символ с normalize()
/// в fill_ayah_normalized.py, которым заполнялась колонка ayah_normalized.
/// Если меняете одно — меняйте и другое, затем пересоберите fts_ayahs_arabic.
library;

final _arabicDiacritics = RegExp(
  '[ؐ-ًؚ-ٰٟۖ-ۭـ٠-٩۰-۹]',
);
final _arabicAlef = RegExp('[آأإٱ]');
final _arabicLetter = RegExp('[؀-ۿ]');
final _spaces = RegExp(r'\s+');
final _nonWord = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

bool containsArabic(String text) => _arabicLetter.hasMatch(text);

String normalizeArabic(String text) => text
    .replaceAll(_arabicDiacritics, '')
    .replaceAll(_arabicAlef, 'ا') // آ أ إ ٱ → ا
    .replaceAll('ى', 'ي') // ى → ي
    .replaceAll('ة', 'ه') // ة → ه
    .replaceAll(_spaces, ' ')
    .trim();

/// В переводах нет буквы ё, а токенизатор FTS не приравнивает её к е.
String normalizeRussian(String text) => text.replaceAll('ё', 'е').replaceAll('Ё', 'Е').trim();

/// Делит строку на слова: только буквы и цифры, поэтому кавычки
/// и операторы FTS из пользовательского ввода в запрос не попадут.
List<String> splitSearchWords(String text) => text.split(_nonWord).where((word) => word.isNotEmpty).toList();