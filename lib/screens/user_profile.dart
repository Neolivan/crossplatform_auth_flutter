import 'package:flutter/material.dart';

/// Tela de perfil de usuário (com parâmetros)
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil do Usuário')),
      body: Center(child: Text('Informaçao do usuário')),
    );
  }
}
