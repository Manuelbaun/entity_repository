part of entity_repository;

/// Baseclass of a Dao T extends [EntityBase]<EntityBase> which takes only a Class that
/// extends the [EntityBase]
abstract class RepositoryBase<T extends EntityBase<T>> {
  /// The Type Id
  int get typeId;
  int get length;
  String get type;

  /// can only be set once
  RepositoryLocator locator;

  @mustCallSuper
  FutureOr<RepositoryBase<T>> initialize({
    @required Synchronizer synchronizer,
    @required ChainTracker chainTracker,
    @required bool shoudSaveSubEntities,
  });

  EntityMapFactory get factoryFunction;

  @mustCallSuper
  Future<void> dispose();

  /// Returns a Stream, which listens to the key.
  /// Returns null, if key does not exist
  Stream<T> watch(dynamic key);

  Stream<Iterable<T>> watchAll();

  T findOne(dynamic key);

  Iterable<T> findMany(Iterable keys);

  Iterable<T> findAll();

  Future<bool> insert(T entity,
      {bool override = false, bool fromRemote = false});

  Future<Iterable<T>> insertMany(Iterable<T> entities,
      {bool override = false, bool fromRemote = false});

  Future<bool> update(T entity, {bool fromRemote = false});

  Future<Iterable<T>> updateMany(Iterable<T> entities,
      {bool fromRemote = false});

  /// deletes the provided entity
  Future<void> delete(T entity, {bool fromRemote = false});

  /// deletes the entity by the provided id
  Future<void> deleteById(String id, {bool fromRemote = false});

  /// deletes the provided entities
  Future<void> deleteMany(Iterable<T> entities, {bool fromRemote = false});

  /// This will remove all entries from the repository
  Future<void> clearRepository();
}
