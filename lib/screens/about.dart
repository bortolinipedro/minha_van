import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/about_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        showBusIcon: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: AppSpacing.lg),
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Icon(Icons.directions_bus_filled_rounded, size: 40, color: AppColors.primary),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            _AboutSection(
              title: AboutI18n.members,
              content: AboutI18n.membersList,
            ),
            SizedBox(height: AppSpacing.md),
            _AboutSection(
              title: AboutI18n.objective,
              content: AboutI18n.objectiveText,
            ),
            SizedBox(height: AppSpacing.md),
            _AboutSection(
              title: AboutI18n.targetAudience,
              content: AboutI18n.targetAudienceList,
            ),
            SizedBox(height: AppSpacing.md),
            _AboutSection(
              title: AboutI18n.mainFeatures,
              content: AboutI18n.featuresList,
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String title;
  final String content;
  const _AboutSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.heading.copyWith(fontSize: 20)),
            SizedBox(height: AppSpacing.sm),
            Text(
              content,
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
