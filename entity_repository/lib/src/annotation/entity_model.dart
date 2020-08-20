part of entity_repository;

class EntityModel {
  const EntityModel(
    this.typeId, {
    this.repository = false,
    this.immutable = false,
    this.index,
  });

  /// This effects only, if a repository class should be generated
  /// the class can be used, but has issues when used with other code
  /// generators. Since the repository class resides in the .g files..
  /// Also, if a folder structure is required as in DDD, then
  /// someone would rather write an IRepository in the domain folder
  /// and its implementation in the infrastructure folder.
  final bool repository;

  /// Has no effect jet
  final bool immutable;

  /// THis is Work in progress
  final List<Set<String>> index;

  /// Registers as this typeId
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
