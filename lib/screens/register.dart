import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/custom_button.dart';

class RegisterDriverScreen extends StatefulWidget {
  const RegisterDriverScreen({super.key});

  @override
  State<RegisterDriverScreen> createState() => _RegisterDriverScreenState();
}

class _RegisterDriverScreenState extends State<RegisterDriverScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedPrivacy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 32),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    const Text(
                      'Minha',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF393A4A),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.directions_bus,
                      size: 32,
                      color: Color(0xFF393A4A),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Van',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF393A4A),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF393A4A),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField(
                  controller: _nameController,
                  label: 'Pedro',
                  icon: Icons.check,
                  obscure: false,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'pedro@gmail.com',
                  icon: Icons.check,
                  obscure: false,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: '********',
                  icon: null,
                  obscure: _obscurePassword,
                  isPassword: true,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedPrivacy,
                      onChanged: (value) {
                        setState(() {
                          _acceptedPrivacy = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Li e aceito as ',
                          style: TextStyle(color: Color(0xFFB0B0C3)),
                          children: [
                            TextSpan(
                              text: 'Políticas de Privacidade',
                              style: TextStyle(color: Color(0xFF7B83FF)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _acceptedPrivacy ? _onRegister : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B83FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Registrar',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Possui uma conta?',
                        style: TextStyle(
                          color: Color(0xFFB0B0C3),
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navegar para tela de login
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            color: Color(0xFF7B83FF),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscure = false,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xFFB0B0C3),
                    ),
                    onPressed: onToggleVisibility,
                  )
                  : (icon != null
                      ? Icon(icon, color: const Color(0xFFB0B0C3))
                      : null),
        ),
        style: const TextStyle(fontSize: 18, color: Color(0xFF393A4A)),
      ),
    );
  }

  void _onRegister() {
    // TODO: Implementar lógica de registro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro realizado com sucesso!')),
    );
  }
}

class RegisterPassengerScreen extends StatefulWidget {
  const RegisterPassengerScreen({super.key});

  @override
  State<RegisterPassengerScreen> createState() =>
      _RegisterPassengerScreenState();
}

class _RegisterPassengerScreenState extends State<RegisterPassengerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptedPrivacy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _matriculaController.dispose();
    _numeroController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(showBackButton: true, showBusIcon: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Text(
                    'Registrar',
                    style: AppTextStyles.heading.copyWith(fontSize: 32),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(controller: _nameController, label: 'Pedro'),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _matriculaController,
                  label: '30130131',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(controller: _numeroController, label: '1164'),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _cpfController,
                  label: '00.000.000-00',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _phoneController,
                  label: '(31) 9 1111-1111',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _emailController,
                  label: 'pedro@gmail.com',
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildTextField(
                  controller: _passwordController,
                  label: '********',
                  obscure: _obscurePassword,
                  isPassword: true,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedPrivacy,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _acceptedPrivacy = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Li e aceito as ',
                          style: AppTextStyles.listSubheading,
                          children: [
                            TextSpan(
                              text: 'Políticas de Privacidade',
                              style: AppTextStyles.listSubheading.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                CustomButton(
                  text: 'Registrar',
                  color: AppColors.primary,
                  onPressed: _acceptedPrivacy ? _onRegister : null,
                  width: double.infinity,
                  height: 60,
                  borderRadius: 30,
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscure = false,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.auxiliar,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: onToggleVisibility,
                  )
                  : Icon(Icons.check, color: Colors.green),
        ),
        style: AppTextStyles.listHeading.copyWith(fontSize: 18),
      ),
    );
  }

  void _onRegister() {
    // TODO: Implementar lógica de registro do passageiro
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro realizado com sucesso!')),
    );
  }
}
