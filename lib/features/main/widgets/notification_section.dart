import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_spacing.dart';
import '../../other/widgets/main_gradient_text.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        MainGradientText(text: title),
        const SizedBox(height: AppSpacing.medium),
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          const Divider(),
        ],
        const SizedBox(height: AppSpacing.small),
      ],
    );
  }
}
