import 'package:crossplatform_auth_flutter/utils/global_states/user_provider.dart';
import 'package:crossplatform_auth_flutter/utils/services/user/user_services.dart';
import 'package:flutter/material.dart';
import '../utils/mixins/form_validators/form_validators.dart';
import '../utils/constants/enums/labels_enum.dart';

/// Diálogo para registro de novo usuário
class RegisterDialog with UserServices {
  /// Exibe o diálogo de registro
  void show(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    bool isPasswordVisible = false;
    bool isConfirmPasswordVisible = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text(LabelsEnum.createAccountTitle),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LabelsEnum.createAccountDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campo de email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: LabelsEnum.email,
                          hintText: LabelsEnum.enterEmail,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: FormValidators.validEmail,
                      ),
                      const SizedBox(height: 16),

                      // Campo de senha
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: LabelsEnum.password,
                          hintText: LabelsEnum.enterPassword,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LabelsEnum.enterPasswordRegister;
                          }
                          return _validatePassword(value);
                        },
                        onChanged: (value) {
                          setState(() {}); // Atualiza o indicador de força
                        },
                      ),
                      const SizedBox(height: 8),

                      // Indicador de força da senha
                      _buildPasswordStrengthIndicator(passwordController.text),
                      const SizedBox(height: 16),

                      // Campo de confirmar senha
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: LabelsEnum.confirmPassword,
                          hintText: LabelsEnum.enterConfirmPassword,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LabelsEnum.confirmPasswordRegister;
                          }
                          if (value != passwordController.text) {
                            return LabelsEnum.passwordsDoNotMatch;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text(LabelsEnum.cancel),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            var response = await register(
                              emailController.text,
                              passwordController.text,
                            );

                            setState(() {
                              isLoading = false;
                            });
                            if (response != null) {
                              await UserProvider().setToken(response['token']);
                              Navigator.of(context).pop();
                              Navigator.pushReplacementNamed(context, '/main');
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(LabelsEnum.register),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Constrói indicador de força da senha
  static Widget _buildPasswordStrengthIndicator(String password) {
    final strength = _calculatePasswordStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              LabelsEnum.passwordStrength,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 8),
            Text(
              _getStrengthText(strength),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getStrengthColor(strength),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.only(right: 4),
              height: 4,
              width: 20,
              decoration: BoxDecoration(
                color: index < strength
                    ? _getStrengthColor(strength)
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        _buildPasswordRequirements(password),
      ],
    );
  }

  /// Constrói lista de requisitos da senha
  static Widget _buildPasswordRequirements(String password) {
    final requirements = [
      {'text': LabelsEnum.minLength, 'met': password.length >= 6},
      {
        'text': LabelsEnum.uppercaseLetter,
        'met': password.contains(RegExp(r'[A-Z]')),
      },
      {
        'text': LabelsEnum.specialCharacter,
        'met': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements.map((req) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            children: [
              Icon(
                req['met'] as bool ? Icons.check_circle : Icons.circle_outlined,
                size: 12,
                color: req['met'] as bool ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                req['text'] as String,
                style: TextStyle(
                  fontSize: 10,
                  color: req['met'] as bool ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Calcula a força da senha
  static int _calculatePasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 6) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    if (password.length >= 8) strength++;

    return strength;
  }

  /// Obtém texto da força da senha
  static String _getStrengthText(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return LabelsEnum.weakPassword;
      case 2:
        return LabelsEnum.mediumPassword;
      case 3:
        return LabelsEnum.strongPassword;
      case 4:
        return LabelsEnum.veryStrongPassword;
      default:
        return LabelsEnum.weakPassword;
    }
  }

  /// Obtém cor da força da senha
  static Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  /// Valida a senha conforme requisitos
  static String? _validatePassword(String password) {
    if (password.length < 6) {
      return LabelsEnum.passwordMinLengthRegister;
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return LabelsEnum.passwordUppercaseRegister;
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return LabelsEnum.passwordSpecialCharRegister;
    }
    return null;
  }
}
