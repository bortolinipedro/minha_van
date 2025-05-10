import 'package:flutter/material.dart';
import 'package:minha_van/screens/register.dart';
import 'package:minha_van/screens/login.dart';
import 'package:minha_van/screens/profile.dart';
import 'package:minha_van/widgets/bottom_nav_bar.dart';
import 'package:minha_van/screens/passenger_home.dart';
import 'package:minha_van/screens/schedules.dart';
import 'package:minha_van/screens/groups_list.dart';
import 'package:minha_van/screens/about.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/i18n/main_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

void main() {
  runApp(const MinhaVanApp());
}

class MinhaVanApp extends StatelessWidget {
  const MinhaVanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/register',
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainHome(),
        '/profile': (context) => const ProfileScreen(),
        '/schedules': (context) => const Schedules(),
      },
    );
  }
}

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    PassangerHome(),
    Center(child: Text('Music', style: TextStyle(fontSize: 24))),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Options extends StatelessWidget {
  const Options({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(showBackButton: false, showBusIcon: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: MainI18n.iAmADriver,
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
                  text: MainI18n.iAmAPassenger,
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
                  onTap:
                      () => Navigator.push(
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
