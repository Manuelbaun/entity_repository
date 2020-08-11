part of entity_repository;

///
/// prototype idea of index
/// [IdType] could be String or int

abstract class IndexBase<IdType> {
  String get name;
  bool add(String value, IdType id);
  bool hasNot(String value);
  bool has(String value);
  void remove(String type);
  IdType findIdOf(String value);
}

/// a lot of potential to improve!
/// like encode the int-string-int thing
/// [Set] could contain String, ints or a mix of both..
class IndexImpl<IdType> implements IndexBase<IdType> {
  @override
  final String name;

  IndexImpl(this.name, {Map<String, IdType> index}) : _index = index ?? {};

  final Map<String, IdType> _index;
  Map<String, IdType> get index => _index;

  /// returns true if added sucessfull
  /// returns false if key already exists
  @override
  bool add(String value, IdType id) {
    if (!_index.containsKey(value)) {
      _index[value] = id;
      return true;
    }

    return false;
  }

  @override
  void remove(String value) {
    _index.remove(value);
  }

  @override
  IdType findIdOf(String value) {
    return _index[value];
  }

  @override
  String toString() {
    return _index.toString();
  }

  @override
  bool hasNot(String value) {
    return !_index.containsKey(value);
  }

  @override
  bool has(String value) {
    return _index.containsKey(value);
  }
}
