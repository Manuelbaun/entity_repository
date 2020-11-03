part of entity_repository_generator;

class ColorPrint {
  static toYellow(dynamic msg) {
    final color = AnsiPen()..yellow();
    return color(msg.toString());
  }

  static void yellow(dynamic msg) {
    final color = AnsiPen()..yellow();
    print(color(msg.toString()));
  }

  static void red(dynamic msg) {
    final color = AnsiPen()..red();
    print(color(msg.toString()));
  }
}
