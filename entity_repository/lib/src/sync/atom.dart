part of entity_repository;

/// Curd actions
enum CrudAction { insert, update, delete }

/// TODO:
/// Data needs some nested equality check
/// Note, the equality check will check on value equality
class Atom {
  /// timestamp in milliseconds since epoch
  final int timestamp;

  /// The entity's Id
  final String id;

  /// TODO: This could be an int
  final String typeModel;

  /// The crud operation
  final CrudAction action;

  /// data, need to serializable
  final dynamic data;

  Atom({
    int ms,
    this.id,
    this.typeModel,
    this.action,
    this.data,
  }) : timestamp = ms ?? DateTime.now().millisecondsSinceEpoch;

  @override
  String toString() {
    return 'Atom(ts: $timestamp, id: $id, typeModel: $typeModel, CRUD: $action, data: $data)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Atom &&
        o.timestamp == timestamp &&
        o.id == id &&
        o.typeModel == typeModel &&
        o.action == action &&
        nestedHashing(o.data) == nestedHashing(data);
  }

  @override
  int get hashCode {
    return timestamp.hashCode ^
        id.hashCode ^
        typeModel.hashCode ^
        action.hashCode ^
        data.hashCode;
  }
}
