class AuthException implements Exception {
  static const Map<String, String> errors = {
    "EMAIL_EXISTS": "O endereço de e-mail já está sendo usado por outra conta",
    "OPERATION_NOT_ALLOWED": "Operação não permitida.",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Bloqueamos todos os pedidos deste dispositivo devido a atividade incomum. Tente novamente mais tarde.",
    "EMAIL_NOT_FOUND":
        "Nenhum registro encontrado para este endereço de e-mail.",
    "INVALID_PASSWORD": "A senha é inválida ou o usuário não possui uma senha.",
    "USER_DISABLED": "A conta do usuário foi desativada por um administrador.",
    "INVALID_LOGIN_CREDENTIALS": "Credenciais de Login Inválidas.",
  };

  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? "Ocorreu um erro na autenticação";
  }
}
