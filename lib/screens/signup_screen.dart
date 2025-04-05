import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  final String userType;
  const SignupScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de ${userType == 'driver' ? 'Motorista' : 'Passageiro'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Adicione os campos específicos para cada tipo de usuário
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nome completo'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'CPF'),
            ),
            // ... outros campos
            ElevatedButton(
              onPressed: () {},
              child: const Text('Finalizar cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}