import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crossplatform_auth_flutter/routes/route_provider.dart';
import 'package:crossplatform_auth_flutter/widgets/theme_toggle_button.dart';

class MainPageScreen extends StatelessWidget {
  const MainPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        actions: [
          // Toggle do tema
          const ThemeToggleButton(),

          // Botão para ir ao perfil do usuário
          Consumer<RouteProvider>(
            builder: (context, routeProvider, child) {
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  routeProvider.navigateTo(context, '/profile');
                },
                tooltip: 'Perfil do Usuário',
              );
            },
          ),

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
