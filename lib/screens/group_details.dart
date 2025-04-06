import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/i18n/group_details_i18n.dart';

class GroupDetails extends StatefulWidget {
  final String groupName;
  final Color groupColor;

  const GroupDetails({
    super.key,
    required this.groupName,
    required this.groupColor,
  });

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    Tab(text: GroupDetailsI18n.GOING_TODAY),
    Tab(text: GroupDetailsI18n.RETURNING_TODAY),
  ];

  final List<Map<String, String>> passengersThatGo = [
    {
      'name': 'Maria',
      'adress': 'Av. Barbacena - Barro Preto',
      'telephone': '(31) 9 1111-1111',
    },
    {
      'name': 'Pedro',
      'adress': 'Av. Rio Grande do Norte - Savassi',
      'telephone': '(31) 9 1111-1111',
    },
    {
      'name': 'João Antônio',
      'adress': 'R. Santa Rita Durão - Funcionários',
      'telephone': '(31) 9 1111-1111',
    },
  ];

  final List<Map<String, String>> passengersThatComeBack = [
    {
      'name': 'Pedro',
      'adress': 'Av. Rio Grande do Norte - Savassi',
      'telephone': '(31) 9 1111-1111',
    },
    {
      'name': 'Maria',
      'adress': 'Av. Barbacena - Barro Preto',
      'telephone': '(31) 9 1111-1111',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
      appBar: CustomAppBar(showBusIcon: true),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: _tabs,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildpassengersList(passengersThatGo),
                _buildpassengersList(passengersThatComeBack),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildpassengersList(List<Map<String, String>> passengersArg) {
    return ListView.separated(
      itemCount: passengersArg.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final passengers = passengersArg[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            title: Text(
              passengers['name']! + ' | ' + passengers['adress']!,
              style: AppTextStyles.listHeading,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                Text(
                  passengers['telephone']!,
                  style: AppTextStyles.listSubheading,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
