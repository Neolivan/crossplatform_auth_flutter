import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crossplatform_auth_flutter/utils/global_states/user_provider.dart';
import 'package:crossplatform_auth_flutter/routes/route_provider.dart';
import 'package:crossplatform_auth_flutter/utils/constants/enums/labels_enum.dart';

/// Widget personalizado para botão de perfil do usuário
class UserProfileButton extends StatelessWidget {
  /// Se deve exibir opção de editar perfil
  final bool showEditProfile;

  const UserProfileButton({super.key, this.showEditProfile = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return PopupMenuButton<String>(
          tooltip: 'Opções do usuário',
          onSelected: (value) async {
            switch (value) {
              case 'profile':
                Provider.of<RouteProvider>(
                  context,
                  listen: false,
                ).navigateTo(context, '/profile');
                break;
              case 'logout':
                await userProvider.logout(() {
                  if (context.mounted) {
                    Provider.of<RouteProvider>(
                      context,
                      listen: false,
                    ).navigateToAndClear(context, '/login');
                  }
                });
                break;
            }
          },
          itemBuilder: (context) => [
            // Header com avatar e nome
            PopupMenuItem<String>(
              enabled: false,
              child: Container(
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    // Avatar do usuário
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      backgroundImage:
                          userProvider.userAvatar != null &&
                              userProvider.userAvatar!.isNotEmpty
                          ? NetworkImage(userProvider.userAvatar!)
                          : null,
                      child:
                          userProvider.userAvatar == null ||
                              userProvider.userAvatar!.isEmpty
                          ? Text(
                              userProvider.userInitials,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    // Nome completo do usuário
                    Text(
                      userProvider.userName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            // Divisor
            const PopupMenuDivider(),
            // Botão Editar Perfil
            if (showEditProfile)
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Text(LabelsEnum.editProfile),
                  ],
                ),
              ),
            // Botão Logout
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    LabelsEnum.logout,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              backgroundImage:
                  userProvider.userAvatar != null &&
                      userProvider.userAvatar!.isNotEmpty
                  ? NetworkImage(userProvider.userAvatar!)
                  : null,
              child:
                  userProvider.userAvatar == null ||
                      userProvider.userAvatar!.isEmpty
                  ? Text(
                      userProvider.userInitials,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
