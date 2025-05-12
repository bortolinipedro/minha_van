import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/groups_list_i18n.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/screens/group_details.dart';
import 'package:minha_van/widgets/custom_button.dart';
import 'dart:math' as math;
import 'package:minha_van/helpers/sql_helper.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({super.key});

  @override
  State<GroupsList> createState() => GroupsListState();
}

class GroupsListState extends State<GroupsList> {
  List<Map<String, dynamic>> grupos = [];

  @override
  void initState() {
    super.initState();
    _refreshGroups();
  }

  Future<void> _refreshGroups() async {
    final data = await SQLHelper.getGroups();
    setState(() {
      grupos = data;
    });
  }

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: AppSpacing.sm,
    mainAxisSpacing: AppSpacing.sm,
    childAspectRatio: 1.2,
  );

  Color _generateRandomColor() {
    return Color(
      (math.Random().nextDouble() * 0xFFFFFF).toInt(),
    ).withOpacity(1.0);
  }

  void _addNewGroup(String name) async {
    final colorValue = _generateRandomColor().value;
    await SQLHelper.createGroup(name, colorValue);
    _refreshGroups();
  }

  void _showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String novoGrupo = '';
        return AlertDialog(
          title: const Text(GroupsListI18n.newGroup),
          content: TextField(
            onChanged: (value) => novoGrupo = value,
            decoration: const InputDecoration(
              hintText: GroupsListI18n.groupName,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(GroupsListI18n.cancel),
            ),
            TextButton(
              onPressed: () {
                if (novoGrupo.isNotEmpty) {
                  _addNewGroup(novoGrupo);
                  Navigator.pop(context);
                }
              },
              child: const Text(GroupsListI18n.add),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(showBusIcon: true),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButton(
              onPressed: _showAddGroupDialog,
              text: GroupsListI18n.addGroup,
              color: AppColors.primary,
              width: double.infinity,
            ),
            SizedBox(height: AppSpacing.md),
            Text(GroupsListI18n.chooseGroup, style: AppTextStyles.subHeading),
            SizedBox(height: AppSpacing.sm),
            Expanded(
              child: GridView.builder(
                gridDelegate: _gridDelegate,
                itemCount: grupos.length,
                itemBuilder: _buildGridItem,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _navigateToDetails(context, index),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Color(grupos[index]['color']),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Center(
          child: Text(
            grupos[index]['name'],
            textAlign: TextAlign.center,
            style: AppTextStyles.heading.copyWith(color: AppColors.white),
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => GroupDetails(
              groupId: grupos[index]['id'],
              groupName: grupos[index]['name'],
              groupColor: Color(grupos[index]['color']),
            ),
      ),
    );
  }
}
