part of entity_repository;

// abstract class DataModelBase<T extends DataModelBase<T>>
//     implements Comparable<T> {
//   Future<bool> upsert({bool override = true});
//   Future<bool> update();
//   Future<void> delete();
//   Stream<T> watch();
// }

/// provide an ID, is not provided, it will be generated by the [DataHelper]
abstract class DataModel<T extends DataModel<T>>
    with Syncable
    implements Comparable<T> {
  DataModel(String id)
      : id = DataHelper.checkOrGenerateID(id),
        _repo = repositoryLocator.get<T>();

  final RepositoryBase<T> _repo;

  /// Through the constructur checkin,
  /// An Id is either provided by the User or will be generated, when Id is
  /// either null or an empty string. Therefore Id is guaranteed to be present
  final String id;

  void _checkBase() {
    if (_repo == null) {
      throw EntityRepositoryException(
        'Could not find "$T" in the locator. Did you register it before use?',
      );
    }
  }

  // TODO: Remove this. or make a nice API!
  Future<bool> upsert({bool override = true}) {
    _checkBase();

    if (override || _repo.findOne(id) == null) {
      return _repo.insert(this as T, override: override);
    } else {
      return update();
    }
  }

  Future<bool> update() {
    if (!hasUpdates) return Future.value(false);

    _checkBase();
    return _repo.update(this as T);
  }

  Future<void> delete() {
    _checkBase();
    return _repo.delete(this as T);
  }

  // will return null, if key is not stored
  Stream<T> watch() {
    _checkBase();
    return _repo.watch(id);
  }

  /// The default compare to compares the Ids
  /// Therefor, only String Ids are supported for now.
  @override
  int compareTo(T other) => id.compareTo(other.id);

  Map<int, dynamic> toMap();

  void applyUpdates(Map<int, dynamic> map);

  Set<DataModel> getAllRefObjects();
}
