part of entity_repository;

class RepositoryHive<T extends DataModel<T>> implements RepositoryBase<T> {
  // once late final field, remove ignore on class
  /// protext etc..

  Box<T> _box;

  /// performs init of the dao.
  /// using hive under the hood, opens the hive box of type [T]

  /// TODO: open box parameter strategy
  @override
  FutureOr<RepositoryBase<T>> initialize() async {
    final typeString = T.toString().toLowerCase();
    _box = await Hive.openBox('$typeString.box');
    return this;
  }

  @override
  Future<void> dispose() async {
    await _box.close();
  }

  @override
  Future<void> delete(T entity) async {
    assert(entity != null);

    await _box.delete(entity.id);
  }

  @override
  Future<void> deleteMany(Iterable<T> entity) async {
    assert(entity != null);

    await _box.deleteAll(entity.map((e) => e.id));
  }

  @override
  Iterable<T> findAll() {
    return _box.values;
  }

  @override
  Iterable<T> findMany(Iterable keys) {
    assert(keys != null);

    final list = <T>[];

    for (final key in keys) {
      final v = _box.get(key);
      if (v != null) list.add(v);
    }
    return list;
  }

  @override
  T findOne(dynamic key) {
    return _box.get(key);
  }

  /// Updates only if the key is present!
  /// else it throws a error
  @override
  Future<bool> update(T entity) async {
    assert(entity != null);

    if (_box.containsKey(entity.id)) {
      await _box.put(entity.id, entity);
      return true;
    }

    /// TODO: should this be done here? maybe throw exception?
    /// or just return false
    throw EntityRepositoryException('''
      ${entity.runtimeType} with id: ${entity.id} does not exists. 
      Insert before update is called''');
  }

  /// Updates only if the key is present!
  @override
  Future<Iterable<T>> updateMany(Iterable<T> entities) async {
    assert(entities != null);

    for (final en in entities) {
      if (_box.containsKey(en.id)) {
        await _box.put(en.id, en);
      }
    }

    return entities;
  }

  @override
  Stream<T> watch(dynamic key) {
    if (key == null || !_box.containsKey(key)) return null;

    return _box.watch(key: key).map<T>((BoxEvent event) => event.value as T);
  }

  /// inserts only if the key is *NOT* present!
  /// When override =true, then it will
  @override
  Future<bool> insert(T entity, {bool override = false}) async {
    assert(entity != null);

    if (override || (!override && !_box.containsKey(entity.id))) {
      await _box.put(entity.id, entity);
      return true;
    }

    throw EntityRepositoryException(
        '''Could insert Type $T, since a $T with id '''
        '''of "${entity.id}" already exist.''');
  }

  /// inserts only if the key is *NOT* present!
  /// When override =true, then it will insert the entity
  @override
  Future<Iterable<T>> insertMany(Iterable<T> entities,
      {bool override = false}) async {
    assert(entities != null);

    for (final e in entities) {
      // TODO: implement insertMany map it before!! and use putall
      await insert(e, override: override);
    }
    return entities;
  }

  /// This will clear the Hive box.
  @override
  Future<void> clearRepository() async {
    await _box.clear();
  }
}
