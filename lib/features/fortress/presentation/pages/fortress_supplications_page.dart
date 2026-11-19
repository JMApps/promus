import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/fortress_chapter_entity.dart';
import '../../domain/entities/fortress_supplication_entity.dart';
import '../states/fortress_chapters_state.dart';
import '../states/fortress_supplications_state.dart';
import 'page_mode_supplications_page.dart';
import 'vertical_mode_supplications_page.dart';

/// Экран главы Крепости: загружает мольбы и выбирает режим показа.
///
/// Вся работа с состоянием здесь, а экраны режимов только рисуют то,
/// что им передали. Поэтому загрузка запускается один раз и не
/// повторяется при переключении режима.
class FortressSupplicationsPage extends StatefulWidget {
  const FortressSupplicationsPage({
    super.key,
    required this.chapterId,
  });

  final int chapterId;

  @override
  State<FortressSupplicationsPage> createState() =>
      _FortressSupplicationsPageState();
}

class _FortressSupplicationsPageState extends State<FortressSupplicationsPage> {
  @override
  void initState() {
    super.initState();
    final state = context.read<FortressSupplicationState>();
    if (state.cachedSupplicationsByChapter(widget.chapterId) != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await state.loadSupplicationsByChapter(widget.chapterId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageMode = context.select<FortressSupplicationState, bool>(
      (s) => s.pageMode,
    );
    final chapter = context.select<FortressChapterState, FortressChapterEntity?>(
          (s) => s.chapterById(widget.chapterId),
    );
    final supplications = context.select<FortressSupplicationState, List<FortressSupplicationEntity>?>(
          (s) => s.cachedSupplicationsByChapter(widget.chapterId),
    );
    // Ошибку показываем, только если данных нет и загрузка уже закончилась.
    final hasError = context.select<FortressSupplicationState, bool>(
      (s) => supplications == null && s.error != null && !s.isLoading,
    );
    void toggleMode() => context.read<FortressSupplicationState>().changePageMode();
    return pageMode ? PageModeSupplicationsPage(
      chapter: chapter,
      supplications: supplications,
      hasError: hasError,
      onToggleMode: toggleMode,
    ) : VerticalModeSupplicationsPage(
      chapter: chapter,
      supplications: supplications,
      hasError: hasError,
      onToggleMode: toggleMode,
    );
  }
}
