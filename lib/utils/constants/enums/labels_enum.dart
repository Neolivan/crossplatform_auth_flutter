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

  // Tela de perfil do usuário
  static const String userProfile = 'Perfil do Usuário';
  static const String userNotFound = 'Usuário não encontrado';
  static const String logout = 'Logout';
  static const String firstName = 'Primeiro Nome';
  static const String lastName = 'Último Nome';
  static const String avatarUrl = 'URL do Avatar';
  static const String avatarUrlHint = 'https://exemplo.com/avatar.jpg';
  static const String saveChanges = 'Salvar Alterações';
  static const String deleteAccount = 'Excluir Conta';
  static const String deleteAccountTitle = 'Excluir Conta';
  static const String deleteAccountMessage =
      'Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.';
  static const String delete = 'Excluir';
  static const String accountDeletedSuccess = 'Conta excluída com sucesso';
  static const String profileUpdateError = 'Erro ao atualizar perfil';
  static const String accountDeleteError = 'Erro ao excluir conta';
  static const String logoutError = 'Erro no logout';
  static const String logoutErrorMessage = 'Erro ao fazer logout';

  // Validações de perfil
  static const String enterFirstName = 'Por favor, insira seu primeiro nome';
  static const String enterLastName = 'Por favor, insira seu último nome';
  static const String enterEmailProfile = 'Por favor, insira seu email';
  static const String enterValidEmail = 'Por favor, insira um email válido';

  // Botão de perfil do usuário
  static const String editProfile = 'Editar Perfil';

  // Tela de login - textos adicionais
  static const String checkingAuthentication = 'Verificando autenticação...';
  static const String enterPasswordValidation = 'Por favor, digite sua senha';
  static const String passwordMinLength =
      'A senha deve ter pelo menos 6 caracteres';

  // Tela de página não encontrada
  static const String pageNotFound = 'Página não encontrada';
  static const String error404 = '404';

  // Dialog de registro - textos adicionais
  static const String enterPasswordRegister = 'Por favor, digite sua senha';
  static const String confirmPasswordRegister = 'Por favor, confirme sua senha';
  static const String passwordMinLengthRegister =
      'A senha deve ter pelo menos 6 caracteres';
  static const String passwordUppercaseRegister =
      'A senha deve conter pelo menos uma letra maiúscula';
  static const String passwordSpecialCharRegister =
      'A senha deve conter pelo menos um caractere especial';

  // Mensagens de serviços (UserServices)
  static const String loginSuccessService = 'Login realizado com sucesso';
  static const String loginFailed = 'Falha ao fazer login';
  static const String invalidCredentials = 'Email ou senha inválidos';
  static const String connectionError = 'Erro de conexão';
  static const String checkInternetConnection =
      'Verifique sua conexão com a internet';
  static const String registerSuccess = 'Registro realizado com sucesso';
  static const String registerFailed = 'Falha ao fazer registro';
  static const String registerError = 'Erro ao fazer registro';
  static const String checkInfoAndTryAgain =
      'Verifique as informações e tente novamente';
  static const String getUserInfoFailed =
      'Falha ao buscar informações do usuário';
  static const String logoutSuccess = 'Logout realizado com sucesso';
  static const String logoutFailed = 'Falha ao fazer logout';
  static const String userUpdatedSuccess = 'Usuário atualizado com sucesso';
  static const String userUpdateFailed = 'Falha ao atualizar usuário';
  static const String userDeletedSuccess = 'Usuário deletado com sucesso';
  static const String userDeleteFailed = 'Falha ao deletar usuário';
}
