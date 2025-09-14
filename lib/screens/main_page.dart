import 'package:flutter/material.dart';
import 'package:crossplatform_auth_flutter/widgets/theme_toggle_button.dart';
import 'package:crossplatform_auth_flutter/widgets/user_profile_button.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        centerTitle: false,
        actions: [
          // Toggle do tema
          const ThemeToggleButton(),

          // Botão de perfil do usuário
          const UserProfileButton(),

          const SizedBox(width: 8), // Espaçamento
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64),
            SizedBox(height: 16),
            Text(
              'Página Principal',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Bem-vindo à página principal da aplicação'),
          ],
        ),
      ),
    );
  }
}
