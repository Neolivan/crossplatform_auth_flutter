import 'package:crossplatform_auth_flutter/utils/constants/enums/labels_enum.dart';
import 'package:crossplatform_auth_flutter/utils/global_states/user_provider.dart';
import 'package:crossplatform_auth_flutter/utils/mixins/form_validators/form_validators.dart';
import 'package:crossplatform_auth_flutter/utils/services/user/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/forgot_password_dialog.dart';
import '../widgets/register_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with UserServices {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isCheckingAuth = true; // Novo estado para verificação de autenticação

  @override
  void initState() {
    super.initState();
    verifyIsAuthenticated();
  }

  verifyIsAuthenticated() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserData();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isCheckingAuth = false; // Para o indicador de carregamento
        });

        bool isAuthenticated = Provider.of<UserProvider>(
          context,
          listen: false,
        ).isAuthenticated;
        if (isAuthenticated) {
          Navigator.popAndPushNamed(context, '/main');
        }
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var response = await login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.setToken(response);
        Navigator.popAndPushNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se está verificando autenticação, mostra loading
    if (_isCheckingAuth) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                LabelsEnum.checkingAuthentication,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo/Ícone
                          Icon(
                            Icons.account_circle,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 24),

                          // Título
                          Text(
                            LabelsEnum.welcomeBack,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            LabelsEnum.loginToContinue,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),

                          // Campo de email
                          TextFormField(
                            controller: _emailController,
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
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: LabelsEnum.password,
                              hintText: LabelsEnum.enterPassword,
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LabelsEnum.enterPasswordValidation;
                              }
                              if (value.length < 6) {
                                return LabelsEnum.passwordMinLength;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // Esqueci minha senha
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () =>
                                  ForgotPasswordDialog.show(context),
                              child: const Text(LabelsEnum.forgotPassword),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botão de login
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(LabelsEnum.login),
                          ),
                          const SizedBox(height: 16),

                          // Divisor
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  LabelsEnum.or,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Botão de registro
                          OutlinedButton(
                            onPressed: () => RegisterDialog().show(context),
                            child: const Text(LabelsEnum.createAccount),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: ThemeToggleButton(),
          ),
        ],
      ),
    );
  }
}
