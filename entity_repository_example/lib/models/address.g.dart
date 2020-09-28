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
  _Address({String id, String street, int houseNumber})
      : _street = street,
        _houseNumber = houseNumber,
        super(id);

  String _street;

  @override
  String get street => _street;

  @override
  set street(String street) {
    _street = street;
    setKeyValue(1, street);
  }

  int _houseNumber;

  @override
  int get houseNumber => _houseNumber;

  @override
  set houseNumber(int houseNumber) {
    _houseNumber = houseNumber;
    setKeyValue(2, houseNumber);
  }

  @override
  Address copyWith({String id, String street, int houseNumber}) {
    return _Address(
        id: id ?? this.id,
        street: street ?? this.street,
        houseNumber: houseNumber ?? this.houseNumber);
  }

  factory _Address.fromMap(Map<int, dynamic> fields) {
    return _Address(
        id: fields[0] as String,
        street: fields[1] as String,
        houseNumber: fields[2] as int);
  }

  @override
  Map<int, dynamic> toMap() {
    return {0: id, 1: street, 2: houseNumber};
  }

  @override
  void applyUpdates(Map<int, dynamic> fields) {
    if (fields.containsKey(1)) {
      _street = fields[1] as String;
    }
    if (fields.containsKey(2)) {
      _houseNumber = fields[2] as int;
    }
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
      'Address(id: $id, street: $street, houseNumber: $houseNumber)';
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

    return _Address.fromMap(fields);
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
