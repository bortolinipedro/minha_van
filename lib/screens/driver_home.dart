import 'package:flutter/material.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/i18n/driver_home_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/widgets/auth_status.dart';

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
        showBackButton: true,
        showBusIcon: true,
        actions: const [
          AuthStatus(),
        ],
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
            SizedBox(height: AppSpacing.lg),
            
            // Botão para gerenciar grupos
            CustomButton(
              text: 'Gerenciar Grupos',
              color: AppColors.primary,
              onPressed: () {
                Navigator.pushNamed(context, "/driver");
              },
              width: double.infinity,
              height: 56,
            ),
            SizedBox(height: AppSpacing.md),
            
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
