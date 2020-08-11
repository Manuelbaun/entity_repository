part of entity_repository;

class IndexAdapter extends TypeAdapter<IndexImpl> {
  @override
  final int typeId = CustomAdapterTypes.indexAdapter;

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
