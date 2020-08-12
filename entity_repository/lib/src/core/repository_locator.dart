part of entity_repository;

class _RepositoryLocator {
  final _map = <String, RepositoryBase>{};
  bool _isConfigured = false;
  void configure({String path}) {
    Hive.init(path);
    _isConfigured = true;
  }

  void _registerAdapter<T>(Serializer<T> adapter) {
    try {
      Hive.registerAdapter<T>(adapter);
    } catch (e) {
      // throw HIveError
      rethrow;
    }
  }

  /// Register a [repository] of type [T]
  void registerEntity<T extends DataModel<T>>(
      RepositoryBase<T> repository, Serializer<T> adapter) {
    if (!_isConfigured) {
      throw EntityRepositoryException(
          'Please configure the $_RepositoryLocator first.');
    }
    final typeString = T.toString();

    if (!_map.containsKey(typeString)) {
      _map[typeString] = repository;

      _registerAdapter<T>(adapter);
    } else {
      throw EntityRepositoryException(
          'Type ${T.runtimeType} is already registered');
    }
  }

  /// Will Return the [RepositoryBase] of type [T]
  ///
  /// FIXME:
  /// Look into, why the Type for example Person hashcode is different
  /// depending from where the function got called?
  ///
  RepositoryBase<T> get<T extends DataModel<T>>() {
    final typeString = T.toString();
    if (_map.containsKey(typeString)) {
      return _map[typeString] as RepositoryBase<T>;
    }
    throw EntityRepositoryException(
        'Type $typeString does exist. Did you register the type?');
  }

  Future<void> initAll() async {
    for (final dao in _map.values) {
      await dao.initialize();
    }
  }

  Future<void> disposeAll() async {
    for (final dao in _map.values) {
      await dao.dispose();
    }
  }
}
