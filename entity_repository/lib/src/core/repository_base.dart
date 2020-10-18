part of entity_repository;

/// Baseclass of a Dao T extends [EntityBase]<T> which takes only a Class that
/// extends the [EntityBase]
abstract class RepositoryBase<T extends EntityBase<T>> {
  @mustCallSuper
  FutureOr<RepositoryBase<T>> initialize();

  int get length;

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

  Future<void> delete(T entity, {bool fromRemote = false});
  Future<void> deleteById(String id, {bool fromRemote = false});
  Future<void> deleteMany(Iterable<T> entities, {bool fromRemote = false});

  /// This will remove all entries from the repository
  Future<void> clearRepository();
}
