import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/services/group_service.dart';
import 'package:minha_van/services/schedule_service.dart';
import 'package:minha_van/services/user_profile_service.dart';
import 'package:minha_van/widgets/auth_status.dart';
import 'package:minha_van/widgets/schedule_item.dart';
import 'package:minha_van/widgets/group_info_card.dart';

class DriverGroupDetails extends StatefulWidget {
  final String groupId;
  final String groupName;
  final Color groupColor;

  const DriverGroupDetails({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupColor,
  });

  @override
  State<DriverGroupDetails> createState() => _DriverGroupDetailsState();
}

class _DriverGroupDetailsState extends State<DriverGroupDetails>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  Map<String, dynamic>? _groupData;
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _todaySchedules = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadGroupData();
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

      // Buscar dados do grupo
      final groupData = await GroupService.getGroupById(widget.groupId);
      if (groupData != null) {
        setState(() {
          _groupData = groupData;
        });

        // Buscar membros e schedules de hoje
        await _loadMembers();
        await _loadTodaySchedules();
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

  Future<void> _loadMembers() async {
    try {
      final members = await GroupService.getGroupMembers(
        groupId: widget.groupId,
        requesterId: _currentUserId!,
      );
      
      // Buscar nomes dos membros de forma performática
      if (members.isNotEmpty) {
        final userIds = members.map((m) => m['userId'] as String).toList();
        final userProfiles = await UserProfileService.getMultipleUserProfiles(userIds);
        
        // Adicionar nomes aos membros
        for (final member in members) {
          final userId = member['userId'] as String;
          final profile = userProfiles[userId];
          member['name'] = profile?['nome'] ?? 'Usuário';
        }
      }
      
      setState(() {
        _members = members;
      });
    } catch (e) {
      debugPrint('Erro ao carregar membros: $e');
    }
  }

  Future<void> _loadTodaySchedules() async {
    try {
      // Obter o dia da semana de hoje (1 = segunda, 7 = domingo)
      final today = DateTime.now();
      final dayOfWeek = today.weekday;
      
      debugPrint('Carregando schedules para hoje (dia $dayOfWeek)');
      
      final schedules = await ScheduleService.getGroupSchedulesForDay(
        groupId: widget.groupId,
        dayOfWeek: dayOfWeek,
      );
      
      // Buscar nomes dos usuários de forma performática
      if (schedules.isNotEmpty) {
        final userIds = schedules.map((s) => s['userId'] as String).toList();
        final userProfiles = await UserProfileService.getMultipleUserProfiles(userIds);
        
        // Adicionar nomes aos schedules
        for (final schedule in schedules) {
          final userId = schedule['userId'] as String;
          final profile = userProfiles[userId];
          String userName = 'Usuário';
          if (profile != null) {
            userName = profile['nome'] ?? 'Usuário';
            if (userName == 'Usuário') {
              debugPrint('Perfil de $userId não tem nome preenchido.');
            }
          } else {
            debugPrint('Perfil não encontrado para $userId.');
          }
          schedule['userName'] = userName;
        }
      }
      
      setState(() {
        _todaySchedules = schedules;
      });
      
      debugPrint('Schedules de hoje carregados: ${schedules.length}');
      for (final schedule in schedules) {
        debugPrint('Schedule: ${schedule['userName']} - Going: ${schedule['going']} - Returning: ${schedule['returning']}');
      }
    } catch (e) {
      debugPrint('Erro ao carregar schedules de hoje: $e');
      setState(() {
        _todaySchedules = [];
      });
    }
  }

  Future<void> _removeUserFromGroup(String userId, String userName) async {
    try {
      final user = authService.value.currentUser;
      if (user != null) {
        await GroupService.removeUserFromGroup(
          groupId: widget.groupId,
          userId: userId,
          creatorId: user.uid,
        );
        
        await _loadGroupData();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$userName foi removido do grupo'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao remover usuário: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteGroup() async {
    try {
      final user = authService.value.currentUser;
      if (user != null) {
        await GroupService.deleteGroup(
          groupId: widget.groupId,
          creatorId: user.uid,
        );
        
        if (mounted) {
          Navigator.pop(context);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Grupo "${widget.groupName}" foi deletado'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao deletar grupo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRemoveUserDialog(String userId, String userName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover Usuário'),
        content: Text('Tem certeza que deseja remover $userName do grupo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeUserFromGroup(userId, userName);
            },
            child: const Text('Remover', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Grupo'),
        content: Text('Tem certeza que deseja deletar o grupo "${widget.groupName}"? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGroup();
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        showBusIcon: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  _showDeleteGroupDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: AppSpacing.sm),
                    Text('Deletar Grupo'),
                  ],
                ),
              ),
            ],
          ),
          const AuthStatus(),
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
                                      'Criado por você',
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
                        Tab(text: 'Horários de Hoje'),
                        Tab(text: 'Membros'),
                        Tab(text: 'Informações'),
                      ],
                    ),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTodaySchedulesTab(),
                          _buildMembersTab(),
                          _buildInfoTab(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildTodaySchedulesTab() {
    if (_todaySchedules.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, size: 64, color: AppColors.textSecondary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Nenhum horário para hoje',
                style: AppTextStyles.listHeading.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Os horários de viagem aparecerão aqui',
                style: AppTextStyles.listSubheading,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Quem Vai'),
              Tab(text: 'Quem Volta'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildGoingList(),
                _buildReturningList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoingList() {
    final goingSchedules = _todaySchedules.where((schedule) {
      final goingRaw = schedule['going'];
      Map<String, dynamic> going = {};
      if (goingRaw is Map) {
        going = Map<String, dynamic>.from(goingRaw);
      }
      return going['enabled'] == true;
    }).toList();

    debugPrint('Schedules de ida filtrados: ${goingSchedules.length}');

    if (goingSchedules.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car, size: 64, color: AppColors.textSecondary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Ninguém vai hoje',
                style: AppTextStyles.listHeading.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Verifique os horários configurados para outros dias da semana',
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
      itemCount: goingSchedules.length,
      itemBuilder: (context, index) {
        final schedule = goingSchedules[index];
        final goingRaw = schedule['going'];
        Map<String, dynamic> going = {};
        if (goingRaw is Map) {
          going = Map<String, dynamic>.from(goingRaw);
        }
        
        // Buscar nome do usuário
        final userName = schedule['userName'] ?? 'Usuário';
        
        debugPrint('Renderizando schedule de ida: $userName - Going: $going');
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                userName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              userName,
              style: AppTextStyles.listHeading.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  going['pickupLocation'] ?? 'Local não informado',
                  style: AppTextStyles.listSubheading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReturningList() {
    final returningSchedules = _todaySchedules.where((schedule) {
      final returningRaw = schedule['returning'];
      Map<String, dynamic> returning = {};
      if (returningRaw is Map) {
        returning = Map<String, dynamic>.from(returningRaw);
      }
      return returning['enabled'] == true;
    }).toList();

    debugPrint('Schedules de volta filtrados: ${returningSchedules.length}');

    if (returningSchedules.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 64, color: AppColors.textSecondary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Ninguém volta hoje',
                style: AppTextStyles.listHeading.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Verifique os horários configurados para outros dias da semana',
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
      itemCount: returningSchedules.length,
      itemBuilder: (context, index) {
        final schedule = returningSchedules[index];
        final returningRaw = schedule['returning'];
        Map<String, dynamic> returning = {};
        if (returningRaw is Map) {
          returning = Map<String, dynamic>.from(returningRaw);
        }
        
        // Buscar nome do usuário
        final userName = schedule['userName'] ?? 'Usuário';
        
        debugPrint('Renderizando schedule de volta: $userName - Returning: $returning');
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.secondary,
              child: Text(
                userName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              userName,
              style: AppTextStyles.listHeading.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  returning['pickupLocation'] ?? 'Local não informado',
                  style: AppTextStyles.listSubheading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMembersTab() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final member = _members[index];
        final isCreator = member['role'] == 'creator';
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCreator ? widget.groupColor : AppColors.secondary,
              child: Text(
                member['name']?[0]?.toUpperCase() ?? 'U',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              member['name'] ?? 'Usuário',
              style: AppTextStyles.listHeading.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              isCreator ? 'Criador' : 'Membro',
              style: AppTextStyles.listSubheading.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: !isCreator
                ? IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _showRemoveUserDialog(
                      member['userId'] ?? '',
                      member['name'] ?? 'Usuário',
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildInfoTab() {
    if (_groupData == null) {
      return const Center(child: Text('Informações não disponíveis'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupInfoCard(
            title: 'Informações do Grupo',
            children: [
              InfoRow(label: 'Nome', value: _groupData!['name'] ?? 'N/A'),
              InfoRow(label: 'Código', value: _groupData!['groupCode'] ?? 'N/A'),
              InfoRow(label: 'Membros', value: '${_members.length} pessoas'),
            ],
          ),
          
          SizedBox(height: AppSpacing.lg),
          GroupInfoCard(
            title: 'Ações do Criador',
            children: [
              ActionRow(
                label: 'Deletar Grupo',
                icon: Icons.delete,
                color: Colors.red,
                onTap: _showDeleteGroupDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 