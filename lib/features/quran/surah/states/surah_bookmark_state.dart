import 'package:material_ui/material_ui.dart';
import 'package:hive_ce/hive.dart';

import '../../../../core/constants/app_constant_keys.dart';
import '../../domain/entities/last_opened_surah_entity.dart';
import '../../states/mushaf_page_meta_state.dart';
import 'surah_name_state.dart';

class SurahBookmarkState extends ChangeNotifier {

  final Box _bookMarksSurahsBox;

  SurahBookmarkState(this._bookMarksSurahsBox) {
   _lastOpenedPages = _bookMarksSurahsBox.get(AppConstantKeys.keyBookmarkSurahs, defaultValue: <int>[2, 293, 562]);
  }

  late List<int> _lastOpenedPages;

  List<int> get lastOpenedPages => _lastOpenedPages;

  Future<void> addLastOpenedPage(int page) async {
    // Страница уже первая — ничего не меняется.
    if (_lastOpenedPages.isNotEmpty && _lastOpenedPages.first == page) return;

    final pages = [..._lastOpenedPages]
      ..remove(page)
      ..insert(0, page);

    if (pages.length > AppConstantKeys.maxStoredPages) {
      pages.removeRange(AppConstantKeys.maxStoredPages, pages.length);
    }

    _lastOpenedPages = List.unmodifiable(pages);
    notifyListeners(); // интерфейс сразу, запись — следом
    await _bookMarksSurahsBox.put(AppConstantKeys.keyBookmarkSurahs, _lastOpenedPages);
  }

  List<LastOpenedSurahEntity> resolveLastOpenedSurahs({required MushafPageMetaState meta, required SurahNameState surahs, int limit = 3}) {
    final result = <LastOpenedSurahEntity>[];
    final seen = <int>{};

    for (final page in _lastOpenedPages) {
      final surahNumber = meta.metaByPageNumber(page)?.surahNumber;
      if (surahNumber == null || !seen.add(surahNumber)) continue;

      final surah = surahs.surahByNumber(surahNumber: surahNumber);
      if (surah == null) continue;

      result.add(LastOpenedSurahEntity(surah: surah, pageNumber: page));
      if (result.length == limit) break;
    }

    return result;
  }
}
