class InvalidAddressException implements Exception {
  const InvalidAddressException([this.message]);

  final String? message;

  @override
  String toString() {
    String content = 'InvalidAddressException';
    if (message != null) content = '$content: $message';
    return content;
  }
}

class InvalidAndroidException implements Exception {
  const InvalidAndroidException([this.message]);

  final String? message;

  @override
  String toString() {
    String content = 'InvalidAndroidException';
    if (message != null) content = '$content: $message';
    return content;
  }
}

class InvalidConsentException implements Exception {
  const InvalidConsentException([this.message]);

  final String? message;

  @override
  String toString() {
    String content = 'InvalidConsentException';
    if (message != null) content = '$content: $message';
    return content;
  }
}