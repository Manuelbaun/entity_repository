// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Tag]
abstract class _$Tag extends DataModel<Tag> {
  _$Tag(String id) : super(id);

  Tag copyWith({
    String id,
  });
}

class _Tag extends DataModel<Tag> implements Tag {
  _Tag({
    String id,
  }) : super(id);

  @override
  Tag copyWith({
    String id,
  }) {
    return _Tag(
      id: id ?? this.id,
    );
  }

  @override
  String toString() => '''Tag(id: $id, )''';
}

/// The serialize adapter of type [_Tag]
class $TagAdapter implements Serializer<_Tag> {
  @override
  final int typeId = 13;

  @override
  _Tag read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Tag(id: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, _Tag obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $TagAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

/// The [$TagRepo] class of type [Tag]
class $TagRepo extends RepositoryHive<Tag> {}
