part of entity_repository;

/// provide an ID, is not provided, it will be generated by the [DataHelper]
abstract class EntityBase<T extends EntityBase<T>>
    with Syncable
    implements Comparable<T> {
  EntityBase(String id, RepositoryBase<T> repo)
      : id = DataHelper.checkOrGenerateID(id),
        _repo = repo,
        assert(repo != null);

  RepositoryBase<T> _repo;

  String get entityType => _repo.type;

  /// Through the constructur checkin,
  /// An Id is either provided by the User or will be generated, when Id is
  /// either null or an empty string. Therefore Id is guaranteed to be present
  final String id;

  // TODO: Remove this. or make a nice API!
  Future<bool> upsert({bool override = true}) {
    if (override || _repo.findOne(id) == null) {
      return _repo.insert(this as T, override: override);
    } else {
      return update();
    }
  }

  /// This will trigger an update and stores the current entity as is
  /// in the box. If no updates were made, there is no need to store
  /// the entity.
  Future<bool> update() {
    if (!hasUpdates) return Future.value(false);
    return _repo.update(this as T);
  }

  /// This will delete the entity.
  Future<void> delete() => _repo.delete(this as T);

  /// Returns a stream of type [T]. If id does not exists, it will return null
  Stream<T> watch() => _repo.watch(id);

  /**
   *
   * If an data model contains also references to other data model
   * in terms of (1 To N) or (Many To N), this will get all References.
   *
   *
   * TODO: Check for Performance reason, if an class is red before.
   * if not, do not try to save it.
   *
   * See Generator:
   *
   * Example
   * ```dart
   * class Car {
   *   [EntityBase] owner;
   * }
   * ```
   */
  Set<EntityBase> getAllRefObjects();

  /// Returns a map of with ints as keys and data. It is not a json map!
  Map<int, dynamic> toMap();

  /// This function takes a map (not JSON MAP) and applies the updates
  /// to the entity. Keys are int.
  void applyUpdates(Map<int, dynamic> map);

  /// The default compare to compares the Ids
  /// Therefor, only String Ids are supported for now.
  @override
  int compareTo(T other) => id.compareTo(other.id);
}

// /// This extention specifies
// extension EntityBaseX on EntityBase {
//   String get $nameLowerCase {
//     return runtimeType.toString().toLowerCase();
//   }
// }
