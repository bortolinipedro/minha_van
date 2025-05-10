import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final TextEditingController _nameController = TextEditingController(
    text: 'Pedro',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'pedro@gmail.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '12345678',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '(31) 9 1111-1111',
  );
  final TextEditingController _cpfController = TextEditingController(
    text: '00.000.000-00',
  );
  final TextEditingController _numberController = TextEditingController(
    text: '1164',
  );
  final TextEditingController _cepController = TextEditingController(
    text: '30130131',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(showBackButton: true, showBusIcon: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSpacing.xl),
                Text('Perfil', style: AppTextStyles.heading),
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
                SizedBox(height: AppSpacing.lg),
                CustomButton(
                  text: 'Salvar',
                  color: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Perfil salvo com sucesso!')),
                      );
                    }
                  },
                  width: double.infinity,
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
