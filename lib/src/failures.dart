/// Thrown when authorization has not yet been managed.
/// Requires to tap on the allow button manually.
class AuthorizationRequiredException implements Exception {
  const AuthorizationRequiredException([this.message]);

  final String? message;

  @override
  String toString() {
    String content = 'AuthorizationRequiredException';
    if (message != null) content = '$content: $message';
    return content;
  }
}

/// Thrown when unsupported platform is detected.
class UnsupportedPlatformException implements Exception {
  const UnsupportedPlatformException([this.message]);

  final String? message;

  @override
  String toString() {
    String content = 'UnsupportedPlatformException';
    if (message != null) content = '$content: $message';
    return content;
  }
}
