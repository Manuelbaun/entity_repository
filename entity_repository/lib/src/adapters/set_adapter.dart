part of entity_repository;

/// should be hive internal ??
class SetAdapter extends TypeAdapter<Set> {
  @override
  final int typeId = CustomAdapterTypes.setAdapter;

  @override
  Set read(BinaryReader reader) => Set.from(reader.readList());

  @override
  void write(BinaryWriter writer, Set obj) {
    writer.writeList(obj.toList());
  }
}
