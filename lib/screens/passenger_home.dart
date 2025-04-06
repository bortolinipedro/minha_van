import 'package:flutter/material.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/passenger_home_i18n.dart';
import 'package:minha_van/screens/schedules.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class PassangerHome extends StatefulWidget {
  const PassangerHome({super.key});

  @override
  State<PassangerHome> createState() => PassangerHomeState();
}

class PassangerHomeState extends State<PassangerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBusIcon: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(PassengerHomeI18n.helloPedro, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              PassengerHomeI18n.indicateAbsencesAndChangeSchedules,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: PassengerHomeI18n.mySchedules,
              color: AppColors.secondary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Schedules()),
                );
              },
              width: double.infinity,
              borderRadius: 10,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: PassengerHomeI18n.myProfile,
              color: AppColors.secondary,
              onPressed: () {},
              width: double.infinity,
              borderRadius: 10,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              PassengerHomeI18n.yourDepartureIsConfirmed,
              style: AppTextStyles.heading,
            ),
            Text(
              PassengerHomeI18n.indicateIfNotGoingToday,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: PassengerHomeI18n.notGoingToday,
              color: AppColors.primary,
              onPressed: () {},
              width: double.infinity,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              PassengerHomeI18n.yourReturnIsConfirmed,
              style: AppTextStyles.heading,
            ),
            Text(
              PassengerHomeI18n.indicateIfNotReturningToday,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: PassengerHomeI18n.notReturningToday,
              color: AppColors.primary,
              onPressed: () {},
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
