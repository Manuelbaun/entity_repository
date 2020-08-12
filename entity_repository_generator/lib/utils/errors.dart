part of entity_repository_generator;

class GeneratorError extends Error {
  final String message;
  GeneratorError(this.message);

  @override
  String toString() {
    final red = AnsiPen()..red();
    return red('[Entity Repository Generator ERROR] $message').toString();
  }
}
