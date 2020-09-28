part of entity_repository;

enum Action { insert, update, delete }

class Atom {
  final int ms;

  final String id;

  /// TODO: This could be an int
  final String typeModel;
  final Action action;
  final dynamic data;

  Atom({
    this.id,
    this.typeModel,
    this.action,
    this.data,
  }) : ms = DateTime.now().millisecondsSinceEpoch;

  @override
  String toString() {
    return 'Atom(ms: $ms, id: $id, typeModel: $typeModel, action: $action, data: $data)';
  }
}
