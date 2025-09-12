import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crossplatform_auth_flutter/routes/route_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RouteProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
      builder: (context, routeProvider, child) {
        return MaterialApp(
          title: 'Crossplatform Auth Flutter',
          // Usa as rotas configuradas no RouteProvider
          initialRoute: routeProvider.initialRoute,
          routes: routeProvider.routes,
          onGenerateRoute: (settings) {
            print('🔍 Tentando gerar rota: ${settings.name}');

            // Verifica se existe um route generator para esta rota
            final generator = routeProvider.getRouteGenerator(
              settings.name ?? '',
            );
            if (generator != null) {
              print('✅ Rota encontrada: ${settings.name}');
              return generator(settings);
            }

            print('❌ Rota não encontrada: ${settings.name}');
            return null;
          },
          onUnknownRoute: (settings) {
            print('🚨 Rota desconhecida: ${settings.name}');
            // Usa a rota de fallback configurada no RouteProvider
            if (routeProvider.onUnknownRoute != null) {
              return MaterialPageRoute(
                builder: routeProvider.onUnknownRoute!,
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}
