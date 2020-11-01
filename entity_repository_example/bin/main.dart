import 'package:entity_repository/entity_repository.dart';
import 'package:entity_repository_example/database.db.dart';
import 'package:entity_repository_example/models/address.dart';
import 'package:entity_repository_example/models/car.dart';
import 'package:entity_repository_example/models/person.dart';
import 'package:entity_repository_example/models/song.dart';
import 'package:entity_repository_example/models/tag.dart';

void measure(Function func) async {
  final s = Stopwatch()..start();
  const run = 1000;
  for (int i = 0; i < run; i++) await func();

  s.stop();
  print('${s.elapsedTicks / run} ticks');
}

void printAll(EntityDatabaseClass db) {
  for (final repo in db.repositoryLocator.values) {
    repo.findAll().forEach(print);
  }
}

void clearDB(EntityDatabaseClass db) async {
  for (final repo in db.repositoryLocator.values) {
    await repo.clearRepository();
  }
}

void compare(EntityDatabase db, EntityDatabase db2) {
  for (final repo in db.repositoryLocator.values) {
    final allEntries = repo.findAll();
    final repo2 = db2.repositoryLocator.getRepoByTypeId(repo.typeId);
    final allEntries2 = repo2.findAll();

    if (allEntries.length != allEntries2.length) {
      print('xxx Lengths are different');
    }

    for (final entry in allEntries) {
      final ent = repo2.findOne(entry.id);

      if (entry != ent) {
        print('Not Equal : ${ent.runtimeType}');
        print(entry.toJson());
        print(ent.toJson());
      } else {
        print('Equal : ${ent.id} - ${entry.id}');
        if (ent.id == "song1") {
          print(entry.toMap());
          print(ent.toMap());
        }
      }
    }
  }
}

///
/// MAIN
///
Future<void> main() async {
  final db = EntityDatabase();

  final db2 = EntityDatabase('hive_db2');

  /// Setup Sync
  db.synchronizer.onAtomUpdate = (a) async {
    // final aJson = a.toJson();
    print(a);
    final bytes = msgpackEncode(a);
    final aa = msgpackDecode<Atom>(bytes);
    await db2.synchronizer.receivedRemoteAtom(aa);
  };

  await db.initRepository();
  await db2.initRepository();

  await clearDB(db);
  await clearDB(db2);

  final s = Stopwatch()..start();

  await addComplexNestedObject(db);

  s.stop();
  print('Open DB: ${s.elapsedMilliseconds} ms');

  print('---------------------------------');
  print('---------------------------------');
  compare(db, db2);

  await db.close();
  await db2.close();
}

Future<void> addComplexNestedObject(EntityDatabase db) async {
  final f0 = Person(
    id: 'f0',
    name: 'Friend 0',
    age: 30,
  )..repo = db.personRepository;

  final f1 = Person(
    id: 'f1',
    name: 'Friend 1',
    age: 30,
  )..repo = db.personRepository;

  final f2 = Person(
    id: 'f2',
    name: 'Friend 2',
    age: 30,
  )..repo = db.personRepository;

  final p1 = Person(
    id: 'per1',
    name: 'Hans',
    age: 30,
    address: Address(
      id: 'add1',
      street: 'Icker',
      houseNumber: 2,
    )..repo = db.addressRepository,
    friends: [f0, f1, f2],
  )..repo = db.personRepository;

  final p3 = Person(
    id: 'per3',
    name: 'Hans',
    age: 30,
    address: Address(
      id: 'add1',
      street: 'Icker',
      houseNumber: 2,
    )..repo = db.addressRepository,
  )..repo = db.personRepository;

  // what happends next?
  f0.friends = [p1, p3];

  final p2 = Person(
    id: 'per2',
    name: 'Hans2',
    age: 32,
    address: Address(
      id: 'add2',
      street: 'Icker',
      houseNumber: 2,
    )..repo = db.addressRepository,
  )..repo = db.personRepository;

  /// change person stuff
  p1
    ..age = 50
    ..name = 'Peter';

  db.createTag(id: "myNewTag").upsert();

  //
  db.createPerson(
    friends: [db.createPerson(name: 'Hans')],
    address: db.createAddress(
      street: "no thats not me",
      houseNumber: 5,
      id: 'ok',
    ),
  ).upsert();

  final song = Song(
    id: 'song1',
    authors: [p1, p1],
    authors2: [99, 88],
    bpm: 120,
    capo: 0,
    ccli: '1234',
    copyright: 'Hello Fresh',
    lyrics: 'My first lyrics',
    notes: 'Some notes',
    songKey: 'A',
    tags: [
      Tag(id: 'love')..repo = db.tagRepository,
      Tag(id: 'peace')..repo = db.tagRepository,
      Tag(id: 'joy')..repo = db.tagRepository,
    ],
    title: 'My First Song 2',
    translator: [p2],
    transpose: 0,
  )..repo = db.songRepository;
  await song.upsert();

  song.copyright = "Hello jajaksjdkajskdjfk ";
  await song.update();
}

Future<void> storeCars(EntityDatabase db) async {
  final cars = [
    Car(id: '1', buildYear: 2020, type: 'BMW', model: 'Van'),
    Car(id: '2', buildYear: 2019, type: 'AUDI', model: 'LIMO'),
    Car(id: '3', buildYear: 2017, type: 'MERCEDES', model: 'LIMO'),
    Car(id: '4', buildYear: 2012, type: 'VW', model: 'GOLF'),
    Car(id: '5', buildYear: 2013, type: 'MAN', model: 'LKW'),
  ];
  await db.carRepository.insertMany(cars, override: true);
}
