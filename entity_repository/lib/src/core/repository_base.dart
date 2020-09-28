part of entity_repository;

/// Baseclass of a Dao [T extends DataModel<T>] which takes only a Class that
/// extends the DataModel
abstract class RepositoryBase<T extends DataModel<T>> {
  @mustCallSuper
  FutureOr<RepositoryBase<T>> initialize();

  @mustCallSuper
  Future<void> dispose();

  /// Returns a Stream, which listens to the key.
  /// Returns null, if key does not exist
  Stream<T> watch(dynamic key);
  Stream<Iterable<T>> watchAll();

  T findOne(dynamic key);
  Iterable<T> findMany(Iterable keys);
  Iterable<T> findAll();

  Future<bool> insert(T entity, {bool override = false});
  Future<Iterable<T>> insertMany(Iterable<T> entities, {bool override = false});

  Future<bool> update(T entity);
  Future<Iterable<T>> updateMany(Iterable<T> entities);

  Future<void> delete(T entity);
  Future<void> deleteById(String id);
  Future<void> deleteMany(Iterable<T> entities);

  /// This will remove all entries from the repository
  Future<void> clearRepository();
}
