# Gerenciador de Rotas (RouteProvider)

Sistema ultra-simplificado e organizado de gerenciamento de rotas nomeadas para Flutter usando Provider.

## Estrutura de Arquivos

- `routes/route_provider.dart` - **Único arquivo** com toda funcionalidade de rotas
- `screens/` - Pasta com todas as telas da aplicação
  - `home.dart` - HomeScreen (com integração ao Provider)
  - `login.dart` - LoginScreen
  - `register.dart` - RegisterScreen
  - `main_page.dart` - MainPageScreen
  - `profile.dart` - ProfileScreen
  - `settings.dart` - SettingsScreen
  - `user_profile.dart` - UserProfileScreen (com parâmetros)
  - `product_detail.dart` - ProductDetailScreen (com parâmetros)
  - `not_found.dart` - NotFoundScreen (404)
- `main.dart` - Aplicação principal com Provider configurado
- `README.md` - Esta documentação

## Rotas Incluídas

### Rotas Simples
- `/` - HomeScreen (página inicial)
- `/login` - LoginScreen (tela de login)
- `/register` - RegisterScreen (tela de registro)
- `/main` - MainPageScreen (página principal)
- `/profile` - ProfileScreen (perfil do usuário)
- `/settings` - SettingsScreen (configurações)

### Rotas com Parâmetros
- `/user/:id` - UserProfileScreen (perfil de usuário específico)
- `/product/:id` - ProductDetailScreen (detalhes do produto)

### Rota de Erro
- Página 404 automática para rotas não encontradas

## Como usar

### 1. Configuração no main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crossplatform_auth_flutter/routes/route_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RouteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
      builder: (context, routeProvider, child) {
        return MaterialApp(
          title: 'Crossplatform Auth Flutter',
          initialRoute: routeProvider.initialRoute,
          routes: routeProvider.routes,
          onGenerateRoute: (settings) {
            final generator = routeProvider.getRouteGenerator(settings.name ?? '');
            return generator != null ? generator(settings) : null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: routeProvider.onUnknownRoute!,
              settings: settings,
            );
          },
        );
      },
    );
  }
}
```

### 2. Navegação usando Provider

```dart
// Em qualquer widget
Consumer<RouteProvider>(
  builder: (context, routeProvider, child) {
    return ElevatedButton(
      onPressed: () => routeProvider.navigateTo(context, '/login'),
      child: const Text('Login'),
    );
  },
)

// Ou usando Provider.of
final routeProvider = Provider.of<RouteProvider>(context, listen: false);
routeProvider.navigateTo(context, '/register');
```

### 3. Métodos de navegação disponíveis

```dart
final routeProvider = Provider.of<RouteProvider>(context, listen: false);

// Navegação simples
routeProvider.navigateTo(context, '/login');

// Navegação com parâmetros
routeProvider.navigateTo(context, '/user/123');

// Substituir rota atual
routeProvider.navigateReplacement(context, '/main');

// Navegar e limpar histórico
routeProvider.navigateToAndClear(context, '/login');

// Voltar
routeProvider.goBack(context);

// Voltar para rota específica
routeProvider.goBackTo(context, '/home');
```

### 4. Gerenciamento dinâmico de rotas

```dart
final routeProvider = Provider.of<RouteProvider>(context, listen: false);

// Adicionar nova rota
routeProvider.addRoute('/custom', (context) => CustomScreen());

// Atualizar rota existente
routeProvider.updateRoute('/login', (context) => NewLoginScreen());

// Verificar se rota existe
if (routeProvider.hasRoute('/custom')) {
  // Rota existe
}

// Listar todas as rotas
print(routeProvider.allRouteNames);
```

## Funcionalidades

- ✅ **Provider Integration** - Estado global gerenciado via Provider
- ✅ **8 rotas pré-configuradas** - Prontas para uso
- ✅ **Rotas com parâmetros** - Suporte nativo com matching inteligente
- ✅ **Página 404 automática** - Para rotas não encontradas
- ✅ **Gerenciamento dinâmico** - Adicionar/atualizar/remover rotas
- ✅ **Métodos de navegação avançados** - Substituir, limpar, voltar
- ✅ **Reatividade** - Interface atualiza automaticamente
- ✅ **Zero configuração** - Funciona imediatamente

## Vantagens da Consolidação

- 🚀 **Ultra-simples** - Apenas 1 arquivo para gerenciar rotas
- ⚡ **Zero redundância** - Sem duplicação de código
- 🎯 **Estado Global** - Acesso às rotas de qualquer lugar
- 🔧 **Reatividade** - Interface atualiza automaticamente
- 📱 **Métodos Avançados** - Navegação com mais opções
- 🎨 **Fácil manutenção** - Tudo em um lugar só
- 🔄 **Notificações automáticas** - UI atualiza quando rotas mudam
- 📦 **Menos arquivos** - Estrutura mais limpa e organizada
