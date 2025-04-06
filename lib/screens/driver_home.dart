import 'package:flutter/material.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/i18n/driver_home_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => DriverHomeState();
}

class DriverHomeState extends State<DriverHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBusIcon: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              DriverHomeI18n.welcomeDriver,
              style: AppTextStyles.heading,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              DriverHomeI18n.manageVanAndPassengers,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: DriverHomeI18n.backToHomeScreen,
              color: AppColors.secondary,
              onPressed: () {
                Navigator.pushNamed(context, "/");
              },
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
