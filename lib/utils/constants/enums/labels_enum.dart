mixin LabelsEnum {
  // Campos de formulário
  static const String email = 'Email';
  static const String password = 'Senha';

  // Placeholders
  static const String enterEmail = 'Digite seu email';
  static const String enterPassword = 'Digite sua senha';

  // Títulos e textos da tela de login
  static const String welcomeBack = 'Bem-vindo de volta!';
  static const String loginToContinue = 'Faça login para continuar';
  static const String forgotPassword = 'Esqueci minha senha';
  static const String login = 'Entrar';
  static const String or = 'ou';
  static const String createAccount = 'Criar conta';

  // Dialog de recuperar senha
  static const String recoverPassword = 'Recuperar Senha';
  static const String recoverPasswordDescription =
      'Digite seu email para receber um link de recuperação de senha.';
  static const String cancel = 'Cancelar';
  static const String send = 'Enviar';
  static const String recoveryEmailSent =
      'Email de recuperação enviado! Verifique sua caixa de entrada.';

  // Mensagens de sucesso
  static const String loginSuccess = 'Login realizado com sucesso!';

  // Dialog de registro
  static const String createAccountTitle = 'Criar Conta';
  static const String createAccountDescription =
      'Preencha os dados abaixo para criar sua conta.';
  static const String confirmPassword = 'Confirmar Senha';
  static const String enterConfirmPassword = 'Digite a senha novamente';
  static const String register = 'Registrar';
  static const String accountCreated = 'Conta criada com sucesso!';

  // Validação de senha
  static const String passwordStrength = 'Força da senha';
  static const String weakPassword = 'Fraca';
  static const String mediumPassword = 'Média';
  static const String strongPassword = 'Forte';
  static const String veryStrongPassword = 'Muito forte';

  // Requisitos de senha
  static const String minLength = 'Mínimo 6 caracteres';
  static const String uppercaseLetter = 'Uma letra maiúscula';
  static const String specialCharacter = 'Um caractere especial';
  static const String passwordsDoNotMatch = 'As senhas não coincidem';
}
