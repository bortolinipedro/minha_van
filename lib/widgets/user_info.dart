import 'package:flutter/material.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/text_styles.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthService>(
      valueListenable: authService,
      builder: (context, auth, child) {
        final user = auth.currentUser;
        
        if (user == null) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: Text(
                  user.displayName?.isNotEmpty == true 
                    ? user.displayName![0].toUpperCase()
                    : user.email![0].toUpperCase(),
                  style: AppTextStyles.heading.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? 'Usuário',
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user.email ?? '',
                      style: AppTextStyles.listSubheading.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.verified,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }
} 