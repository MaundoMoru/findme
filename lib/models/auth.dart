class Auth {
  final String status;
  final bool? valid;
  final String phoneNumber;

  const Auth({
    required this.valid,
    required this.status,
    required this.phoneNumber,
  });

  factory Auth.fromJson(Map<String, dynamic> parsedJson) {
    return Auth(
      valid: parsedJson['valid'],
      status: parsedJson['status'].toString(),
      phoneNumber: parsedJson['phoneNumber'].toString(),
    );
  }
}
