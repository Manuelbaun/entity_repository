// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Person]
abstract class _$Person extends DataModel<Person> {
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

mixin _PersonReferenceLookUp {
  String addressRefs;
  List<String> friendsRefs;
  Set<String> friends5Refs;
  Map<int, String> a5sfRefs;
  Map<String, String> p2aRefs;
  Address _lookUpAddress() {
    return ReferenceLookUp.findOne<Address>(addressRefs);
  }

  List<Person> _lookUpFriends() {
    if (friendsRefs != null) {
      return ReferenceLookUp.findMany<Person>(friendsRefs).toList();
    }
    return [];
  }

  Set<Person> _lookUpFriends5() {
    if (friends5Refs != null) {
      return ReferenceLookUp.findMany<Person>(friends5Refs).toSet();
    }
    return {};
  }

  Map<int, Address> _lookUpA5sf() {
    if (a5sfRefs != null) {
      final map = <int, Address>{};
      for (final entry in a5sfRefs.entries) {
        final v1 = entry.key;
        final v2 = ReferenceLookUp.findOne<Address>(entry.value);

        map[v1] = v2;
      }

      return map;
    }
    return {};
  }

  Map<Person, Address> _lookUpP2a() {
    if (p2aRefs != null) {
      final map = <Person, Address>{};
      for (final entry in p2aRefs.entries) {
        final v1 = ReferenceLookUp.findOne<Person>(entry.key);
        final v2 = ReferenceLookUp.findOne<Address>(entry.value);

        map[v1] = v2;
      }

      return map;
    }
    return {};
  }
}

class _Person extends DataModel<Person>
    with _PersonReferenceLookUp
    implements Person {
  _Person(
      {String id,
      Address address,
      List<Person> friends,
      Set<Person> friends5,
      Map<int, Address> a5sf,
      Map<Person, Address> p2a,
      this.name,
      this.age})
      : _address = address,
        _friends = friends,
        _friends5 = friends5,
        _a5sf = a5sf,
        _p2a = p2a,
        super(id);

  @override
  String name;
  @override
  int age;

  @override
  Address get address => _address ??= _lookUpAddress();

  @override
  set address(Address address) => _address = address;

  Address _address;

  @override
  List<Person> get friends => _friends ??= _lookUpFriends();

  @override
  set friends(List<Person> friends) => _friends = friends;

  List<Person> _friends;

  @override
  Set<Person> get friends5 => _friends5 ??= _lookUpFriends5();

  @override
  set friends5(Set<Person> friends5) => _friends5 = friends5;

  Set<Person> _friends5;

  @override
  Map<int, Address> get a5sf => _a5sf ??= _lookUpA5sf();

  @override
  set a5sf(Map<int, Address> a5sf) => _a5sf = a5sf;

  Map<int, Address> _a5sf;

  @override
  Map<Person, Address> get p2a => _p2a ??= _lookUpP2a();

  @override
  set p2a(Map<Person, Address> p2a) => _p2a = p2a;

  Map<Person, Address> _p2a;
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

  @override
  String toString() =>
      '''Person(id: $id, name: $name, age: $age, address: ${address?.id}, friends: ${friends.map((e) => e.id)}), friends5: ${friends5.map((e) => e.id)}), a5sf: ${a5sf.map((key, value) => MapEntry(key, value.id))}, p2a: ${p2a.map((key, value) => MapEntry(key.id, value.id))})''';
}

/// The serialize adapter of type [_Person]
class $PersonAdapter implements Serializer<_Person> {
  @override
  final int typeId = 10;

  @override
  _Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Person(id: fields[0] as String)
      ..name = fields[1] as String
      ..age = fields[2] as int
      ..addressRefs = (fields[3] as String)
      ..friendsRefs = (fields[4] as List)?.cast<String>()
      ..friends5Refs = (fields[5] as Set)?.cast<String>()
      ..a5sfRefs = (fields[6] as Map)?.cast<int, String>()
      ..p2aRefs = (fields[7] as Map)?.cast<String, String>();
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
      ..write(obj.address?.id)
      ..writeByte(4)
      ..write(obj.friends?.map((e) => e.id)?.toList())
      ..writeByte(5)
      ..write(obj.friends5?.map((e) => e.id)?.toSet())
      ..writeByte(6)
      ..write(obj.a5sf?.map((key, value) => MapEntry(key, value.id)))
      ..writeByte(7)
      ..write(obj.p2a?.map((key, value) => MapEntry(key.id, value.id)));
  }
}

/// The [$PersonRepo] class of type [Person]
class $PersonRepo extends RepositoryHive<Person> {}
