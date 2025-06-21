import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_text_field.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/widgets/auth_status.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = false;
  bool _isEditing = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = authService.value.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await authService.value.updateDisplayName(_nameController.text.trim());

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      setState(() {
        _successMessage = result.successMessage;
        _isEditing = false;
      });
      
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.successMessage ?? 'Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
      });
    }
  }

  Future<void> _changePassword() async {
    final user = authService.value.currentUser;
    if (user?.email == null) return;

    try {
      await authService.value.sendPasswordResetEmail(user!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email de redefinição de senha enviado!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar email: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBusIcon: true,
        actions: const [
          AuthStatus(),
        ],
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
                  'Meu Perfil',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                
                // User Avatar
                Center(
                  child: ValueListenableBuilder<AuthService>(
                    valueListenable: authService,
                    builder: (context, auth, child) {
                      final user = auth.currentUser;
                      if (user == null) return const SizedBox.shrink();
                      
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              user.displayName?.isNotEmpty == true 
                                ? user.displayName![0].toUpperCase()
                                : user.email![0].toUpperCase(),
                              style: AppTextStyles.heading.copyWith(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            user.displayName ?? 'Usuário',
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            user.email ?? '',
                            style: AppTextStyles.listSubheading,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                
                // Error message
                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: AppTextStyles.listHeading.copyWith(
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
                
                // Success message
                if (_successMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      _successMessage!,
                      style: AppTextStyles.listHeading.copyWith(
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
                
                // Name field
                CustomTextField(
                  label: 'Nome',
                  hint: "Digite seu nome completo",
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  enabled: _isEditing,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    if (value.trim().length < 2) {
                      return 'Nome deve ter pelo menos 2 caracteres';
                    }
                    return null;
                  },
                  prefixIcon: const Icon(Icons.person_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.md),
                
                // Email field (read-only)
                CustomTextField(
                  label: 'Email',
                  hint: "seu@email.com",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: false, // Email não pode ser editado
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.lg),
                
                // Action buttons
                if (_isEditing) ...[
                  // Save and Cancel buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancelar',
                          color: AppColors.auxiliar,
                          textColor: AppColors.textPrimary,
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _loadUserData(); // Reset to original values
                            });
                          },
                          borderRadius: 10,
                          height: 56,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: CustomButton(
                          text: _isLoading ? 'Salvando...' : 'Salvar',
                          color: AppColors.primary,
                          onPressed: _isLoading ? () {} : () => _updateProfile(),
                          borderRadius: 10,
                          height: 56,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Edit button
                  CustomButton(
                    text: 'Editar Perfil',
                    color: AppColors.primary,
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    borderRadius: 10,
                    width: double.infinity,
                    height: 56,
                  ),
                  SizedBox(height: AppSpacing.md),
                  
                  // Change password button
                  CustomButton(
                    text: 'Alterar Senha',
                    color: AppColors.secondary,
                    onPressed: () => _changePassword(),
                    borderRadius: 10,
                    width: double.infinity,
                    height: 56,
                  ),
                ],
                
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 