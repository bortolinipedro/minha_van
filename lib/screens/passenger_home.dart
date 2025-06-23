import 'package:flutter/material.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/passenger_home_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/services/group_service.dart';
import 'package:minha_van/widgets/auth_status.dart';
import 'package:minha_van/widgets/custom_text_field.dart';
import 'package:minha_van/services/user_profile_service.dart';
import 'package:minha_van/helpers/input_masks.dart';
import 'package:minha_van/screens/group_details.dart';
import 'package:minha_van/services/schedule_service.dart';

class PassangerHome extends StatefulWidget {
  const PassangerHome({super.key});

  @override
  State<PassangerHome> createState() => _PassangerHomeState();
}

class _PassangerHomeState extends State<PassangerHome> {
  List<Map<String, dynamic>> _userGroups = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // Controllers para solicitar entrada
  final _codeController = TextEditingController();
  bool _isRequesting = false;
  String? _requestMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = authService.value.currentUser;
      if (user != null) {
        final groups = await GroupService.getGroupsUserParticipates(user.uid);
        setState(() {
          _userGroups = groups;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar grupos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _requestJoinGroup() async {
    if (_codeController.text.trim().isEmpty) return;

    setState(() {
      _isRequesting = true;
      _requestMessage = null;
    });

    try {
      final user = authService.value.currentUser;
      if (user == null) {
        setState(() {
          _requestMessage = 'Usuário não autenticado';
          _isRequesting = false;
        });
        return;
      }

      // Solicitar entrada no grupo
      final success = await GroupService.requestJoinGroup(
        groupCode: _codeController.text.trim().toUpperCase(),
        userId: user.uid,
      );

      if (success) {
        setState(() {
          _requestMessage = 'Solicitação enviada com sucesso! Aguarde a aprovação do motorista.';
          _codeController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitação enviada! Aguarde a aprovação do motorista.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _requestMessage = 'Código inválido ou você já é membro deste grupo.';
        });
      }
    } catch (e) {
      setState(() {
        _requestMessage = 'Erro ao solicitar entrada: $e';
      });
    } finally {
      setState(() {
        _isRequesting = false;
      });
    }
  }

  void _showLeaveGroupDialog(String groupId, String groupName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do Grupo'),
        content: Text('Tem certeza que deseja sair do grupo "$groupName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final user = authService.value.currentUser;
                if (user != null) {
                  await GroupService.leaveGroup(
                    groupId: groupId,
                    userId: user.uid,
                  );
                  await _loadUserData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Você saiu do grupo "$groupName"'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao sair do grupo: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<String> _getTodayScheduleInfo(Map<String, dynamic> group) async {
    try {
      final user = authService.value.currentUser;
      if (user == null) return 'Usuário não autenticado';

      final schedule = await ScheduleService.getTodaySchedule(
        groupId: group['groupId'] ?? group['id'],
        userId: user.uid,
      );

      if (schedule == null) {
        return 'Hoje: Sem viagem programada';
      }

      final going = schedule['going'] as Map<String, dynamic>?;
      final returning = schedule['returning'] as Map<String, dynamic>?;

      final goingConfirmed = going?['confirmed'] == true;
      final returningConfirmed = returning?['confirmed'] == true;

      if (goingConfirmed && returningConfirmed) {
        return 'Hoje: Ida ${going?['time'] ?? 'N/A'} | Volta ${returning?['time'] ?? 'N/A'}';
      } else if (goingConfirmed) {
        return 'Hoje: Ida ${going?['time'] ?? 'N/A'} | Sem volta';
      } else if (returningConfirmed) {
        return 'Hoje: Sem ida | Volta ${returning?['time'] ?? 'N/A'}';
      } else {
        return 'Hoje: Sem viagem programada';
      }
    } catch (e) {
      print('Erro ao buscar schedule de hoje: $e');
      return 'Hoje: Erro ao carregar horários';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: true,
        showBusIcon: true,
        actions: const [
          AuthStatus(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Meus Grupos',
                style: AppTextStyles.heading.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Gerencie seus grupos e horários de viagem',
                style: AppTextStyles.listSubheading,
              ),
              SizedBox(height: AppSpacing.lg),

              // Loading ou erro
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.listSubheading.copyWith(
                      color: Colors.red.shade700,
                    ),
                  ),
                )
              else if (_userGroups.isEmpty) ...[
                // Mensagem quando não há grupos
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.auxiliar,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.group_outlined,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'Você não participa de nenhum grupo',
                        style: AppTextStyles.listHeading.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'Use o código fornecido pelo motorista para solicitar entrada',
                        style: AppTextStyles.listSubheading,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Lista de grupos
                ...(_userGroups.map((group) => Card(
                  margin: EdgeInsets.only(bottom: AppSpacing.md),
                  child: InkWell(
                    onTap: () {
                      // Navegar para detalhes do grupo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupDetails(
                            groupId: group['groupId'] ?? group['id'],
                            groupName: group['name'] ?? 'Grupo',
                            groupColor: AppColors.primary,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primary,
                                child: Text(
                                  group['name']?[0]?.toUpperCase() ?? 'G',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      group['name'] ?? 'Grupo',
                                      style: AppTextStyles.listHeading.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.xs),
                                    Text(
                                      'Código: ${group['groupCode'] ?? 'N/A'}',
                                      style: AppTextStyles.listSubheading.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                                onPressed: () => _showLeaveGroupDialog(
                                  group['groupId'] ?? group['id'],
                                  group['name'] ?? 'Grupo',
                                ),
                                tooltip: 'Sair do grupo',
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.sm),
                          FutureBuilder<String>(
                            future: _getTodayScheduleInfo(group),
                            builder: (context, snapshot) {
                              return Container(
                                padding: EdgeInsets.all(AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.schedule,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: AppSpacing.xs),
                                    Expanded(
                                      child: Text(
                                        snapshot.data ?? 'Carregando...',
                                        style: AppTextStyles.listSubheading.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )).toList()),
              ],
              
              SizedBox(height: AppSpacing.xl),
              
              // Seção para solicitar entrada em novo grupo
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entrar em um Novo Grupo',
                      style: AppTextStyles.listHeading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Digite o código do grupo fornecido pelo motorista',
                      style: AppTextStyles.listSubheading,
                    ),
                    SizedBox(height: AppSpacing.lg),
                    
                    // Campo de código
                    CustomTextField(
                      label: 'Código do Grupo',
                      hint: 'Ex: ABC123',
                      controller: _codeController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [InputMasks.groupCodeMask],
                      prefixIcon: const Icon(Icons.group_add, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: AppSpacing.md),
                    
                    // Botão de entrar
                    CustomButton(
                      text: _isRequesting ? 'Solicitando...' : 'Solicitar Entrada',
                      color: AppColors.primary,
                      onPressed: _isRequesting ? () {} : _requestJoinGroup,
                      borderRadius: 10,
                      height: 56,
                      width: double.infinity,
                    ),
                    
                    if (_requestMessage != null) ...[
                      SizedBox(height: AppSpacing.md),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: _requestMessage!.contains('sucesso') 
                              ? Colors.green.shade50 
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _requestMessage!.contains('sucesso') 
                                ? Colors.green.shade200 
                                : Colors.red.shade200,
                          ),
                        ),
                        child: Text(
                          _requestMessage!,
                          style: AppTextStyles.listSubheading.copyWith(
                            color: _requestMessage!.contains('sucesso') 
                                ? Colors.green.shade700 
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}