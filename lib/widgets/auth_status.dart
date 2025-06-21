import 'package:flutter/material.dart';
import 'package:minha_van/services/auth_service.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/screens/profile.dart';

class AuthStatus extends StatelessWidget {
  const AuthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthService>(
      valueListenable: authService,
      builder: (context, auth, child) {
        final user = auth.currentUser;
        
        if (user == null) {
          return const SizedBox.shrink();
        }

        return PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'logout') {
              await authService.value.signOut();
              Navigator.pushReplacementNamed(context, '/');
            } else if (value == 'profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 8),
                  Text(user.displayName ?? 'Perfil'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'email',
              enabled: false,
              child: Text(
                user.email ?? '',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Sair', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary,
                child: Text(
                  user.displayName?.isNotEmpty == true 
                    ? user.displayName![0].toUpperCase()
                    : user.email![0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
            ],
          ),
        );
      },
    );
  }
} 