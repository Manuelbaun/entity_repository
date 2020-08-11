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
}
