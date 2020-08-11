part of entity_repository;

class _RepositoryLocator {
  final _map = <String, RepositoryBase>{};

  /// Register a [dao] of type [T]
  void registerDao<T extends DataModel<T>>(RepositoryBase<T> dao) {
    final typeString = T.toString();
    if (!_map.containsKey(typeString)) {
      _map[typeString] = dao;
      // registerAdapter<T>(dao);
    } else {
      throw EntityRepoError('Type ${T.runtimeType} is already registered');
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
    throw EntityRepoError(
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
