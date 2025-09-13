mixin FormValidators {
  static String? validEmail(String? emailTovalid) {
    if (emailTovalid == null || emailTovalid.isEmpty) {
      return 'Por favor, digite seu email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailTovalid)) {
      return 'Digite um email válido';
    }
    return null;
  }
}
