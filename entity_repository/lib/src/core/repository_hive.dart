part of entity_repository;

class RepositoryHive<T extends DataModel<T>> implements RepositoryBase<T> {
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

  @override
  int get length => _box.length;

  /// This closese the box
  @override
  Future<void> dispose() async {
    print('-------- repository_hive.dart: 23: close box ${T.toString()}');
    await _box.close();
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
  ///
  /// [fromRemote] will trigger the Synchronizer to be called
  @override
  Future<bool> update(
    T entity, {
    bool fromRemote = false,
  }) async {
    assert(entity != null);

    if (_box.containsKey(entity.id)) {
      if (!fromRemote) Synchronizer.update<T>(entity);

      /// stores
      await _upsertEntitiesWithAllSubEntites(entity);
      return true;
    }

    return false;
  }

  /// This function puts the entity by its id into the box.
  /// Additionally, if the entity got some sub entities
  /// those will be stored as well.
  Future<void> _upsertEntitiesWithAllSubEntites(T entity) async {
    await EntitiyRepositoryConfig.chainTracker.track(entity, () async {
      await _box.put(entity.id, entity);

      if (EntitiyRepositoryConfig.shouldStoreSubentites) {
        for (final e in entity.getAllRefObjects()) {
          if (EntitiyRepositoryConfig.chainTracker.isNotSavedYet(e)) {
            await e.upsert();
          }
        }
      }
    });
  }

  /// Updates only if the key is present!
  @override
  Future<Iterable<T>> updateMany(
    Iterable<T> entities, {
    bool fromRemote = false,
  }) async {
    assert(entities != null);

    for (final entity in entities) {
      if (!fromRemote) Synchronizer.update<T>(entity);

      /// stores
      await _upsertEntitiesWithAllSubEntites(entity);
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
  Future<bool> insert(
    T entity, {
    bool override = false,
    bool fromRemote = false,
  }) async {
    assert(entity != null);

    if (override || (!override && !_box.containsKey(entity.id))) {
      if (!fromRemote) Synchronizer.insert<T>(entity);

      /// stores
      await _upsertEntitiesWithAllSubEntites(entity);
      return true;
    }

    return false;
  }

  /// inserts only if the key is *NOT* present!
  /// When override =true, then it will insert the entity
  @override
  Future<Iterable<T>> insertMany(
    Iterable<T> entities, {
    bool override = false,
    bool fromRemote = false,
  }) async {
    assert(entities != null);

    for (final e in entities) {
      await insert(e, override: override, fromRemote: fromRemote);
    }
    return entities;
  }

  /// This will clear the Hive box and remove all entries
  @override
  Future<void> clearRepository() async {
    await _box.clear();
  }

  /// This will delete the entity of [T], when it is exists. Otherwise it will
  /// do nothing.
  @override
  Future<void> delete(T entity, {bool fromRemote = false}) async {
    assert(entity != null);

    if (!fromRemote) Synchronizer.delete<T>(entity);

    await _box.delete(entity.id);
  }

  @override
  Future<void> deleteById(String id, {bool fromRemote = false}) async {
    await _box.delete(id);
  }

  /// This will delete all provided enities
  @override
  Future<void> deleteMany(
    Iterable<T> entities, {
    bool fromRemote = false,
  }) async {
    assert(entities != null);

    if (!fromRemote) Synchronizer.deleteMany<T>(entities);

    await _box.deleteAll(entities.map<dynamic>((e) => e.id));
  }
}
