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
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Schedules()),
      );
      setState(() {
        _selectedIndex = 1;
      });
    } else if (index == 2) {
      setState(() {
        _selectedIndex = 1;
      });
    }
  }

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
            SizedBox(height: AppSpacing.md),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: PassengerHomeI18n.mySchedules,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: PassengerHomeI18n.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: PassengerHomeI18n.myProfile,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        backgroundColor:  AppColors.navbar,
        onTap: _onItemTapped,
      ),
    );
  }
}