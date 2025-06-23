import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/groups_list_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/screens/group_details.dart';
import 'package:minha_van/screens/create_group.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'dart:math' as math;
import 'package:minha_van/services/group_service.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/widgets/auth_status.dart';
import 'package:minha_van/services/user_profile_service.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({super.key});

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _userGroups = [];
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        print('Carregando dados para usuário: ${user.uid}');
        
        final groups = await GroupService.getGroupsCreatedByUser(user.uid);
        print('Grupos criados pelo usuário: ${groups.length}');
        
        final requests = await GroupService.getPendingJoinRequests(user.uid);
        print('Solicitações pendentes encontradas: ${requests.length}');
        
        // Buscar nomes dos usuários das solicitações de forma performática
        if (requests.isNotEmpty) {
          final userIds = requests.map((r) => r['userId'] as String).toList();
          final userProfiles = await UserProfileService.getMultipleUserProfiles(userIds);
          
          // Adicionar nomes às solicitações
          for (final request in requests) {
            final userId = request['userId'] as String;
            final profile = userProfiles[userId];
            request['userName'] = profile?['nome'] ?? 'Usuário';
          }
        }
        
        setState(() {
          _userGroups = groups;
          _pendingRequests = requests;
          _isLoading = false;
        });
        
        print('Dados carregados - Grupos: ${_userGroups.length}, Solicitações: ${_pendingRequests.length}');
      } else {
        print('Usuário não autenticado');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
      setState(() {
        _errorMessage = 'Erro ao carregar dados: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptRequest(Map<String, dynamic> request) async {
    try {
      final user = authService.value.currentUser;
      if (user != null) {
        await GroupService.acceptJoinRequest(
          groupId: request['groupId'],
          userId: request['userId'],
          creatorId: user.uid,
        );
        
        // Recarregar dados
        await _loadUserData();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${request['userName']} foi aceito no grupo!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao aceitar solicitação: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _declineRequest(Map<String, dynamic> request) async {
    try {
      final user = authService.value.currentUser;
      if (user != null) {
        await GroupService.declineJoinRequest(
          groupId: request['groupId'],
          userId: request['userId'],
          creatorId: user.uid,
        );
        
        // Recarregar dados
        await _loadUserData();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitação de ${request['userName']} foi recusada.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao recusar solicitação: $e'),
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
        showBackButton: true,
        showBusIcon: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadUserData,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.group),
                        SizedBox(width: AppSpacing.xs),
                        Text('Meus Grupos (${_userGroups.length})'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.pending_actions),
                        SizedBox(width: AppSpacing.xs),
                        Text('Solicitações (${_pendingRequests.length})'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Meus Grupos
                  _buildGroupsTab(),
                  
                  // Tab 2: Solicitações Pendentes
                  _buildRequestsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
          );
          _loadUserData(); // Recarregar após criar grupo
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildGroupsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red.shade300),
              SizedBox(height: AppSpacing.md),
              Text(
                _errorMessage!,
                style: AppTextStyles.listHeading.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.md),
              CustomButton(
                text: 'Tentar Novamente',
                color: AppColors.primary,
                onPressed: _loadUserData,
                borderRadius: 10,
              ),
            ],
          ),
        ),
      );
    }

    if (_userGroups.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.group_outlined, size: 64, color: AppColors.textSecondary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Você ainda não criou nenhum grupo',
                style: AppTextStyles.listHeading.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Crie um grupo para começar a gerenciar passageiros',
                style: AppTextStyles.listSubheading,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.lg),
              CustomButton(
                text: 'Criar Primeiro Grupo',
                color: AppColors.primary,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateGroupScreen()),
                  );
                  _loadUserData();
                },
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: _userGroups.length,
      itemBuilder: (context, index) {
        final group = _userGroups[index];
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          elevation: 2,
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
              ).then((_) {
                // Recarregar dados quando voltar da tela de detalhes
                _loadUserData();
              });
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
                        radius: 24,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          group['name']?[0]?.toUpperCase() ?? 'G',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
                              group['name'] ?? 'Grupo',
                              style: AppTextStyles.listHeading.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textSecondary,
                        size: 16,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSpacing.sm),
                  
                  // Informações do grupo
                  Container(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.code,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'Código: ${group['groupCode'] ?? 'N/A'}',
                          style: AppTextStyles.listSubheading.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestsTab() {
    print('Construindo aba de solicitações - Total: ${_pendingRequests.length}');
    
    if (_isLoading) {
      print('Carregando...');
      return const Center(child: CircularProgressIndicator());
    }

    if (_pendingRequests.isEmpty) {
      print('Nenhuma solicitação pendente');
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pending_actions, size: 64, color: AppColors.textSecondary),
              SizedBox(height: AppSpacing.md),
              Text(
                'Nenhuma solicitação pendente',
                style: AppTextStyles.listHeading.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'As solicitações de entrada aparecerão aqui',
                style: AppTextStyles.listSubheading,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    print('Exibindo ${_pendingRequests.length} solicitações');
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      itemCount: _pendingRequests.length,
      itemBuilder: (context, index) {
        final request = _pendingRequests[index];
        print('Exibindo solicitação $index: ${request['userName']} para ${request['groupName']}');
        
        return Card(
          margin: EdgeInsets.only(bottom: AppSpacing.md),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cabeçalho com avatar e nome
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.secondary,
                      child: Text(
                        request['userName']?[0]?.toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                            request['userName'] ?? 'Usuário',
                            style: AppTextStyles.listHeading.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Solicita entrada no grupo',
                            style: AppTextStyles.listSubheading.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: AppSpacing.sm),
                
                // Informações do grupo
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.group,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          request['groupName'] ?? 'Grupo',
                          style: AppTextStyles.listSubheading.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: AppSpacing.sm),
                
                // Data da solicitação
                Text(
                  'Solicitado em: ${_formatDate(request['requestedAt'])}',
                  style: AppTextStyles.listSubheading.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                SizedBox(height: AppSpacing.md),
                
                // Botões de ação
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Aceitar',
                        color: Colors.green,
                        onPressed: () => _acceptRequest(request),
                        height: 48,
                        borderRadius: 8,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: CustomButton(
                        text: 'Recusar',
                        color: Colors.red,
                        onPressed: () => _declineRequest(request),
                        height: 48,
                        borderRadius: 8,
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

  String _formatDate(dynamic timestamp) {
    print('Formatando data: $timestamp (tipo: ${timestamp.runtimeType})');
    
    if (timestamp == null) {
      print('Timestamp é null');
      return 'Data desconhecida';
    }
    
    try {
      int milliseconds;
      
      if (timestamp is int) {
        milliseconds = timestamp;
      } else if (timestamp is String) {
        milliseconds = int.parse(timestamp);
      } else {
        print('Tipo de timestamp não suportado: ${timestamp.runtimeType}');
        return 'Data inválida';
      }
      
      final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      final formatted = '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      print('Data formatada: $formatted');
      return formatted;
    } catch (e) {
      print('Erro ao formatar data: $e');
      return 'Data inválida';
    }
  }
}
