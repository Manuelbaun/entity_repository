part of entity_repository;

///
/// At the moment the Indexes mixin is only using strings and no numbers
///

mixin IndexesAccess<T extends DataModel<T>> {
  // remove box indexes
  static LazyBox<IndexBase<String>> _boxIndexes;

  /// TODO: fixme, should always be the exact same ???
  static final Map<Type, Map<String, IndexBase<String>>> _indexes = {};

  /// Keys should only be a string, a number, or a set of strings or numbers!!
  Future<void> registerIndexes(List<String> indexes) async {
    _boxIndexes ??= await Hive.openLazyBox('indexes.box');

    if (_indexes[T] == null) {
      _indexes[T] = <String, IndexBase<String>>{};

      for (final index in indexes) {
        _indexes[T][index] = await _boxIndexes.get(
          index,
          defaultValue: IndexImpl<String>(index),
        );
      }
    }

    // else do not register it again...
  }

  IndexBase<String> indexGet(String key) {
    return _indexes[T][key];
  }

  Future<void> indexSave() async {
    for (final key in _indexes[T].keys) {
      final index = _indexes[T][key];
      await _boxIndexes.put('$T\-$key', index);
    }
  }

  Future<void> indexSaveAll() async {
    for (final type in _indexes.keys) {
      for (final key in _indexes[type].keys) {
        final index = _indexes[type][key];
        await _boxIndexes.put(index.name, index);
      }
    }
  }

  Future<void> indexDispose() async {
    /// TODO: save all??
    await _boxIndexes.close();
  }

  static String toStringy() => _indexes.toString();
}
