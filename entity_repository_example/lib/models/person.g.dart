// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Person]
abstract class _$Person extends EntityBase<Person> {
  _$Person(String id) : super(id);
  String name;
  int age;
  Address address;
  List<Person> friends;
  Set<Person> friends5;
  Map<int, Address> a5sf;
  Map<Person, Address> p2a;
  Person copyWith(
      {String id,
      String name,
      int age,
      Address address,
      List<Person> friends,
      Set<Person> friends5,
      Map<int, Address> a5sf,
      Map<Person, Address> p2a});
}

class _Person extends EntityBase<Person> implements Person {
  _Person(
      {String id,
      String name,
      int age,
      Address address,
      List<Person> friends,
      Set<Person> friends5,
      Map<int, Address> a5sf,
      Map<Person, Address> p2a})
      : _name = name,
        _age = age,
        _address = address,
        _friends = friends,
        _friends5 = friends5,
        _a5sf = a5sf,
        _p2a = p2a,
        super(id);

  @override
  Person copyWith(
      {String id,
      String name,
      int age,
      Address address,
      List<Person> friends,
      Set<Person> friends5,
      Map<int, Address> a5sf,
      Map<Person, Address> p2a}) {
    return _Person(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        address: address ?? this.address,
        friends: friends ?? this.friends,
        friends5: friends5 ?? this.friends5,
        a5sf: a5sf ?? this.a5sf,
        p2a: p2a ?? this.p2a);
  }

  String _name;

  @override
  String get name => _name;

  @override
  set name(String name) {
    _name = name;
    setKeyValue(1, name);
  }

  int _age;

  @override
  int get age => _age;

  @override
  set age(int age) {
    _age = age;
    setKeyValue(2, age);
  }

  Address _address;

  @override
  Address get address => _address ??= _lookUpAddress();

  @override
  set address(Address address) {
    _address = address;
    _addressRefs = address?.id;
    setKeyValue(3, _addressRefs);
  }

  List<Person> _friends;

  @override
  List<Person> get friends => _friends ??= _lookUpFriends();

  @override
  set friends(List<Person> friends) {
    _friends = friends;
    _friendsRefs = friends?.map((e) => e.id)?.toList();
    setKeyValue(4, _friendsRefs);
  }

  Set<Person> _friends5;

  @override
  Set<Person> get friends5 => _friends5 ??= _lookUpFriends5();

  @override
  set friends5(Set<Person> friends5) {
    _friends5 = friends5;
    _friends5Refs = friends5?.map((e) => e.id)?.toSet();
    setKeyValue(5, _friends5Refs);
  }

  Map<int, Address> _a5sf;

  @override
  Map<int, Address> get a5sf => _a5sf ??= _lookUpA5sf();

  @override
  set a5sf(Map<int, Address> a5sf) {
    _a5sf = a5sf;
    _a5sfRefs = a5sf?.map((key, value) => MapEntry(key, value.id));
    setKeyValue(6, _a5sfRefs);
  }

  Map<Person, Address> _p2a;

  @override
  Map<Person, Address> get p2a => _p2a ??= _lookUpP2a();

  @override
  set p2a(Map<Person, Address> p2a) {
    _p2a = p2a;
    _p2aRefs = p2a?.map((key, value) => MapEntry(key.id, value.id));
    setKeyValue(7, _p2aRefs);
  }

  factory _Person.fromMap(Map<int, dynamic> fields) {
    return _Person(
        id: fields[0] as String,
        name: (fields[1] as String),
        age: (fields[2] as int))
      .._addressRefs = (fields[3] as String)
      .._friendsRefs = (fields[4] as List)?.cast<String>()
      .._friends5Refs = (fields[5] as List)?.cast<String>()?.toSet()
      .._a5sfRefs = (fields[6] as Map)?.cast<int, String>()
      .._p2aRefs = (fields[7] as Map)?.cast<String, String>();
  }

  factory _Person.fromJson(Map<String, dynamic> fields) {
    return _Person(
        id: fields['id'] as String,
        name: (fields['name'] as String),
        age: (fields['age'] as int))
      .._addressRefs = (fields['address'] as String)
      .._friendsRefs = (fields['friends'] as List)?.cast<String>()
      .._friends5Refs = (fields['friends5'] as List)?.cast<String>()?.toSet()
      .._a5sfRefs = (fields['a5sf'] as Map)?.cast<int, String>()
      .._p2aRefs = (fields['p2a'] as Map)?.cast<String, String>();
  }

  @override
  Set<EntityBase> getAllRefObjects() {
    final obj = <EntityBase>{};

    if (address != null) obj.add(address);
    if (friends != null && friends.isNotEmpty) {
      obj.addAll(friends);
    }
    if (friends5 != null && friends5.isNotEmpty) {
      obj.addAll(friends5);
    }
    if (a5sf != null && a5sf.isNotEmpty) {
      obj.addAll(a5sf.values);
    }
    if (p2a != null && p2a.isNotEmpty) {
      obj..addAll(p2a.keys)..addAll(p2a.values);
    }
    return obj;
  }

