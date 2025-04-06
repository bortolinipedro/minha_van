import 'package:flutter/material.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/passenger_home_i18n.dart';
import 'package:minha_van/screens/schedules.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class PassangerHome extends StatefulWidget {
  @override
  _PassangerHomeState createState() => _PassangerHomeState();
}

class _PassangerHomeState extends State<PassangerHome> {
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
            Text(PassengerHomeI18n.HELLO_PEDRO, style: AppTextStyles.heading),
            SizedBox(height: AppSpacing.sm),
            Text(
              PassengerHomeI18n.INDICATE_ABSENCES_AND_CHANGE_SCHEDULES,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: PassengerHomeI18n.MY_SCHEDULES,
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
              text: PassengerHomeI18n.MY_PROFILE,
              color: AppColors.secondary,
              onPressed: () {},
              width: double.infinity,
              borderRadius: 10,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              PassengerHomeI18n.YOUR_DEPARTURE_IS_CONFIRMED,
              style: AppTextStyles.heading,
            ),
            Text(
              PassengerHomeI18n.INDICATE_IF_NOT_GOING_TODAY,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: PassengerHomeI18n.NOT_GOING_TODAY,
              color: AppColors.primary,
              onPressed: () {},
              width: double.infinity,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              PassengerHomeI18n.YOUR_RETURN_IS_CONFIRMED,
              style: AppTextStyles.heading,
            ),
            Text(
              PassengerHomeI18n.INDICATE_IF_NOT_RETURNING_TODAY,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: PassengerHomeI18n.NOT_RETURNING_TODAY,
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
