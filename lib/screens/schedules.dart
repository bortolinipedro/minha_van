import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/schedules_i18n.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class Schedules extends StatefulWidget {
  const Schedules({super.key});

  @override
  State<Schedules> createState() => SchedulesState();
}

class SchedulesState extends State<Schedules> {
  List<bool> goingDays = List.filled(7, false);
  List<bool> returnDays = List.filled(7, false);

  Widget _buildDayButton(int index, bool isSelected, Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: CustomButton(
        text: SchedulesI18n.weekDays[index],
        color: isSelected ? AppColors.secondary : AppColors.auxiliar,
        textColor: isSelected ? AppColors.white : AppColors.textPrimary,
        onPressed: () => onChanged(!isSelected),
        width: double.infinity,
        borderRadius: 25,
        fontSize: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(showBusIcon: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(SchedulesI18n.goingDays, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              SchedulesI18n.selectGoingDays,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            ...List.generate(
              7,
              (index) => _buildDayButton(
                index,
                goingDays[index],
                (value) => setState(() => goingDays[index] = value),
              ),
            ),

            SizedBox(height: AppSpacing.sm),

            Text(SchedulesI18n.returnDays, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              SchedulesI18n.selectReturnDays,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            ...List.generate(
              7,
              (index) => _buildDayButton(
                index,
                returnDays[index],
                (value) => setState(() => returnDays[index] = value),
              ),
            ),

            SizedBox(height: AppSpacing.sm),

            CustomButton(
              text: SchedulesI18n.save,
              color: AppColors.primary,
              onPressed: () => Navigator.pop(context),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
