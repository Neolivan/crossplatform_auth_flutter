import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crossplatform_auth_flutter/routes/route_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
      builder: (context, routeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            actions: [
              // Botão para mostrar informações das rotas
              IconButton(
                onPressed: () => _showRouteInfo(context, routeProvider),
                icon: const Icon(Icons.info),
                tooltip: 'Informações das Rotas',
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.home, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Bem-vindo!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Página inicial da aplicação'),
                const SizedBox(height: 16),
                // Informações das rotas
                Text(
                  'Rotas disponíveis: ${routeProvider.routeCount}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                // Botões de teste para verificar as rotas
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateTo(context, '/login'),
                      child: const Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateTo(context, '/register'),
                      child: const Text('Registro'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateTo(context, '/profile'),
                      child: const Text('Perfil'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateTo(context, '/settings'),
                      child: const Text('Configurações'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateTo(context, '/user/123'),
                      child: const Text('Usuário 123'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateTo(context, '/product/456'),
                      child: const Text('Produto 456'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Botões de navegação avançada
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateReplacement(context, '/main'),
                      child: const Text('Ir para Main'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          routeProvider.navigateToAndClear(context, '/login'),
                      child: const Text('Login e Limpar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Mostra informações sobre as rotas disponíveis
  void _showRouteInfo(BuildContext context, RouteProvider routeProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informações das Rotas'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total de rotas: ${routeProvider.routeCount}'),
            const SizedBox(height: 8),
            const Text('Rotas simples:'),
            ...routeProvider.routes.keys.map((route) => Text('  • $route')),
            const SizedBox(height: 8),
            const Text('Rotas com parâmetros:'),
            ...routeProvider.routeGenerators.keys.map(
              (route) => Text('  • $route'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
