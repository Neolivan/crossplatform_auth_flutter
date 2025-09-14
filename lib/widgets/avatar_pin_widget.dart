import 'package:flutter/material.dart';
import 'package:crossplatform_auth_flutter/utils/global_states/user_provider.dart';

/// Widget personalizado para exibir um pin com avatar do usuário no mapa
class AvatarPinWidget extends StatelessWidget {
  final UserProvider userProvider;
  final double size;
  final double borderWidth;
  final Color borderColor;

  const AvatarPinWidget({
    super.key,
    required this.userProvider,
    this.size = 50.0,
    this.borderWidth = 3.0,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child:
            userProvider.userAvatar != null &&
                userProvider.userAvatar!.isNotEmpty
            ? Image.network(
                userProvider.userAvatar!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackAvatar(context);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildFallbackAvatar(context);
                },
              )
            : _buildFallbackAvatar(context),
      ),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          userProvider.userInitials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.36, // Proporcional ao tamanho
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
