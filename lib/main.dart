import 'package:flutter/material.dart';
import 'package:minha_van/screens/passenger_home.dart';
import 'package:minha_van/screens/groups_list.dart';
import 'package:minha_van/screens/about.dart';
import 'package:minha_van/screens/login.dart';
import 'package:minha_van/screens/register.dart';
import 'package:minha_van/screens/forgot_password.dart';
import 'package:minha_van/screens/profile.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/i18n/main_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/widgets/auth_guard.dart';
import 'package:minha_van/widgets/user_info.dart';
import 'package:minha_van/widgets/auth_status.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const AuthWrapper(),
    routes: {
      "/driver": (context) => const AuthGuard(child: GroupsList()),
      "/passanger": (context) => const AuthGuard(child: PassangerHome()),
      "/login": (context) => const LoginScreen(),
      "/register": (context) => const RegisterScreen(),
      "/forgot-password": (context) => const ForgotPasswordScreen(),
      "/profile": (context) => const AuthGuard(child: ProfileScreen()),
    },
  ));
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.value.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in, show main options
          return const Options();
        } else {
          // User is not logged in, show login screen
          return const LoginScreen();
        }
      },
    );
  }
}

class Options extends StatelessWidget {
  const Options({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: false,
        showBusIcon: true,
        actions: const [
          AuthStatus(),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.md),
              // User info
              const UserInfo(),
              // Main options
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/driver"),
                      child: Container(
                        width: double.infinity,
                        height: 145,
                        margin: EdgeInsets.only(bottom: AppSpacing.md),
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.08),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_bus_filled_rounded, size: 48, color: Colors.white),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Home Motorista',
                              style: AppTextStyles.heading.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/passanger"),
                      child: Container(
                        width: double.infinity,
                        height: 145,
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.08),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.emoji_people_rounded, size: 48, color: Colors.white),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Home Passageiro',
                              style: AppTextStyles.heading.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // About link
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
    );
  }
}
