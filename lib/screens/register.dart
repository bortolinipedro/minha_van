import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/i18n/auth_i18n.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_text_field.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/auth_error_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await authService.value.createUserWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      // Show success message and navigate to main screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthI18n.registrationSuccess),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/');
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AuthI18n.nameRequired;
    }
    if (value.trim().length < 2) {
      return "Nome deve ter pelo menos 2 caracteres";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AuthI18n.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return AuthI18n.invalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthI18n.passwordRequired;
    }
    if (value.length < 6) {
      return AuthI18n.passwordTooShort;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AuthI18n.passwordRequired;
    }
    if (value != _passwordController.text) {
      return AuthI18n.passwordsDontMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: true,
        showBusIcon: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.xl),
                
                // Title
                Text(
                  AuthI18n.registerTitle,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                
                // Error message
                if (_errorMessage != null) ...[
                  AuthErrorMessage(
                    message: _errorMessage!,
                    onDismiss: () {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
                
                // Name field
                CustomTextField(
                  label: AuthI18n.nameLabel,
                  hint: "Digite seu nome completo",
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: _validateName,
                  prefixIcon: const Icon(Icons.person_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.md),
                
                // Email field
                CustomTextField(
                  label: AuthI18n.emailLabel,
                  hint: "seu@email.com",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.md),
                
                // Password field
                CustomTextField(
                  label: AuthI18n.passwordLabel,
                  hint: "Digite sua senha",
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                  prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.md),
                
                // Confirm Password field
                CustomTextField(
                  label: AuthI18n.confirmPasswordLabel,
                  hint: "Confirme sua senha",
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: _validateConfirmPassword,
                  prefixIcon: const Icon(Icons.lock_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.lg),
                
                // Register button
                CustomButton(
                  text: _isLoading ? "Cadastrando..." : AuthI18n.registerButton,
                  color: AppColors.primary,
                  onPressed: _isLoading ? () {} : () => _signUp(),
                  borderRadius: 10,
                  width: double.infinity,
                  height: 56,
                ),
                SizedBox(height: AppSpacing.xl),
                
                // Sign in link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AuthI18n.hasAccount,
                      style: AppTextStyles.listSubheading,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        AuthI18n.signIn,
                        style: AppTextStyles.listHeading.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 