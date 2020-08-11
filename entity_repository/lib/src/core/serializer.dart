part of entity_repository;

abstract class Serializer<T> implements TypeAdapter<T> {
  @override
  T read(BinaryReader reader);

  @override
  int get typeId;

  @override
  void write(BinaryWriter writer, T obj);
}
