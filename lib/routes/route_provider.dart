import 'package:flutter/material.dart';
import 'package:crossplatform_auth_flutter/screens/login.dart';
import 'package:crossplatform_auth_flutter/screens/main_page.dart';
import 'package:crossplatform_auth_flutter/screens/user_profile.dart';
import 'package:crossplatform_auth_flutter/screens/not_found.dart';

/// Provider para gerenciar rotas da aplicação
class RouteProvider extends ChangeNotifier {
  /// Mapa de rotas nomeadas com rotas padrão
  final Map<String, WidgetBuilder> _routes = {
    '/login': (context) => const LoginScreen(),
    '/main': (context) => const MainPageScreen(),
    '/profile': (context) => const UserProfileScreen(),
  };

  /// Mapa de rotas com parâmetros
  final Map<String, Route<dynamic> Function(RouteSettings)> _routeGenerators =
      {};

  /// Rota inicial da aplicação
  String? _initialRoute = '/login';

  /// Rota de fallback quando uma rota não é encontrada
  Widget Function(BuildContext)? _onUnknownRoute = (context) =>
      const NotFoundScreen();

  /// Obtém todas as rotas nomeadas
  Map<String, WidgetBuilder> get routes => Map.unmodifiable(_routes);

  /// Obtém todos os route generators
  Map<String, Route<dynamic> Function(RouteSettings)> get routeGenerators =>
      Map.unmodifiable(_routeGenerators);

  /// Obtém a rota inicial
  String? get initialRoute => _initialRoute;

  /// Obtém o builder para rotas desconhecidas
  Widget Function(BuildContext)? get onUnknownRoute => _onUnknownRoute;

  /// Adiciona uma rota nomeada simples
  void addRoute(String name, WidgetBuilder builder) {
    _routes[name] = builder;
    notifyListeners();
  }

  /// Adiciona uma rota com geração customizada (para rotas com parâmetros)
  void addRouteGenerator(
    String name,
    Route<dynamic> Function(RouteSettings) generator,
  ) {
    _routeGenerators[name] = generator;
    notifyListeners();
  }

  /// Atualiza uma rota existente
  void updateRoute(String name, WidgetBuilder builder) {
    if (_routes.containsKey(name)) {
      _routes[name] = builder;
      notifyListeners();
    } else {
      throw Exception('Rota "$name" não encontrada para atualização');
    }
  }

  /// Atualiza uma rota generator existente
  void updateRouteGenerator(
    String name,
    Route<dynamic> Function(RouteSettings) generator,
  ) {
    if (_routeGenerators.containsKey(name)) {
      _routeGenerators[name] = generator;
      notifyListeners();
    } else {
      throw Exception('Rota generator "$name" não encontrada para atualização');
    }
  }

  /// Remove uma rota
  void removeRoute(String name) {
    _routes.remove(name);
    _routeGenerators.remove(name);
    notifyListeners();
  }

  /// Define a rota inicial
  void setInitialRoute(String routeName) {
    _initialRoute = routeName;
    notifyListeners();
  }

  /// Obtém o generator de uma rota específica
  Route<dynamic> Function(RouteSettings)? getRouteGenerator(String name) {
    // Verifica se a rota existe exatamente
    if (_routeGenerators.containsKey(name)) {
      return _routeGenerators[name];
    }

    // Verifica se é uma rota com parâmetros (ex: /user/123 -> /user/:id)
    for (String routePattern in _routeGenerators.keys) {
      if (_matchesRoutePattern(name, routePattern)) {
        return _routeGenerators[routePattern];
      }
    }

    return null;
  }

  /// Verifica se uma rota corresponde ao padrão (ex: /user/123 matches /user/:id)
  bool _matchesRoutePattern(String route, String pattern) {
    if (route == pattern) return true;

    List<String> routeParts = route.split('/');
    List<String> patternParts = pattern.split('/');

    if (routeParts.length != patternParts.length) return false;

    for (int i = 0; i < routeParts.length; i++) {
      if (patternParts[i].startsWith(':')) {
        // É um parâmetro, qualquer valor é válido
        continue;
      } else if (routeParts[i] != patternParts[i]) {
        // Partes não coincidem
        return false;
      }
    }

    return true;
  }

  /// Limpa todas as rotas
  void clearRoutes() {
    _routes.clear();
    _routeGenerators.clear();
    _initialRoute = null;
    _onUnknownRoute = null;
    notifyListeners();
  }

  /// Obtém o número total de rotas registradas
  int get routeCount => _routes.length + _routeGenerators.length;

  /// Lista todas as rotas registradas
  List<String> get allRouteNames => [..._routes.keys, ..._routeGenerators.keys];

  /// Navega para uma rota específica
  void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navega para uma rota específica e remove todas as rotas anteriores
  void navigateToAndClear(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Substitui a rota atual por uma nova
  void navigateReplacement(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  /// Volta para a rota anterior
  void goBack(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  /// Volta para uma rota específica
  void goBackTo(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}
