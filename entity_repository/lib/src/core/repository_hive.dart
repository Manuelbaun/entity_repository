part of entity_repository;

class RepositoryHive<T extends DataModel<T>> implements RepositoryBase<T> {
  // once late final field, remove ignore on class
  /// protext etc..

  Box<T> _box;

  /// The [initialize] method is used to open a hive box
  /// to the matching [RepositoryHive] of type [T]
  ///
  // TODO: open box parameter strategy
  @override
  FutureOr<RepositoryBase<T>> initialize() async {
    final typeString = T.toString().toLowerCase();
    _box = await Hive.openBox('$typeString.box');
    return this;
  }

  /// This closese the box
  @override
  Future<void> dispose() async {
    await _box.close();
  }

  /// This will delete the entity of [T], when it is exists. Otherwise it will
  /// do nothing.
  @override
  Future<void> delete(T entity) async {
    assert(entity != null);

    await _box.delete(entity.id);
  }

  /// This will delete all provided enities
  @override
  Future<void> deleteMany(Iterable<T> entities) async {
    assert(entities != null);

    await _box.deleteAll(entities.map((e) => e.id));
  }

  /// This will return all enitites, which are currently in the box
  /// works only for a regular hive box and not a lazy box
  @override
  Iterable<T> findAll() => _box.values;

  /// This will iterate through the provided Keys, could be an int or String
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

  /// This will lookup the key. If it exists, it will return the enitiy,
  /// otherwise null
  @override
  T findOne(dynamic key) => _box.get(key);

  /// This will update the enitiy. If the enitity did not exists prior to that
  /// it will throw an [EntityRepositoryException]
  /// So make sure, the enitiy exists.
  ///
  /// This API might change in the future, into something like upsert.
  /// Otherwise use [insert] with override= true
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
      // TODO: errors?
    }

    return entities;
  }

  /// This will return a [Stream<T>], on a specific entity of the provided key
  /// if the key is null or the key does not exist in that box,
  /// this method will return *null*
  @override
  Stream<T> watch(dynamic key) {
    if (key == null || !_box.containsKey(key)) return null;

    return _box.watch(key: key).map<T>((BoxEvent event) => event.value as T);
  }

  /// This will return a [Stream<Iterable<T>>]
  @override
  Stream<Iterable<T>> watchAll() {
    return _box.watch().map<Iterable<T>>((_) => _box.values);
  }

  /// This will insert an entity in the box if the key does not exists.
  /// If the key does exist, it will throw an [EntityRepositoryException].
  ///
  /// To override an existing enitity use override = true
  /// This method acts then as an upsert
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

  /// This will clear the Hive box and remove all entries
  @override
  Future<void> clearRepository() async {
    await _box.clear();
  }
}
