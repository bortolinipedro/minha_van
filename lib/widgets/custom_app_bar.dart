import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/i18n/custom_app_bar_i18n.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showBusIcon;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    this.showBackButton = true,
    this.showBusIcon = false,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.secondary),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(CustomAppBarI18n.MINHA + " ", style: AppTextStyles.title),
          if (showBusIcon) Image.asset(
            'assets/images/bus.png',
            height: 24,
          ),
          Text(" " + CustomAppBarI18n.VAN, style: AppTextStyles.title),
        ],
      ),
      actions: actions ?? [SizedBox(width: 48)],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
