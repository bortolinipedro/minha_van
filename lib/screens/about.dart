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
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AboutI18n.MEMBERS, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              AboutI18n.MEMBERS_LIST, 
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.justify,
            ),
            
            SizedBox(height: AppSpacing.sm),
            Text(AboutI18n.OBJECTIVE, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              AboutI18n.OBJECTIVE_TEXT, 
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.justify,
            ),
            
            SizedBox(height: AppSpacing.sm),
            Text(AboutI18n.TARGET_AUDIENCE, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              AboutI18n.TARGET_AUDIENCE_LIST, 
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.justify,
            ),
            
            SizedBox(height: AppSpacing.sm),
            Text(AboutI18n.MAIN_FEATURES, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              AboutI18n.FEATURES_LIST, 
              style: AppTextStyles.subHeading,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
