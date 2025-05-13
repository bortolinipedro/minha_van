import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/schedules_i18n.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/helpers/sql_helper.dart';

class Schedules extends StatefulWidget {
  const Schedules({super.key});

  @override
  State<Schedules> createState() => SchedulesState();
}

class SchedulesState extends State<Schedules> {
  static const int MORNING_SHIFT = 0;
  static const int AFTERNOON_SHIFT = 1;
  List<bool> morningDays = List.filled(7, false);
  List<bool> afternoonDays = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final morningSchedules = await SQLHelper.getSchedules(MORNING_SHIFT);
    final afternoonSchedules = await SQLHelper.getSchedules(AFTERNOON_SHIFT);

    setState(() {
      morningDays = List.filled(7, false);
      afternoonDays = List.filled(7, false);

      for (var schedule in morningSchedules) {
        if (schedule['active'] == 1) {
          morningDays[schedule['day']] = true;
        }
      }

      for (var schedule in afternoonSchedules) {
        if (schedule['active'] == 1) {
          afternoonDays[schedule['day']] = true;
        }
      }
    });
  }

  Future<void> _updateSchedule(int dayIndex, bool value, int shift) async {
    await SQLHelper.updateSchedule(dayIndex, shift, value);
    if (shift == MORNING_SHIFT) {
      setState(() => morningDays[dayIndex] = value);
    } else {
      setState(() => afternoonDays[dayIndex] = value);
    }
  }

  Widget _buildDayButton(int index, bool isSelected, int shift) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: CustomButton(
        text: SchedulesI18n.weekDays[index],
        color: isSelected ? AppColors.secondary : AppColors.auxiliar,
        textColor: isSelected ? AppColors.white : AppColors.textPrimary,
        onPressed: () => _updateSchedule(index, !isSelected, shift),
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
                morningDays[index],
                MORNING_SHIFT,
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
                afternoonDays[index],
                AFTERNOON_SHIFT,
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
