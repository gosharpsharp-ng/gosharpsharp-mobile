class PaystackResponse {
  final bool success;
  final String? authorizationUrl;
  final String? accessCode;

  PaystackResponse({
    required this.success,
    this.authorizationUrl,
    this.accessCode,
  });
}
