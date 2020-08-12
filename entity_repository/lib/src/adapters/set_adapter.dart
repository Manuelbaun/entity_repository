part of entity_repository;

class SetAdapter extends Serializer<Set> {
  @override
  final int typeId;
  SetAdapter(this.typeId);

  @override
  Set read(BinaryReader reader) => Set.from(reader.readList());

  @override
  void write(BinaryWriter writer, Set obj) {
    writer.writeList(obj.toList());
  }
}