  @override
  Map<int, dynamic> toMap() {
    final map = <int, dynamic>{};

    /// store the id as field 0
    map[0] = id;
    if (name != null) {
      map[1] = name;
    }
    if (age != null) {
      map[2] = age;
    }
    if (addressRefs != null) {
      map[3] = addressRefs;
    }
    if (friendsRefs != null && friendsRefs.isNotEmpty) {
      map[4] = friendsRefs;
    }
    if (friends5Refs != null && friends5Refs.isNotEmpty) {
      map[5] = friends5Refs;
    }
    if (a5sfRefs != null && a5sfRefs.isNotEmpty) {
      map[6] = a5sfRefs;
    }
    if (p2aRefs != null && p2aRefs.isNotEmpty) {
      map[7] = p2aRefs;
    }
    return map;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    /// store the id as field 0
    map['id'] = id;
    if (name != null) {
      map['name'] = name;
    }
    if (age != null) {
      map['age'] = age;
    }
    if (addressRefs != null) {
      map['address'] = addressRefs;
    }
    if (friendsRefs != null && friendsRefs.isNotEmpty) {
      map['friends'] = friendsRefs;
    }
    if (friends5Refs != null && friends5Refs.isNotEmpty) {
      map['friends5'] = friends5Refs;
    }
    if (a5sfRefs != null && a5sfRefs.isNotEmpty) {
      map['a5sf'] = a5sfRefs;
    }
    if (p2aRefs != null && p2aRefs.isNotEmpty) {
      map['p2a'] = p2aRefs;
    }
    return map;
  }

  @override
  void applyUpdates(Map<int, dynamic> fields) {
    if (fields.containsKey(1)) {
      _name = fields[1] as String;
    }
    if (fields.containsKey(2)) {
      _age = fields[2] as int;
    }
    if (fields.containsKey(3)) {
      _addressRefs = fields[3] as String;
    }
    if (fields.containsKey(4)) {
      _friendsRefs = (fields[4] as List)?.cast<String>();
    }
    if (fields.containsKey(5)) {
      _friends5Refs = (fields[5] as List)?.toSet()?.cast<String>();
    }
    if (fields.containsKey(6)) {
      _a5sfRefs = (fields[6] as Map)?.cast<int, String>();
    }
    if (fields.containsKey(7)) {
      _p2aRefs = (fields[7] as Map)?.cast<String, String>();
    }
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is _Person &&
        o.id == id &&
        o.name == name &&
        o.age == age &&
        o.addressRefs == addressRefs &&
        listEquality(o.friendsRefs, friendsRefs) &&
        setEquality(o.friends5Refs, friends5Refs) &&
        mapEquality(o.a5sfRefs, a5sfRefs) &&
        mapEquality(o.p2aRefs, p2aRefs);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        age.hashCode ^
        address.hashCode ^
        friends.hashCode ^
        friends5.hashCode ^
        a5sf.hashCode ^
        p2a.hashCode;
  }

  @override
  String toString() =>
      'Person(id: $id, name: $name, age: $age, address: ${addressRefs}, friends: ${friendsRefs}, friends5: ${friends5Refs}, a5sf: ${a5sfRefs}, p2a: ${p2aRefs})';

  ///
  /// Generate the reference look up
  ///
  String _addressRefs;

  List<String> _friendsRefs;

  Set<String> _friends5Refs;

  Map<int, String> _a5sfRefs;

  Map<String, String> _p2aRefs;
  String get addressRefs => _addressRefs ??= address?.id;

  List<String> get friendsRefs =>
      _friendsRefs ??= friends?.map((e) => e.id)?.toList();

  Set<String> get friends5Refs =>
      _friends5Refs ??= friends5?.map((e) => e.id)?.toSet();

  Map<int, String> get a5sfRefs =>
      _a5sfRefs ??= a5sf?.map((key, value) => MapEntry(key, value.id));

  Map<String, String> get p2aRefs =>
      _p2aRefs ??= p2a?.map((key, value) => MapEntry(key.id, value.id));
  Address _lookUpAddress() {
    return locator.get<Address>().findOne(_addressRefs);
  }

  List<Person> _lookUpFriends() {
    if (_friendsRefs != null) {
      return locator.get<Person>().findMany(_friendsRefs).toList();
    }
    return [];
  }

  Set<Person> _lookUpFriends5() {
    if (_friends5Refs != null) {
      return locator.get<Person>().findMany(_friends5Refs).toSet();
    }
    return {};
  }

  Map<int, Address> _lookUpA5sf() {
    if (_a5sfRefs != null) {
      final map = <int, Address>{};
      for (final entry in _a5sfRefs.entries) {
        final key = entry.key;
        final value = locator.get<Address>().findOne(entry.value);
        map[key] = value;
      }

      return map;
    }
    return {};
  }

  Map<Person, Address> _lookUpP2a() {
    if (_p2aRefs != null) {
      final map = <Person, Address>{};
      for (final entry in _p2aRefs.entries) {
        final key = locator.get<Person>().findOne(entry.key);
        final value = locator.get<Address>().findOne(entry.value);
        map[key] = value;
      }

      return map;
    }
    return {};
  }
}

/// The serialize adapter of type [_Person]
class $PersonAdapter implements Serializer<_Person> {
  $PersonAdapter(this.repo);
  final RepositoryBase<Person> repo;
  @override
  final int typeId = 10;

  @override
  _Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Person.fromMap(fields)..repo = repo;
  }

  @override
  void write(BinaryWriter writer, _Person obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.addressRefs)
      ..writeByte(4)
      ..write(obj.friendsRefs)
      ..writeByte(5)
      ..write(obj.friends5Refs?.toList())
      ..writeByte(6)
      ..write(obj.a5sfRefs)
      ..writeByte(7)
      ..write(obj.p2aRefs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
