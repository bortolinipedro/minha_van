import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final String userType; // Tipo de usuário (motorista ou passageiro)

  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  final _emailController =
      TextEditingController(); // Controlador do campo de email
  final _passwordController =
      TextEditingController(); // Controlador do campo de senha
  bool _obscurePassword = true; // Controla a visibilidade da senha

  @override
  void dispose() {
    // Libera os controladores ao sair da tela
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Valida o formulário e navega para a tela de grupos
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/grupos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Container(
                height: 120,
                margin: const EdgeInsets.only(bottom: 40),
                child: Image.asset('assets/images/logo.png'),
              ),

              // Campo de Email
              const Text('Email'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Campo de Senha
              const Text('Senha'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  if (value.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Botão Entrar
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Entrar'),
              ),
              const SizedBox(height: 20),

              // Links
              TextButton(
                onPressed: () {},
                child: const Text('Esqueci minha senha'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ainda não possui uma conta?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Criar sua conta'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
