import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/i18n/group_details_i18n.dart';
import 'package:minha_van/helpers/sql_helper.dart';

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
  List<Map<String, dynamic>> passengersThatGo = [];
  List<Map<String, dynamic>> passengersThatComeBack = [];

  static const _tabs = [
    Tab(text: GroupDetailsI18n.goingToday),
    Tab(text: GroupDetailsI18n.returningToday),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadPassengers();
  }

  Future<void> _loadPassengers() async {
    final goingPassengers = await SQLHelper.getPassengers(1, true);
    final returningPassengers = await SQLHelper.getPassengers(1, false);
    
    setState(() {
      passengersThatGo = goingPassengers;
      passengersThatComeBack = returningPassengers;
    });
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

  Widget _buildpassengersList(List<Map<String, dynamic>> passengersArg) {
    return ListView.separated(
      itemCount: passengersArg.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final passenger = passengersArg[index];
        final address = "${passenger['street']} - ${passenger['neighborhood']}";
        
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            title: Text(
              "${passenger['name']} | $address",
              style: AppTextStyles.listHeading,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                Text(
                  passenger['phone_number'],
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
