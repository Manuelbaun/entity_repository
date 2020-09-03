# Entity Repository Library [Experimental]

This library is an experimental package and is based on Hive as the persistent layer. The main motivation to create this package were some feature I was missing, when using [Hive](https://github.com/hivedb/hive) ([HiveWebpage](https://docs.hivedb.dev/#/)):

1. Fields to other hive classes, basically referencing ([HiveList](https://docs.hivedb.dev/#/custom-objects/relationships?id=hivelists) does it, but only if it is in the same box)
2. Automatically generate Repositories to the HiveType (e.g. 'PersonRepository) for CRUD operation
3. Circular References (WIP)

```Dart
@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  List<Person> friends; /// <- Here, use HiveList, to solve the list problem

  @HiveField(3)
  Address address;  /// This will serialize the address and not a reference

  @HiveField(4)
  Person friend; /// <- Here, how would hive do that?

  @HiveField(5)
  Map<String, Person> someMap; /// what ever that is, it also would not work

  @HiveField(6)
  Set<Person> someSet; /// This also would not work out of the box -> convert to hive list first
}

@HiveType(typeId: 2)
class Address {
  @HiveField(0)
  String street;
  @HiveField(1)
  String country;

   // ...
}


void test(){
    final p1 = Person();
    final p2 = Person();

    // this is a problem, when call toString() or the adapter
    p1.friend = p2;
    p2.friend = p1;
}
```

I know some projects do a great job [flutter_data](https://pub.dev/packages/flutter_data). I also wanted to learn more about code generation, so, that's what it is.

### Disclaimer

This package is in a experimental stage and not stable and the API will most likely change. Code quality is another aspect of its own :).

### Requirement

this package requires the [entity_repository_generator](https://github.com/Manuelbaun/entity_repository/tree/master/entity_repository_generator) package.

## How does it work

The entity model is inspired by the freezed package and how freezed uses the abstract class with a constructor redirection.

1. Create an abstract class
2. Use the _default_ factory constructor and specify the constructor params with the 'Field' (basically the HiveField).
3. Choose the constructor redirecting name
4. Run the code generator.
5. Then register the Adapter and Repository to the **repositoryLocator** instance

```dart
@EntityModel(AdapterIds.person)
abstract class Person implements _$Person {
  factory Person({
    @Field(0) String id,
    @Field(1) String name,
    @Field(2) int age,
    @Field(3) Address address,
    @Field(4) List<Person> friends,
    @Field(5) Set<Person> friends5,
    @Field(6) Map<int, Address> a5sf,
    @Field(7) Map<Person, Address> p2a,
  }) = _Person;
}
```

The generator will generate:
1. Abstract class of that enity model
2. Mixin as a reference lookup, when other models are part of this enitiy model
3. The redirected class with all the field accessor
4. The model serializer, which is basically the HiveAdapter

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// class [Person] Interface  extends the DataModel<Person>
/// The DataModel provides the upsert, update, delete and watch api
abstract class _$Person extends DataModel<Person> {
  _$Person(String id) : super(id);
  String name;
  int age;
  Address address;
  List<Person> friends;
  Set<Person> friends5;
  Map<int, Address> a5sf;
  Map<Person, Address> p2a;
}

/// Only the Id of an other entity model will be stored and not the serialized
/// entity it self. The mixin will perform a lookup by the id (aka reference) only
/// when the field is accessed.
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

/// This is the actual class implementation with the lookup. The name is given by the
/// the redirected constructor, choosen before. It can be seen here, when class attribute
/// which referenes other entities is accessed, the lookup will be performed.
///
class _Person extends DataModel<Person>
    with _PersonReferenceLookUp
    implements Person {
  _Person({
    String id,
    Address address,
    List<Person> friends,
    Set<Person> friends5,
    Map<int, Address> a5sf,
    Map<Person, Address> p2a,
    this.name,
    this.age,
  })  : _address = address,
        _friends = friends,
        _friends5 = friends5,
        _a5sf = a5sf,
        _p2a = p2a,
        super(id);

  @override
  String name;
  @override
  int age;

  /// If _address is null, the lookUpAddress() method gets called and the result is stored
  /// in the _address property.
  Address _address;

  @override
  Address get address => _address ??= _lookUpAddress();

  @override
  set address(Address address) => _address = address;


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


  /// Importent: The toString() method will only call the id on another entity
  /// instead of calling the toString method of that entity. Otherwise it could
  /// result in a circual toString calling loop, when two entities references each other
  @override
  String toString() =>
      '''Person(id: $id, name: $name, age: $age, address: ${address?.id}, friends: ${friends.map((e) => e.id)}), friends5: ${friends5.map((e) => e.id)}), a5sf: ${a5sf.map((key, value) => MapEntry(key, value.id))}, p2a: ${p2a.map((key, value) => MapEntry(key.id, value.id))})''';
}

/// The serialize adapter of type [_Person]
class $PersonAdapter implements Serializer<_Person> {
  @override
  final int typeId = 11;

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
```

## Repository

The entity package comes with a repository class. This is the process to register an entity in order to use it. Both, `RepositoryBase` and `RepositoryHive<Person>` are provided with this package:

1. Create an Interface, in order to be able to inject it somewhere.
2. Create a class which implements the Repositoy 
3. Register it to the `repositoryLocater` instance

The interface/abstract class
```dart
/// This will reside somewhere, where the domain code is
abstract class IPersonRepository implements RepositoryBase<Person> {}
```
This implements the Repository:
```dart
/// The [$PersonRepo] class of type [Person] will resided somewhere in the Infrastructure code
class PersonRepo extends RepositoryHive<Person> implements IPersonRepository {}
```

At first, the class `PersonRepo` was also generated in the `*.g.dart` and if the repo should be used, someone would import the entity model and automatically the repository would also be available. But this seemed to be a little spagetti code like in the context of DDD. (The goal is it, to also generate this somewhere and it is *WIP*) 

<!-- To use the Repositories, the following approach is currently recommened and it is easier to use with the injectable package and a DDD design. At a later stage, this might also be generated in a file. -->



#### Register Repository
The `repositoryLocator` is an instance of the class `_RepositoryLocator` and used to register the serilizer adapter and the repositories. It will use the model like `Person` and it assoiated `PersonRepository` and `$PersonAdapter`.

```dart
class Database {
  /// Initialize all serialisation adapters
  /// then then the enities
  static Future<void> initialize() async {
    final path = Platform.isWindows
        ? './hive_db'
        : (await getApplicationDocumentsDirectory()).path;

    repositoryLocator
      ..configure(path: path)
      /// example adatpers
      ..registerAdapter<Color>(ColorAdapter())
      ..registerAdapter<Duration>(DurationAdapter())
      ..registerAdapter<TextStyle>(TextStyleAdapter())

      /// Register Entities: Sequence is importent
      ..registerEntity<Person>(PersonRepository(), $PersonAdapter());


    // init all daos, will open the boxes
    await repositoryLocator.initAll();
  }

  /// DANGER: will delete all entries in all repositories
  static Future<void> clearAllRepos() async {
    repositoryLocator.values.forEach((element) async {
      await element.clearRepository();
    });
  }

  /// Will close all `boxes`
  static Future<void> dispose() async {
    await repositoryLocator.disposeAll();
  }
}
```

use the repository locator:
```dart

void main(){
  final repo = repositoryLocator.get<Person>() as IPersonRepository;

  /// perform some cruds..
}
```

### Injectable example
If your project uses the getIt package with the injectable package, then you could use the `module` annotation. The injectable package would then register all repositories to the `getIt` instance.


```dart
@module
abstract class RepositoryModule {
  /// another repository

  @singleton
  IPersonRepository get personRepository =>
      repositoryLocator.get<Person>() as IPersonRepository;

  /// another repository
  /// ...
}
```

## indices [wip]
It is possible to specify index fields, which then will check, whether an entity with the same `model` and `owner` is already present in the index or not.

```dart
@EntityModel(
  AdapterIds.car,
  index: [
    {'model', 'owner'}
  ],
)
abstract class Car extends _$Car {
  factory Car({
    @Field(0) String id,
    @Field(1) String model,
    @Field(2) String type,
    @Field(3) int buildYear,
    @Field(4) Person owner,
  }) = _Car;
}
```
