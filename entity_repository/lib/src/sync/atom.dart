part of entity_repository;

enum Action { insert, update, delete }

/// TODO:
/// Data needs some nested equality check
/// Note, the equality check will check on value equality
class Atom {
  final int ms;
  final String id;

  /// TODO: This could be an int
  final String typeModel;
  final Action action;
  final dynamic data;

  Atom({
    int ms,
    this.id,
    this.typeModel,
    this.action,
    this.data,
  }) : ms = ms ?? DateTime.now().millisecondsSinceEpoch;

  @override
  String toString() {
    return 'Atom(ms: $ms, id: $id, typeModel: $typeModel, action: $action, data: $data)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Atom &&
        o.ms == ms &&
        o.id == id &&
        o.typeModel == typeModel &&
        o.action == action &&
        nestedHashing(o.data) == nestedHashing(data);
  }

  @override
  int get hashCode {
    return ms.hashCode ^
        id.hashCode ^
        typeModel.hashCode ^
        action.hashCode ^
        data.hashCode;
  }
}
