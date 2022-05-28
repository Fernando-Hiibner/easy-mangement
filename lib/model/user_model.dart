class UserModel {
  final int id;
  final String email;
  final String password;
  final double limit;
  final String verificationCode;
  final bool verified;

  const UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.limit,
    required this.verificationCode,
    required this.verified,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      limit: json['limit'],
      verificationCode: json['verificationCode'],
      verified: json['verified']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'limit': limit,
      'verificationCode': verificationCode,
      'verified': verified
    };
  }
}
