part of entity_repository;

// ignore: avoid_classes_with_only_static_members
class Synchronizer {
  Function(Atom) onAtomUpdate;
  final _repoLocator = EntitiyRepositoryConfig.repositoryLocator;

  ///
  /// creates an atom with the entitys data
  ///
  void insert<T extends EntityBase<T>>(EntityBase entity) {
    final atom = Atom(
      action: CrudAction.insert,
      id: entity.id,
      typeModel: T.toString(),
      data: entity.toMap(),
    );
    if (onAtomUpdate != null) onAtomUpdate(atom);
  }

  ///
  /// Creates an Atom with the to updated data
  ///
  void update<T extends EntityBase<T>>(EntityBase entity) {
    final atom = Atom(
      action: CrudAction.update,
      id: entity.id,
      typeModel: T.toString(),
      data: entity.getUpdates(),
    );

    entity.clearUpdates();
    if (onAtomUpdate != null) onAtomUpdate(atom);
  }

  ///
  /// Creates one atom, with the entity id, which should be deleted
  ///
  void delete<T extends EntityBase<T>>(EntityBase entity) {
    final atom = Atom(
      action: CrudAction.delete,
      id: entity.id,
      typeModel: T.toString(),
    );
    if (onAtomUpdate != null) onAtomUpdate(atom);
  }

  ///
  /// Creates an Atom, with the deleted entities ids
  ///
  void deleteMany<T extends EntityBase<T>>(Iterable<EntityBase> entities) {
    final atom = Atom(
      action: CrudAction.delete,
      typeModel: T.toString(),
      data: entities.map((e) => e.id),
    );
    if (onAtomUpdate != null) onAtomUpdate(atom);
  }

  ///
  /// Applys remote received atom to local db
  ///
  Future<void> receivedRemoteAtom(Atom atom) async {
    final repo = _repoLocator.getByName(atom.typeModel);

    switch (atom.action) {
      case CrudAction.insert:
        final factoryMethod = _repoLocator.getFromMapFactory(atom.typeModel);

        if (factoryMethod != null) {
          final atomData = (atom.data as Map).cast<int, dynamic>();
          final entity = factoryMethod.call(atomData);
          await repo.insert(entity, fromRemote: true);
        }
        break;
      case CrudAction.update:
        final entity = repo.findOne(atom.id);

        if (entity != null) {
          final atomData = (atom.data as Map).cast<int, dynamic>();
          entity.applyUpdates(atomData);
          await repo.update(entity, fromRemote: true);
        }

        break;
      case CrudAction.delete:
        if (atom.data is List) {
          for (final id in atom.data) {
            await repo.deleteById(id as String, fromRemote: true);
          }
        } else {
          await repo.deleteById(atom.id, fromRemote: true);
        }
        break;
    }
  }
}
