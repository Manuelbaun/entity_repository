import 'package:entity_repository/entity_repository.dart';
import 'package:entity_repository_example/database.dart';
import 'package:entity_repository_example/models/address.dart';
import 'package:entity_repository_example/models/car.dart';
import 'package:entity_repository_example/models/person.dart';
import 'package:entity_repository_example/models/song.dart';
import 'package:entity_repository_example/models/tag.dart';

Future<void> main() async {
  final list = <Atom>[];

  /// Setup Sync
  Synchronizer.onAtomUpdate = (a) async {
    final bytes = msgpackEncode(a);
    final aa = msgpackDecode<Atom>(bytes);
    list.add(a);
    // print(a);
    // print(aa == a);
    // await Synchronizer.receivedRemoteAtom(aa);
  };

  final db = Database();
  await db.initRepository();
  final s = Stopwatch()..start();

  await addComplexNestedObject(db);
  // await storeCars(db);

  // db.addressRepository.findAll().forEach(print);
  // db.carRepository.findAll().forEach(print);
  // db.personRepository.findAll().forEach(print);
  // db.songRepository.findAll().forEach(print);
  // db.tagRepository.findAll().forEach(print);

  // await db.dispose();
  // return;

  s.stop();
  print('Open DB: ${s.elapsedMilliseconds} ms');
  await db.dispose();
}

Future<void> addComplexNestedObject(Database db) async {
  final f0 = Person(id: 'f0', name: 'Friend 0', age: 30);
  final f1 = Person(id: 'f1', name: 'Friend 1', age: 30);
  final f2 = Person(id: 'f2', name: 'Friend 2', age: 30);

  final p1 = Person(
    id: 'per1',
    name: 'Hans',
    age: 30,
    address: Address(id: 'add1', street: 'Icker', houseNumber: 2),
    friends: [f0, f1, f2],
  );

  final p3 = Person(
    id: 'per3',
    name: 'Hans',
    age: 30,
    address: Address(id: 'add1', street: 'Icker', houseNumber: 2),
  );

  // what happends next?
  f0.friends = [p1, p3];

  final p2 = Person(
    id: 'per2',
    name: 'Hans2',
    age: 32,
    address: Address(id: 'add2', street: 'Icker', houseNumber: 2),
  );

  /// change person stuff
  p1
    ..age = 50
    ..name = 'Peter';

  final song = Song(
    id: 'song1',
    authors: [p1, p1],
    authors2: [99, 99],
    bpm: 120,
    capo: 0,
    ccli: '1234',
    copyright: 'Hello Fresh',
    lyrics: 'My first lyrics',
    notes: 'Some notes',
    songKey: 'A',
    tags: [Tag(id: 'love'), Tag(id: 'peace'), Tag(id: 'joy')],
    title: 'My First Song 2',
    translator: [p2],
    transpose: 0,
  );

  await song.upsert();
}

Future<void> storeCars(Database db) async {
  // // model is null!!
  final cars = [
    Car(id: '1', buildYear: 2020, type: 'BMW', model: 'Van'),
    Car(id: '2', buildYear: 2019, type: 'AUDI', model: 'LIMO'),
    Car(id: '3', buildYear: 2017, type: 'MERCEDES', model: 'LIMO'),
    Car(id: '4', buildYear: 2012, type: 'VW', model: 'GOLF'),
    Car(id: '5', buildYear: 2013, type: 'MAN', model: 'LKW'),
  ];

  await db.carRepository.insertMany(cars, override: true);

  // for (final car in cars) {
  //   await car.update();
  // }
}
