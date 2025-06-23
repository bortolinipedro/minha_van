import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/widgets/custom_text_field.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/services/group_service.dart';
import 'package:minha_van/services/schedule_service.dart';
import 'package:minha_van/services/user_profile_service.dart';
import 'package:minha_van/widgets/auth_status.dart';
import 'package:minha_van/widgets/schedule_item.dart';
import 'package:minha_van/widgets/group_info_card.dart';

class PassengerGroupDetails extends StatefulWidget {
  final String groupId;
  final String groupName;
  final Color groupColor;

  const PassengerGroupDetails({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupColor,
  });

  @override
  State<PassengerGroupDetails> createState() => _PassengerGroupDetailsState();
}

class _PassengerGroupDetailsState extends State<PassengerGroupDetails>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  Map<String, dynamic>? _groupData;
  List<Map<String, dynamic>> _userSchedules = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;
  String? _userName;

  // Controllers para configuração de horários
  final List<TextEditingController> _goingLocationControllers = List.generate(7, (_) => TextEditingController());
  final List<TextEditingController> _returningLocationControllers = List.generate(7, (_) => TextEditingController());

  // Estados dos switches
  final List<bool> _goingEnabled = List.filled(7, false);
  final List<bool> _returningEnabled = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadGroupData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _goingLocationControllers) controller.dispose();
    for (final controller in _returningLocationControllers) controller.dispose();
    super.dispose();
  }

  Future<void> _loadGroupData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
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

      _currentUserId = user.uid;

      // Buscar nome do usuário
      final userProfile = await UserProfileService.getUserProfile(user.uid);
      debugPrint('UserProfile carregado: $userProfile');
      debugPrint('UID do usuário: ${user.uid}');
      
      if (userProfile != null) {
        _userName = userProfile['nome'] ?? userProfile['fullName'] ?? 'Usuário';
        debugPrint('Nome encontrado no perfil: $_userName');
      } else {
        _userName = 'Usuário';
        debugPrint('Perfil não encontrado, usando nome padrão: $_userName');
      }

      // Buscar dados do grupo
      final groupData = await GroupService.getGroupById(widget.groupId);
      if (groupData != null) {
        setState(() {
          _groupData = groupData;
        });

        // Buscar schedules do usuário
        await _loadUserSchedules();
      } else {
        setState(() {
          _errorMessage = 'Grupo não encontrado';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserSchedules() async {
    try {
      debugPrint('Carregando schedules para usuário $_currentUserId no grupo ${widget.groupId}');
      
      final schedules = await ScheduleService.getUserSchedulesInGroup(
        groupId: widget.groupId,
        userId: _currentUserId!,
      );
      
      debugPrint('Schedules carregados: ${schedules.length}');
      for (final schedule in schedules) {
        debugPrint('Schedule: ${schedule['dayOfWeek']} - ${schedule['scheduleId']} - ${schedule['userName']}');
        debugPrint('  Going: ${schedule['going']}');
        debugPrint('  Returning: ${schedule['returning']}');
      }
      
      setState(() {
        _userSchedules = schedules;
      });
      
      // Preencher os controllers com os dados existentes
      _populateControllers();
      
      debugPrint('Schedules do usuário carregados: ${schedules.length}');
    } catch (e) {
      debugPrint('Erro ao carregar schedules do usuário: $e');
      setState(() {
        _userSchedules = [];
      });
    }
  }

  void _populateControllers() {
    debugPrint('Populando controllers com ${_userSchedules.length} schedules');
    
    // Reset todos os controllers primeiro
    for (int i = 0; i < 7; i++) {
      _goingEnabled[i] = false;
      _returningEnabled[i] = false;
      _goingLocationControllers[i].clear();
      _returningLocationControllers[i].clear();
    }
    
    for (int i = 0; i < 7; i++) {
      final dayOfWeek = i + 1;
      
      // Buscar schedule para este dia específico
      Map<String, dynamic>? schedule;
      for (final s in _userSchedules) {
        if (s['dayOfWeek'] == dayOfWeek) {
          schedule = s;
          break;
        }
      }

      debugPrint('Dia $dayOfWeek: ${schedule != null ? 'encontrado' : 'não encontrado'}');

      if (schedule != null) {
        debugPrint('Schedule encontrado para dia $dayOfWeek: $schedule');
        
        // Converter os dados para o tipo correto
        final goingRaw = schedule['going'];
        final returningRaw = schedule['returning'];
        
        Map<String, dynamic> going = {};
        Map<String, dynamic> returning = {};
        
        if (goingRaw is Map) {
          going = Map<String, dynamic>.from(goingRaw);
        }
        if (returningRaw is Map) {
          returning = Map<String, dynamic>.from(returningRaw);
        }

        debugPrint('Going para dia $dayOfWeek: $going');
        debugPrint('Returning para dia $dayOfWeek: $returning');

        _goingEnabled[i] = going['enabled'] == true;
        _returningEnabled[i] = returning['enabled'] == true;

        _goingLocationControllers[i].text = (going['pickupLocation'] ?? '').toString();
        _returningLocationControllers[i].text = (returning['pickupLocation'] ?? '').toString();

        debugPrint('Dia $dayOfWeek - Ida: ${_goingEnabled[i]}, Volta: ${_returningEnabled[i]}');
        debugPrint('Dia $dayOfWeek - Local Ida: "${_goingLocationControllers[i].text}", Local Volta: "${_returningLocationControllers[i].text}"');
      }
    }
    
    // Forçar rebuild da UI
    setState(() {});
  }

  Future<void> _saveSchedules() async {
    try {
      setState(() {
        _isLoading = true;
      });

      debugPrint('Salvando schedules para usuário $_currentUserId no grupo ${widget.groupId}');

      for (int i = 0; i < 7; i++) {
        final dayOfWeek = i + 1;
        
        final going = {
          'enabled': _goingEnabled[i],
          'time': '',
          'pickupLocation': _goingLocationControllers[i].text.trim(),
        };

        final returning = {
          'enabled': _returningEnabled[i],
          'time': '',
          'pickupLocation': _returningLocationControllers[i].text.trim(),
        };

        debugPrint('Dia $dayOfWeek - Ida: ${_goingEnabled[i]}, Volta: ${_returningEnabled[i]}');

        // Só salva se pelo menos um dos horários estiver habilitado
        if (_goingEnabled[i] || _returningEnabled[i]) {
          debugPrint('Salvando schedule para dia $dayOfWeek');
          final success = await ScheduleService.createWeeklySchedule(
            groupId: widget.groupId,
            userId: _currentUserId!,
            groupName: widget.groupName,
            dayOfWeek: dayOfWeek,
            going: going,
            returning: returning,
          );
          debugPrint('Schedule dia $dayOfWeek salvo: $success');
        } else {
          // Se nenhum horário estiver habilitado, remove o schedule
          debugPrint('Removendo schedule para dia $dayOfWeek');
          final success = await ScheduleService.deleteWeeklySchedule(
            groupId: widget.groupId,
            userId: _currentUserId!,
            dayOfWeek: dayOfWeek,
          );
          debugPrint('Schedule dia $dayOfWeek removido: $success');
        }
      }

      // Recarregar schedules
      debugPrint('Recarregando schedules...');
      
      // Aguardar um pouco para garantir que os dados foram salvos
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _loadUserSchedules();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Horários salvos com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro ao salvar schedules: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar horários: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        showBusIcon: true,
        actions: const [
          AuthStatus(),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red),
                        SizedBox(height: AppSpacing.md),
                        Text(
                          _errorMessage!,
                          style: AppTextStyles.listHeading.copyWith(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSpacing.md),
                        CustomButton(
                          text: 'Tentar Novamente',
                          color: AppColors.primary,
                          onPressed: _loadGroupData,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Header do grupo
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: widget.groupColor.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: widget.groupColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: widget.groupColor,
                                child: Text(
                                  widget.groupName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.groupName,
                                      style: AppTextStyles.heading.copyWith(
                                        color: widget.groupColor,
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.sm),
                                    Text(
                                      'Grupo de viagem',
                                      style: AppTextStyles.subHeading.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Tab bar
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.textPrimary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: widget.groupColor,
                      tabs: const [
                        Tab(text: 'Meus Horários'),
                        Tab(text: 'Configurar Horários'),
                      ],
                    ),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUserSchedulesTab(),
                          _buildConfigureSchedulesTab(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildUserSchedulesTab() {
    // Filtrar apenas horários ativos
    final activeSchedules = _userSchedules.where((schedule) {
      final goingRaw = schedule['going'];
      final returningRaw = schedule['returning'];
      
      Map<String, dynamic> going = {};
      Map<String, dynamic> returning = {};
      
      if (goingRaw is Map) {
        going = Map<String, dynamic>.from(goingRaw);
      }
      if (returningRaw is Map) {
        returning = Map<String, dynamic>.from(returningRaw);
      }
      
      return going['enabled'] == true || returning['enabled'] == true;
    }).toList();

    if (activeSchedules.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, size: 64, color: AppColors.textSecondary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Nenhum horário configurado',
                style: AppTextStyles.listHeading.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Configure seus horários semanais',
                style: AppTextStyles.listSubheading,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: activeSchedules.length,
      itemBuilder: (context, index) {
        final schedule = activeSchedules[index];
        final dayOfWeek = schedule['dayOfWeek'] as int?;
        
        // Converter os dados para o tipo correto
        final goingRaw = schedule['going'];
        final returningRaw = schedule['returning'];
        
        Map<String, dynamic> going = {};
        Map<String, dynamic> returning = {};
        
        if (goingRaw is Map) {
          going = Map<String, dynamic>.from(goingRaw);
        }
        if (returningRaw is Map) {
          returning = Map<String, dynamic>.from(returningRaw);
        }
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getDayName(dayOfWeek ?? 1),
                  style: AppTextStyles.listHeading.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    if (going['enabled'] == true)
                      Expanded(
                        child: ScheduleItem(
                          type: 'Ida',
                          time: '',
                          color: Colors.green,
                          location: (going['pickupLocation'] ?? '').toString(),
                        ),
                      ),
                    if (going['enabled'] == true && returning['enabled'] == true)
                      SizedBox(width: AppSpacing.sm),
                    if (returning['enabled'] == true)
                      Expanded(
                        child: ScheduleItem(
                          type: 'Volta',
                          time: '',
                          color: Colors.green,
                          location: (returning['pickupLocation'] ?? '').toString(),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfigureSchedulesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure seus horários semanais',
            style: AppTextStyles.heading,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Selecione os dias que você vai e volta',
            style: AppTextStyles.subHeading,
          ),
          SizedBox(height: AppSpacing.lg),
          
          ...List.generate(7, (index) => _buildDayScheduleCard(index)),
          
          SizedBox(height: AppSpacing.lg),
          CustomButton(
            text: 'Salvar Horários',
            color: AppColors.primary,
            onPressed: _saveSchedules,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildDayScheduleCard(int dayIndex) {
    final dayName = _getDayName(dayIndex + 1);
    
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dayName,
              style: AppTextStyles.listHeading.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            
            // Opções de Ida e Volta em linhas separadas
            Column(
              children: [
                _buildScheduleOption(
                  'Ida',
                  'Vou neste dia',
                  dayIndex,
                  _goingEnabled,
                  _goingLocationControllers,
                  _goingEnabled[dayIndex] ? AppColors.primary : AppColors.secondary,
                  Icons.directions_car,
                ),
                SizedBox(height: AppSpacing.md),
                _buildScheduleOption(
                  'Volta',
                  'Volto neste dia',
                  dayIndex,
                  _returningEnabled,
                  _returningLocationControllers,
                  _returningEnabled[dayIndex] ? AppColors.primary : AppColors.secondary,
                  Icons.home,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleOption(
    String title,
    String subtitle,
    int dayIndex,
    List<bool> enabledList,
    List<TextEditingController> locationControllers,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabledList[dayIndex] 
              ? color 
              : color.withValues(alpha: 0.3),
          width: enabledList[dayIndex] ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com switch e ícone
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.listSubheading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.listSubheading.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: enabledList[dayIndex],
                onChanged: (value) {
                  setState(() {
                    enabledList[dayIndex] = value;
                  });
                },
                activeColor: color,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          
          if (enabledList[dayIndex]) ...[
            SizedBox(height: AppSpacing.sm),
            CustomTextField(
              controller: locationControllers[dayIndex],
              label: 'Local de embarque',
              hint: 'Rua, número, bairro',
              keyboardType: TextInputType.text,
            ),
          ],
        ],
      ),
    );
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1: return 'Segunda-feira';
      case 2: return 'Terça-feira';
      case 3: return 'Quarta-feira';
      case 4: return 'Quinta-feira';
      case 5: return 'Sexta-feira';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return 'Dia desconhecido';
    }
  }
} 