import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/services/group_service.dart';
import 'package:minha_van/services/user_profile_service.dart';
import 'package:minha_van/widgets/auth_status.dart';
import 'package:minha_van/screens/driver_group_details.dart';
import 'package:minha_van/screens/passenger_group_details.dart';

class GroupDetails extends StatefulWidget {
  final String groupId;
  final String groupName;
  final Color groupColor;

  const GroupDetails({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupColor,
  });

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  Map<String, dynamic>? _groupData;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isCreator = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
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
          _isCreator = groupData['creatorId'] == user.uid;
          _isLoading = false;
        });
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        showBusIcon: true,
          actions: const [AuthStatus()],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
                }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(
          showBusIcon: true,
          actions: const [AuthStatus()],
      ),
        body: Center(
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
                  onPressed: _loadUserInfo,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Redirecionar para a tela apropriada baseado no tipo de usuário
    if (_isCreator) {
      return DriverGroupDetails(
        groupId: widget.groupId,
        groupName: widget.groupName,
        groupColor: widget.groupColor,
    );
    } else {
      return PassengerGroupDetails(
        groupId: widget.groupId,
        groupName: widget.groupName,
        groupColor: widget.groupColor,
      );
    }
  }
}
