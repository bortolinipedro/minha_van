import 'package:flutter/material.dart';
import 'package:minha_van/screens/passenger_home.dart';
import 'package:minha_van/screens/groups_list.dart';
import 'package:minha_van/screens/about.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/i18n/main_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Options(),
    routes: {
      "/driver": (context) => GroupsList(),
      "/passanger": (context) => PassangerHome(),
    },
  ));
}

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: false,
        showBusIcon: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: MainI18n.I_AM_A_DRIVER,
                  color: AppColors.secondary,
                  onPressed: () {
                    Navigator.pushNamed(context, "/driver");
                  },
                  borderRadius: 10,
                  width: double.infinity,
                  height: 145,
                ),
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: MainI18n.I_AM_A_PASSENGER,
                  color: AppColors.primary,
                  onPressed: () {
                    Navigator.pushNamed(context, "/passanger");
                  },
                  borderRadius: 10,
                  width: double.infinity,
                  height: 145,
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const About()),
                  ),
                  child: Text(
                    'Sobre o app',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
