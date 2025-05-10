import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(showBackButton: false, showBusIcon: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Minha', style: AppTextStyles.title),
                    SizedBox(width: 8),
                    Image.asset('assets/images/bus.png', height: 32),
                    SizedBox(width: 8),
                    Text('Van', style: AppTextStyles.title),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                Text('Login', style: AppTextStyles.heading),
                SizedBox(height: AppSpacing.lg),
                _buildTextField(_emailController, 'Email', false),
                SizedBox(height: AppSpacing.sm),
                _buildTextField(_passwordController, 'Senha', true),
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'Entrar',
                  color: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  width: double.infinity,
                ),
                SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Esqueci minha senha',
                    style: AppTextStyles.subHeading.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  'Ainda não possui uma conta?',
                  style: AppTextStyles.subHeading.copyWith(fontSize: 14),
                ),
                TextButton(
                  onPressed:
                      () =>
                          Navigator.pushReplacementNamed(context, '/register'),
                  child: Text(
                    'Criar sua conta',
                    style: AppTextStyles.buttonText.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    bool isPassword,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                )
                : null,
        filled: true,
        fillColor: AppColors.auxiliar,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Campo obrigatório' : null,
    );
  }
}
