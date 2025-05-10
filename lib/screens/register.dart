import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptPrivacy = false;
  bool _obscurePassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

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
                Text('Registrar', style: AppTextStyles.heading),
                SizedBox(height: AppSpacing.lg),
                _buildTextField(_nameController, 'Nome', Icons.check, false),
                SizedBox(height: AppSpacing.sm),
                _buildTextField(_cepController, 'CEP', Icons.check, false),
                SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  _numberController,
                  'Número',
                  Icons.check,
                  false,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildTextField(_cpfController, 'CPF', Icons.check, false),
                SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  _phoneController,
                  'Telefone',
                  Icons.check,
                  false,
                ),
                SizedBox(height: AppSpacing.sm),
                _buildTextField(_emailController, 'Email', Icons.check, false),
                SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  _passwordController,
                  'Senha',
                  Icons.check,
                  true,
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptPrivacy,
                      onChanged:
                          (v) => setState(() => _acceptPrivacy = v ?? false),
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Li e aceito as ',
                          style: AppTextStyles.subHeading.copyWith(
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Políticas de Privacidade',
                              style: AppTextStyles.subHeading.copyWith(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'Registrar',
                  color: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _acceptPrivacy) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  width: double.infinity,
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Possui uma conta?',
                      style: AppTextStyles.subHeading.copyWith(fontSize: 14),
                    ),
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                      child: Text(
                        'Entrar',
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
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
    IconData icon,
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
                : Icon(icon, color: AppColors.secondary),
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
