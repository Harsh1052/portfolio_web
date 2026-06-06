import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../visitor/presentation/widgets/visitor_count_badge.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentWrapper(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(color: AppColors.border, thickness: 1, height: 1),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Harsh Sureja · ${DateTime.now().year} · Built in Flutter Web',
                    style: AppTextStyles.caption,
                  ),
                ),
                const VisitorCountBadge(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
