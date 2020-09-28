part of entity_repository;

// ignore: avoid_classes_with_only_static_members
class Synchronizer {
  static Function(Atom) onAtomUpdate = print;

  static void insert<T extends DataModel<T>>(DataModel entity) {
    final atom = Atom(
      action: Action.insert,
      id: entity.id,
      typeModel: T.toString(),
      data: entity.toMap(),
    );
    onAtomUpdate(atom);
  }

  static void update<T extends DataModel<T>>(DataModel entity) {
    final atom = Atom(
      action: Action.update,
      id: entity.id,
      typeModel: T.toString(),
      data: entity.getUpdates(),
    );

    entity.clearUpdates();
    onAtomUpdate(atom);
  }

  static void delete<T extends DataModel<T>>(DataModel entity) {
    final atom = Atom(
      action: Action.delete,
      id: entity.id,
      typeModel: T.toString(),
    );
    onAtomUpdate(atom);
  }

  static void deleteMany<T extends DataModel<T>>(Iterable<DataModel> entities) {
    final atom = Atom(
      action: Action.delete,
      typeModel: T.toString(),
      data: entities.map((e) => e.id),
    );
    onAtomUpdate(atom);
  }

  static Future<void> receivedRemoteAtom(Atom atom) async {
    print(atom);

    final repo = repositoryLocator.getByName(atom.typeModel);

    switch (atom.action) {
      case Action.insert:
        final fac = repositoryLocator.factories[atom.typeModel];
        final res = fac?.call((atom.data as Map).cast<int, dynamic>());
        print(res);
        print('---');

        await repo.insert(res, fromRemote: true);
        break;
      case Action.update:
        final entity = repo.findOne(atom.id);

        if (entity != null) {
          entity.applyUpdates((atom.data as Map).cast<int, dynamic>());
          await repo.update(entity, fromRemote: true);
        }

        break;
      case Action.delete:
        if (atom.data is List) {
          for (final id in atom.data) {
            await repo.deleteById(id as String, fromRemote: true);
          }
        }
        await repo.deleteById(atom.id, fromRemote: true);
        break;
    }
  }
}
