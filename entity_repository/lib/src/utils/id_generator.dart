// copied from: https://github.com/levicook/cuid
// levicook@gmail.com

part of entity_repository;

const _base = 36; // size of the alphabet
const _max = 0xFFFFFFFF;
var _secureRandom = new Random.secure();

/// fix upper limit of 65536
const int _discreteValues = 0xffff;

class IdGenerator {
  static int _counter = 0;
  static String _counterBlock() {
    _counter = _counter < _discreteValues ? _counter : 0;

    return _pad((_counter++).toRadixString(_base), 4);
  }

  /// The time block will get the milliseconds since epoch
  static String _timeBlock() {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    return now.toRadixString(_base);
  }

  static String _secureRandomBlock() =>
      _pad(_secureRandom.nextInt(_max).toRadixString(_base), 4);

  static String _pad(String s, int l) {
    s = s.padLeft(l, '0');
    final ss = s.substring(s.length - l);
    return ss;
  }

  /// This function generates a new Id and is inspired by the cuid.
  /// Some parts are removed, to prevent very long Ids.
  /// In case, those are required, it will be replaced by something,
  /// that fulfill the requirement.
  static String cuidSemi() {
    // time block (exposes exactly when id was generated, on purpose)
    final tblock = _timeBlock();

    // counter block
    final cblock = _counterBlock();

    // random block
    final rblock = _secureRandomBlock() + _secureRandomBlock();

    return tblock + cblock + rblock;
  }

// https://pub.dev/packages/nanoid/install
// for some reason dart would not find the package?
  static const url =
      '_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const ids =
      '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /// will create a cryptographically secure id
  static String nanoid([int size = 20]) => generate(ids, size);

  static String generate(String alphabet, int size) {
    String id = '';
    while (0 < size--) {
      id += alphabet[_secureRandom.nextInt(alphabet.length)];
    }
    return id;
  }
}
