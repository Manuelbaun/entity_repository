part of entity_repository;

/// The RepositoryLocater is used to lookup a repository of an entity model
///
class _RepositoryLocator {
  final _map = <String, RepositoryBase>{};
  bool _isConfigured = false;
  void configure({String path}) {
    Hive.init(path);
    _isConfigured = true;
  }

  /// use this internally, to [Serializer] adapter
  void registerAdapter<T>(Serializer<T> adapter) {
    try {
      Hive.registerAdapter<T>(adapter);
    } catch (e) {
      // throw HIveError
      rethrow;
    }
  }

  /// Register a [repository] of type [T] and its [Serializer] adapter
  void registerEntity<T extends DataModel<T>>(
      RepositoryBase<T> repository, Serializer<T> adapter) {
    if (!_isConfigured) {
      throw EntityRepositoryException(
          'Please configure the $_RepositoryLocator first.');
    }
    final typeString = T.toString();

    if (!_map.containsKey(typeString)) {
      _map[typeString] = repository;

      registerAdapter<T>(adapter);
    } else {
      throw EntityRepositoryException(
          'Type ${T.runtimeType} is already registered');
    }
  }

  /// Will Return the [RepositoryBase] of type [T]
  ///
  // FIXME:
  // Look into, why the Type for example Person hashcode is different
  // depending from where the function got called?
  //
  // TODO: wait, till the dart type VM issue is fixed:
  // https://github.com/dart-lang/sdk/issues/42954
  //
  RepositoryBase<T> get<T extends DataModel<T>>() {
    final typeString = T.toString();
    if (_map.containsKey(typeString)) {
      return _map[typeString] as RepositoryBase<T>;
    }

    throw EntityRepositoryException(
        'Type $typeString does exist. Did you register the type?');
  }

  /// This will initialize all repositories, which are registered.
  Future<void> initAll() async {
    for (final repo in _map.values) {
      await repo.initialize();
    }
  }

  Future<void> disposeAll() async {
    for (final repo in _map.values) {
      await repo.dispose();
    }
  }
}
