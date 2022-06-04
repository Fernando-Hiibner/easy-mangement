class UserModel {
  final int id;
  final String email;
  final String password;
  final num maxlimit;
  final String verificationCode;
  final bool verified;

  const UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.maxlimit,
    required this.verificationCode,
    required this.verified,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      maxlimit: json['maxlimit'],
      verificationCode: json['verificationCode'],
      verified: json['verified'] == 0 ? false : true);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'maxlimit': maxlimit,
      'verificationCode': verificationCode,
      'verified': verified
    };
  }
}
