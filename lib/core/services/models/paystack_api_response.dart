class PaystackResponse {
  final bool success;
  final String? authorizationUrl;
  final String? reference;

  PaystackResponse({
    required this.success,
    this.authorizationUrl,
    this.reference,
  });
}
