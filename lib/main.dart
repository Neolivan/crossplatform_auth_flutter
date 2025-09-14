import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crossplatform_auth_flutter/routes/route_provider.dart';
import 'package:crossplatform_auth_flutter/utils/constants/enums/labels_enum.dart';
import 'package:crossplatform_auth_flutter/utils/global_states/theme_provider.dart';
import 'package:crossplatform_auth_flutter/utils/global_states/user_provider.dart';
import 'package:toastification/toastification.dart';

/// Função principal da aplicação
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Widget principal da aplicação
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<RouteProvider, ThemeProvider>(
      builder: (context, routeProvider, themeProvider, child) {
        return ToastificationWrapper(
          child: MaterialApp(
            title: LabelsEnum.appTitle,
            theme: themeProvider.currentTheme,
            themeMode: themeProvider.themeMode,
            // Define rota inicial baseada no estado de autenticação
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
          ),
        );
      },
    );
  }
}
