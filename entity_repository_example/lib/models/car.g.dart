// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Car]
abstract class _$Car extends DataModel<Car> {
  _$Car(String id) : super(id);
  String model;
  String type;
  int buildYear;
  Person owner;
  Car copyWith(
      {String id, String model, String type, int buildYear, Person owner});
}

mixin _CarReferenceLookUp {
  String ownerRefs;
  Person _lookUpOwner() {
    return ReferenceLookUp.findOne<Person>(ownerRefs);
  }
}

class _Car extends DataModel<Car> with _CarReferenceLookUp implements Car {
  _Car({String id, Person owner, this.model, this.type, this.buildYear})
      : _owner = owner,
        super(id);

  @override
  String model;
  @override
  String type;
  @override
  int buildYear;

  @override
  Person get owner => _owner ??= _lookUpOwner();

  @override
  set owner(Person owner) => _owner = owner;

  Person _owner;
  @override
  Car copyWith(
      {String id, String model, String type, int buildYear, Person owner}) {
    return _Car(
        id: id ?? this.id,
        model: model ?? this.model,
        type: type ?? this.type,
        buildYear: buildYear ?? this.buildYear,
        owner: owner ?? this.owner);
  }

  @override
  String toString() =>
      '''Car(id: $id, model: $model, type: $type, buildYear: $buildYear, owner: ${owner?.id})''';
}

/// The serialize adapter of type [_Car]
class $CarAdapter implements Serializer<_Car> {
  @override
  final int typeId = 11;

  @override
  _Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Car(id: fields[0] as String)
      ..model = fields[1] as String
      ..type = fields[2] as String
      ..buildYear = fields[3] as int
      ..ownerRefs = (fields[4] as String);
  }

  @override
  void write(BinaryWriter writer, _Car obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.buildYear)
      ..writeByte(4)
      ..write(obj.owner?.id);
  }
}

/// The [$CarRepo] class of type [Car]
class $CarRepo extends RepositoryHive<Car> {}
