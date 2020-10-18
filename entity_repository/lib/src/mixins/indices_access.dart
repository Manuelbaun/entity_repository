part of entity_repository;

///
/// At the moment the indices mixin is only using strings and no ints
///

mixin IndicesAccess<T extends EntityBase<T>> {
  // remove box indices
  static LazyBox<IndexBase<String>> _boxindices;

  /// TODO: fixme, should always be the exact same ???
  static final Map<Type, Map<String, IndexBase<String>>> _indices = {};

  /// Keys should only be a string, a number, or a set of strings or numbers!!
  Future<void> registerindices(List<String> indices) async {
    _boxindices ??= await Hive.openLazyBox('indices.box');

    if (_indices[T] == null) {
      _indices[T] = <String, IndexBase<String>>{};

      for (final index in indices) {
        _indices[T][index] = await _boxindices.get(
          index,
          defaultValue: IndexImpl<String>(index),
        );
      }
    }

    // else do not register it again...
  }

  IndexBase<String> indexGet(String key) {
    return _indices[T][key];
  }

  Future<void> indexSave() async {
    for (final key in _indices[T].keys) {
      final index = _indices[T][key];
      await _boxindices.put('$T\-$key', index);
    }
  }

  Future<void> indexSaveAll() async {
    for (final type in _indices.keys) {
      for (final key in _indices[type].keys) {
        final index = _indices[type][key];
        await _boxindices.put(index.name, index);
      }
    }
  }

  Future<void> indexDispose() async {
    /// TODO: save all??
    await _boxindices.close();
  }

  static String toStringy() => _indices.toString();
}
