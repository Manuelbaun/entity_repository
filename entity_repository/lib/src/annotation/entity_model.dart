part of entity_repository;

class EntityModel {
  const EntityModel(
    this.typeId, {
    this.repository = true,
    this.immutable = false,
    this.index,
  });

  final bool repository;
  final bool immutable;
  final List<Set<String>> index;
  final int typeId;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is EntityModel && o.typeId == typeId;
  }

  @override
  int get hashCode {
    return typeId.hashCode;
  }
}
