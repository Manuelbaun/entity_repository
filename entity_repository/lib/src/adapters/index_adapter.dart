part of entity_repository;

class IndexAdapter extends Serializer<IndexImpl> {
  IndexAdapter(this.typeId);
  @override
  final int typeId;

  @override
  IndexImpl read(BinaryReader reader) {
    return IndexImpl(
      reader.readString(),
      index: reader.readMap().cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, IndexImpl obj) {
    writer
      ..writeString(obj.name)
      ..writeMap(obj.index);
  }
}
