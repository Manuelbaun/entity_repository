part of entity_repository;

// ignore: avoid_classes_with_only_static_members
class Synchronizer {
  static Function(Atom) onAtomUpdate;

  ///
  /// creates an atom with the entitys data
  ///
  static void insert<T extends DataModel<T>>(DataModel entity) {
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
  static void update<T extends DataModel<T>>(DataModel entity) {
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
  static void delete<T extends DataModel<T>>(DataModel entity) {
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
  static void deleteMany<T extends DataModel<T>>(Iterable<DataModel> entities) {
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
  static Future<void> receivedRemoteAtom(Atom atom) async {
    final repo =
        EntitiyRepositoryConfig.repositoryLocator.getByName(atom.typeModel);

    switch (atom.action) {
      case CrudAction.insert:
        final factoryMethod =
            EntitiyRepositoryConfig.repositoryLocator.factories[atom.typeModel];
        if (factoryMethod != null) {
          final res =
              factoryMethod?.call((atom.data as Map).cast<int, dynamic>());
          await repo.insert(res, fromRemote: true);
        }
        break;
      case CrudAction.update:
        final entity = repo.findOne(atom.id);

        if (entity != null) {
          entity.applyUpdates((atom.data as Map).cast<int, dynamic>());
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
