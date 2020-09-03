// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Address]
abstract class _$Address extends DataModel<Address> {
  _$Address(String id) : super(id);
  String street;
  int houseNumber;
  Address copyWith({String id, String street, int houseNumber});
}

class _Address extends DataModel<Address> implements Address {
  _Address({String id, this.street, this.houseNumber}) : super(id);

  @override
  String street;
  @override
  int houseNumber;
  @override
  Address copyWith({String id, String street, int houseNumber}) {
    return _Address(
        id: id ?? this.id,
        street: street ?? this.street,
        houseNumber: houseNumber ?? this.houseNumber);
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is _Address &&
        o.id == id &&
        o.street == street &&
        o.houseNumber == houseNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^ street.hashCode ^ houseNumber.hashCode;
  }

  @override
  String toString() =>
// ignore: lines_longer_than_80_chars
      'Address(id: $id , street: $street, houseNumber: $houseNumber)';
}

/// The serialize adapter of type [_Address]
class $AddressAdapter implements Serializer<_Address> {
  @override
  final int typeId = 12;

  @override
  _Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Address(id: fields[0] as String)
      ..street = fields[1] as String
      ..houseNumber = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, _Address obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.street)
      ..writeByte(2)
      ..write(obj.houseNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
