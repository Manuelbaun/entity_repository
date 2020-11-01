// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Address]
abstract class _$Address extends EntityBase<Address> {
  _$Address(String id) : super(id);
  String street;
  int houseNumber;
  Address copyWith({String id, String street, int houseNumber});
}

class _Address extends EntityBase<Address> implements Address {
  _Address({String id, String street, int houseNumber})
      : _street = street,
        _houseNumber = houseNumber,
        super(id);

  @override
  Address copyWith({String id, String street, int houseNumber}) {
    return _Address(
        id: id ?? this.id,
        street: street ?? this.street,
        houseNumber: houseNumber ?? this.houseNumber);
  }

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

  factory _Address.fromMap(Map<int, dynamic> fields) {
    return _Address(
        id: fields[0] as String,
        street: (fields[1] as String),
        houseNumber: (fields[2] as int));
  }

  factory _Address.fromJson(Map<String, dynamic> fields) {
    return _Address(
        id: fields['id'] as String,
        street: (fields['street'] as String),
        houseNumber: (fields['houseNumber'] as int));
  }

  @override
  Set<EntityBase> getAllRefObjects() {
    final obj = <EntityBase>{};

    return obj;
  }

  @override
  Map<int, dynamic> toMap() {
    final map = <int, dynamic>{};

    /// store the id as field 0
    map[0] = id;
    if (street != null) {
      map[1] = street;
    }
    if (houseNumber != null) {
      map[2] = houseNumber;
    }
    return map;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    /// store the id as field 0
    map['id'] = id;
    if (street != null) {
      map['street'] = street;
    }
    if (houseNumber != null) {
      map['houseNumber'] = houseNumber;
    }
    return map;
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
      'Address(id: $id, street: $street, houseNumber: $houseNumber)';
}

/// The serialize adapter of type [_Address]
class $AddressAdapter implements Serializer<_Address> {
  $AddressAdapter(this.repo);
  final RepositoryBase<Address> repo;
  @override
  final int typeId = 12;

  @override
  _Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Address.fromMap(fields)..repo = repo;
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
