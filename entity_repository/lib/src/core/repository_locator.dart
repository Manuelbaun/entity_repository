part of entity_repository;

/// The RepositoryLocater is used to lookup a repository of an entity model
typedef EntityMapFactory<T extends EntityBase<T>> = EntityBase<T> Function(
    Map<int, dynamic>);

///
/// Repository Locator
///
///
class RepositoryLocator {
  final _mapStringRepo = <String, RepositoryBase>{};

  List<RepositoryBase> get values => _mapStringRepo.values.toList();

  RepositoryBase getRepoByName(String type) => _mapStringRepo[type];
  RepositoryBase getRepoByTypeId(int type) =>
      throw UnimplementedError('This is not implemented yet');

  /// Register a [repository] of type [T] and its [Serializer] adapter
  void register<T extends EntityBase<T>>(RepositoryBase<T> repository) {
    final type = repository.type;

    if (!_mapStringRepo.containsKey(type)) {
      _mapStringRepo[type] = repository;
    } else {
      throw EntityRepositoryError(
          'Type ${T.runtimeType} is already registered');
    }
  }

  /// Will Return the [RepositoryBase] of type [T]
  ///
  // FIXME:
  // Look into, why the Type for example Person hashcode is different
  // depending from where the function got called?
  //
  // TODO: wait, till the dart type VM issue is fixed:
  // https://github.com/dart-lang/sdk/issues/42954
  //
  RepositoryBase<T> get<T extends EntityBase<T>>() {
    final type = T.toString().toLowerCase();

    if (_mapStringRepo.containsKey(type)) {
      return _mapStringRepo[type] as RepositoryBase<T>;
    }

    throw EntityRepositoryError(
        'Type $type does not exist. Did you register the type?');
  }

  /// This will initialize all repositories, which are registered.
  Future<void> initAll({
    @required Synchronizer synchronizer,
    @required ChainTracker chainTracker,
    @required bool shoudSaveSubEntities,
  }) async {
    for (final repo in values) {
      await repo.initialize(
        chainTracker: chainTracker,
        shoudSaveSubEntities: true,
        synchronizer: synchronizer,
      );
    }
  }

  Future<void> disposeAll() async {
    for (final repo in values) {
      await repo.dispose();
    }
  }
}
