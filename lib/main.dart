import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/passangers_screen.dart';

void main() {
  runApp(const MinhaVanApp());
}

// Classe principal do aplicativo
class MinhaVanApp extends StatelessWidget {
  const MinhaVanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Van',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      // Define a rota inicial como a tela de login
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(userType: ''), // Tela de login
        '/grupos':
            (context) =>
                GruposPassageirosPage(), // Tela de grupos de passageiros
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
