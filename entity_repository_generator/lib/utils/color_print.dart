part of entity_repository_generator;

class Print {
  static void yellow(dynamic msg) {
    final color = AnsiPen()..yellow();
    print(color(msg.toString()));
  }

  static void red(dynamic msg) {
    final color = AnsiPen()..red();
    print(color(msg.toString()));
  }
}
