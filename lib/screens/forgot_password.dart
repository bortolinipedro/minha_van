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
import 'package:minha_van/widgets/auth_success_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await authService.value.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      setState(() {
        _successMessage = result.successMessage;
      });
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
      });
    }
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
                  AuthI18n.forgotPasswordTitle,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                
                // Description
                Text(
                  AuthI18n.forgotPasswordDescription,
                  style: AppTextStyles.listSubheading.copyWith(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                
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
                
                // Success message
                if (_successMessage != null) ...[
                  AuthSuccessMessage(
                    message: _successMessage!,
                    onDismiss: () {
                      setState(() {
                        _successMessage = null;
                      });
                    },
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
                
                // Email field
                CustomTextField(
                  label: AuthI18n.emailLabel,
                  hint: "seu@email.com",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.lg),
                
                // Send reset link button
                CustomButton(
                  text: _isLoading ? "Enviando..." : AuthI18n.sendResetLink,
                  color: AppColors.primary,
                  onPressed: _isLoading ? () {} : () => _sendResetEmail(),
                  borderRadius: 10,
                  width: double.infinity,
                  height: 50,
                ),
                SizedBox(height: AppSpacing.xl),
                
                // Back to login link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(
                      AuthI18n.backToLogin,
                      style: AppTextStyles.listHeading.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
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