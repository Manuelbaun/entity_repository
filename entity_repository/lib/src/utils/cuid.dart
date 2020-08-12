// copied from: https://github.com/levicook/cuid
// levicook@gmail.com

import 'dart:math';

const int _base = 36; // size of the alphabet
const _max = 0xFFFFFFFF;

final _secureRandom = Random.secure();
const int _discreteValues = _base << 1;

int _counter = 0;

String _timeBlock() {
  final now = DateTime.now().toUtc().millisecondsSinceEpoch;
  return now.toRadixString(_base);
}

String _counterBlock() {
  _counter = _counter < _discreteValues ? _counter : 0;
  _counter++;
  return _pad((_counter - 1).toRadixString(_base), 2);
}

String _secureRandomBlock() {
  return _pad(_secureRandom.nextInt(_max).toRadixString(_base), 4);
}

String _pad(String s, int l) {
  s = s.padLeft(l, '0');
  return s.substring(s.length - l);
}

/// This function generates a new Id and is inspired by the cuid.
/// Some parts are removed, to prevent very long Ids.
/// In case, those are required, it will be replaced by something,
/// that fulfill the requirement.
String newSemiCuid() {
  // time block (exposes exactly when id was generated, on purpose)
  final tblock = _timeBlock();

  // counter block
  final cblock = _counterBlock();

  // random block
  final rblock = _secureRandomBlock() + _secureRandomBlock();

  return tblock + cblock + rblock;
}
