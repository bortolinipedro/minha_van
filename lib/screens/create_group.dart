import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_text_field.dart';
import 'package:minha_van/services/group_service.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/services/user_profile_service.dart';
import 'package:minha_van/helpers/input_masks.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? _generatedCode;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final user = authService.value.currentUser;
      if (user == null) {
        setState(() {
          _errorMessage = 'Usuário não autenticado';
          _isLoading = false;
        });
        return;
      }

      // Buscar nome do usuário
      final userProfile = await UserProfileService.getUserProfile(user.uid);
      final userName = userProfile?['nome'] ?? user.displayName ?? 'Usuário';

      // Criar grupo
      final result = await GroupService.createGroup(
        name: _nameController.text.trim(),
        creatorId: user.uid,
      );

      setState(() {
        _generatedCode = result['groupCode'];
        _successMessage = 'Grupo criado com sucesso!';
        _isLoading = false;
      });

      // Limpar formulário
      _nameController.clear();

      // Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grupo criado! Código: ${result['groupCode']}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
        ),
      );

    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao criar grupo: $e';
        _isLoading = false;
      });
    }
  }

  void _copyCodeToClipboard() {
    if (_generatedCode != null) {
      // Implementar cópia para clipboard
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código copiado para a área de transferência!'),
          backgroundColor: Colors.blue,
        ),
      );
    }
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
                  'Criar Novo Grupo',
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                
                Text(
                  'Crie um grupo e compartilhe o código com os passageiros para que eles possam solicitar entrada.',
                  style: AppTextStyles.listSubheading,
                ),
                SizedBox(height: AppSpacing.lg),
                
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
                
                // Código gerado
                if (_generatedCode != null) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Código do Grupo',
                          style: AppTextStyles.listHeading.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          _generatedCode!,
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Compartilhe este código com os passageiros',
                          style: AppTextStyles.listSubheading,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        CustomButton(
                          text: 'Copiar Código',
                          color: AppColors.primary,
                          onPressed: _copyCodeToClipboard,
                          borderRadius: 10,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],
                
                // Nome do grupo
                CustomTextField(
                  label: 'Nome do Grupo',
                  hint: 'Digite o nome do grupo',
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome do grupo é obrigatório';
                    }
                    if (value.trim().length < 3) {
                      return 'Nome deve ter pelo menos 3 caracteres';
                    }
                    return null;
                  },
                  inputFormatters: [InputMasks.textOnly],
                  prefixIcon: const Icon(Icons.group_outlined, color: AppColors.textSecondary),
                ),
                SizedBox(height: AppSpacing.lg),
                
                // Botão criar grupo
                CustomButton(
                  text: _isLoading ? 'Criando...' : 'Criar Grupo',
                  color: AppColors.primary,
                  onPressed: _isLoading ? () {} : _createGroup,
                  borderRadius: 10,
                  width: double.infinity,
                  height: 56,
                ),
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 