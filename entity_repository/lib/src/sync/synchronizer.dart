part of entity_repository;

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
      data: entities.map((e) => e.id).toList(),
    );
    onAtomUpdate(atom);
  }

  static Future<void> receivedRemoteAtom(Atom atom) async {
    // factories[atom.typeModel](atom.data);
    print(atom);
    // return;
    final repo = repositoryLocator.getByName(atom.typeModel);
    switch (atom.action) {
      case Action.insert:
        final fac = repositoryLocator.factories[atom.typeModel];
        final res = fac?.call(atom.data as Map<int, dynamic>);
        print(res);
        print('---');

        await repo.insert(res);
        break;
      case Action.update:
        final entity = repo.findOne(atom.id);

        if (entity != null) {
          entity.applyUpdates(atom.data as Map<int, dynamic>);
        }

        break;
      case Action.delete:
        await repo.deleteById(atom.id);
        break;
    }
  }
}
