part of entity_repository;

/// provide an ID, is not provided, it will be generated by the [DataHelper]
abstract class DataModel<T extends DataModel<T>> {
  DataModel(String id)
      : id = DataHelper.checkOrGenerateID(id),
        _base = repositoryLocator.get<T>();

  final RepositoryBase<T> _base;

  /// Through the constructur checkin,
  /// An Id is either provided by the User or will be generated, when Id is
  /// either null or an empty string. Therefore Id is guaranteed to be present
  final String id;

  void _checkBase() {
    if (_base == null) {
      throw EntityRepoError(
          'Could not find "$T" in the locator. Did you register it before use?');
    }
  }

  // TODO: Remove this. or make a nice API!
  Future<bool> upsert({bool override = true}) {
    return _base.insert(this as T, override: override);
  }

  Future<bool> update() {
    _checkBase();
    return _base.update(this as T);
  }

  Future<void> delete() {
    _checkBase();
    return _base.delete(this as T);
  }

  // will return null, if key is not stored
  Stream<T> watch() {
    _checkBase();
    return _base.watch(id);
  }
}
