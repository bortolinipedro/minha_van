import 'package:flutter/material.dart';
import 'package:minha_van/constants/colors.dart';
import 'package:minha_van/constants/spacing.dart';
import 'package:minha_van/constants/text_styles.dart';
import 'package:minha_van/screens/passenger_home.dart';
import 'package:minha_van/screens/schedules.dart';
import 'package:minha_van/widgets/custom_app_bar.dart';
import 'package:minha_van/widgets/custom_button.dart';

class PassengerProfile extends StatefulWidget {
  const PassengerProfile({super.key});

  @override
  State<PassengerProfile> createState() => _PassengerProfileState();
}

class _PassengerProfileState extends State<PassengerProfile> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Pedro',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '(31) 9 1111-1111',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '********',
  );

  int _selectedIndex = 2;
  bool _obscurePassword = true;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Schedules()),
        (Route<dynamic> route) => false,
      );
    } else if (index == 1) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PassangerHome()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        showBackButton: true,
        showBusIcon: true, // Mostra o ícone e texto "Minha Van" na app bar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Seção Perfil - removido o texto "Minha Van" que estava aqui
            Text('Perfil', style: AppTextStyles.subHeading),
            const SizedBox(height: AppSpacing.sm),

            _buildEditableField('Nome', _nameController),
            const SizedBox(height: AppSpacing.sm),

            _buildEditableField('Telefone', _phoneController),
            const SizedBox(height: AppSpacing.sm),

            _buildPasswordField(),
            const SizedBox(height: AppSpacing.md),

            CustomButton(
              text: 'Salvar Alterações',
              color: AppColors.primary,
              onPressed: _saveChanges,
              width: double.infinity,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Agendamentos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        backgroundColor: AppColors.navbar,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.listSubheading),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: AppColors.auxiliar,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
              ),
              border: InputBorder.none,
            ),
            style: AppTextStyles.listHeading,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Senha', style: AppTextStyles.listSubheading),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            color: AppColors.auxiliar,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
              ),
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            style: AppTextStyles.listHeading,
          ),
        ),
      ],
    );
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alterações salvas com sucesso!')),
    );
  }
}
