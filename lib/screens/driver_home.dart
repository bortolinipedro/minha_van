import 'package:flutter/material.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/i18n/driver_home_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class DriverHome extends StatefulWidget {
  @override
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
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
              DriverHomeI18n.WELCOME_DRIVER,
              style: AppTextStyles.heading,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              DriverHomeI18n.MANAGE_VAN_AND_PASSENGERS,
              style: AppTextStyles.subHeading,
            ),
            SizedBox(height: AppSpacing.sm),
            CustomButton(
              text: DriverHomeI18n.BACK_TO_HOME_SCREEN,
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
