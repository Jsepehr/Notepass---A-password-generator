// ignore_for_file: public_member_api_docs, sort_constructors_first
class Pwd {
  final int pwdId;
  final String pwdCorpo;
  final String pwdHint;
  final int flagUsed;

  Pwd({
    required this.pwdId,
    required this.pwdCorpo,
    required this.pwdHint,
    required this.flagUsed,
  });

  factory Pwd.fromMap(Map<String, dynamic> map) {
    return Pwd(
      pwdId: map['id'] as int,
      pwdCorpo: map['password'] as String,
      pwdHint: map['hint'] as String,
      flagUsed: map['used'] as int,
    );
  }

  @override
  String toString() {
    return 'Pwd(pwdId: $pwdId, pwdCorpo: $pwdCorpo, pwdHint: $pwdHint, flagUsed: $flagUsed)';
  }
}
