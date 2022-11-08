class AuthException implements Exception {
  static const Map<String, String> erros = {
    'EMAIL_EXISTS': 'E-mail ja cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente novamente mais tarde.',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado.',
    'INVALID_PASSWORD': 'Senha inválida.',
    'USER_DISABLED': 'A conta do usuário foi desabilitada.',
  };
  final String key;

  AuthException(this.key);

  @override
  String toString() {
    // TODO: implement toString
    return erros[key] ?? 'Ocorreu um erro no processo de autenticacao';
  }
}
