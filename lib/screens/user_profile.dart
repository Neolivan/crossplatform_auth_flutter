import 'package:flutter/material.dart';

/// Tela de perfil de usuário (com parâmetros)
class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil do Usuário $userId')),
      body: Center(child: Text('ID do usuário: $userId')),
    );
  }
}
