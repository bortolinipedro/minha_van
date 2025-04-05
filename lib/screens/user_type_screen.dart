import 'package:flutter/material.dart';
import 'login_screen.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Van')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              height: 120,
              margin: const EdgeInsets.only(bottom: 40),
              child: Image.asset('assets/images/logo.png'), // Adicione seu logo
            ),
            // Botões
            ElevatedButton(
              onPressed: () => _navigateToLogin(context, 'driver'),
              child: const Text('Sou Motorista'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToLogin(context, 'passenger'),
              child: const Text('Sou Passageiro'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context, String userType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(userType: userType)),
    );
  }
}
