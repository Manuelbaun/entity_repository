part of entity_repository;

class RepositoryHive<T extends EntityBase<T>> implements RepositoryBase<T> {
  RepositoryHive(this.hiveInstance, this._entityMapFactory)
      : _type = T.toString().toLowerCase(),
        assert(hiveInstance != null, 'Please provide a HiveInstance'),
        assert(_entityMapFactory != null, 'Please provide a EnitiyMapFactory');

  Box<T> _box;
  String _type;

  @override
  String get type => _type;

  final EntityMapFactory<EntityBase> _entityMapFactory;
  @override
  // TODO: implement factoryFunction
  EntityMapFactory<EntityBase> get factoryFunction => _entityMapFactory;

  final HiveInterface hiveInstance;

  Synchronizer _synchronizer;
  ChainTracker _chainTracker;
  bool _shoudSaveSubEntities;

  /// The [initialize] method is used to open a hive box
  /// to the matching [RepositoryHive] of type [T]
  ///
  // TODO: open box parameter strategy
  @override
  FutureOr<RepositoryBase<T>> initialize({
    @required Synchronizer synchronizer,
    @required ChainTracker chainTracker,
    @required bool shoudSaveSubEntities,
  }) async {
    _box = await hiveInstance.openBox('$_type.box');

    _synchronizer = synchronizer;
    _chainTracker = chainTracker;
    _shoudSaveSubEntities = shoudSaveSubEntities;
    return this;
  }

  @override
  int get length => _box.length;

  /// This closese the box
  @override
  Future<void> dispose() async {
    await _box.close();
  }

  /// This will return all enitites, which are currently in the box
  /// works only for a regular hive box and not a lazy box
  @override
  Iterable<T> findAll() => _box.values;

  /// This will iterate through the provided Keys, could be an int or String
  @override
  Iterable<T> findMany(Iterable keys) {
    if (keys == null) return null;

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
  T findOne(dynamic key) {
    if (key == null) return null;

    return _box.get(key);
  }

  @pragma('vm:prefer-inline')
  void _syncUpdate(T entity, bool fromRemote) {
    if (!fromRemote && _synchronizer != null) _synchronizer.update<T>(entity);
  }

  @pragma('vm:prefer-inline')
  void _syncInsert(T entity, bool fromRemote) {
    if (!fromRemote && _synchronizer != null) _synchronizer.insert<T>(entity);
  }

  @pragma('vm:prefer-inline')
  void _syncDelete(T entity, bool fromRemote) {
    if (!fromRemote && _synchronizer != null) _synchronizer.delete<T>(entity);
  }

  @pragma('vm:prefer-inline')
  void _syncDeleteMany(Iterable<T> entities, bool fromRemote) {
    if (!fromRemote && _synchronizer != null)
      _synchronizer.deleteMany<T>(entities);
  }

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
    /// TODO: return or throw?
    assert(entity != null);

    if (_box.containsKey(entity.id)) {
      _syncUpdate(entity, fromRemote);

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
    await _chainTracker.track(entity, () async {
      await _box.put(entity.id, entity);

      if (_shoudSaveSubEntities) {
        for (final e in entity.getAllRefObjects()) {
          /// save, if not already saved
          if (_chainTracker.isNotSavedYet(e)) await e.upsert();
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
      _syncUpdate(entity, fromRemote);

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
      _syncInsert(entity, fromRemote);

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

    _syncDelete(entity, fromRemote);

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

    _syncDeleteMany(entities, fromRemote);

    await _box.deleteAll(entities.map<dynamic>((e) => e.id));
  }
}
