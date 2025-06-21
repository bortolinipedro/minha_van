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
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: MainI18n.iAmADriver,
                        color: AppColors.secondary,
                        onPressed: () {
                          Navigator.pushNamed(context, "/driver");
                        },
                        borderRadius: 10,
                        width: double.infinity,
                        height: 145,
                        padding: const EdgeInsets.symmetric(vertical: 60),
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
                        padding: const EdgeInsets.symmetric(vertical: 60),
                      ),
                    ],
                  ),
                ),
              ),
              
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
