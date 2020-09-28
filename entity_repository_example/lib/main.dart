import 'package:entity_repository/entity_repository.dart';

import 'database.dart';
import 'models/address.dart';

import 'models/car.dart';
import 'models/person.dart';
import 'models/song.dart';
import 'models/tag.dart';

Future<void> main() async {
  final list = <Atom>[];

  Synchronizer.onAtomUpdate = list.add;

  final db = Database();
  await db.initRepository();

  final f0 = Person(name: 'Friend 0', age: 30);
  final f1 = Person(name: 'Friend 1', age: 30);
  final f2 = Person(name: 'Friend 2', age: 30);

  final person1 = Person(
      name: 'Hans',
      age: 30,
      address: Address()
        ..street = 'Icker'
        ..houseNumber = 2,
      friends: [f0, f1, f2]);

  // what happends next?
  f0.friends = [person1];

  final person2 = Person(
    name: 'Hans2',
    age: 32,
    address: Address()
      ..street = 'Icker'
      ..houseNumber = 2,
  );

  await db.personRepository.insert(f0);
  await db.personRepository.insert(person1);
  await db.personRepository.insert(person2);

  person1.age = 9999;
  await person1.update();
  await person2.update();

  await person1.update();

  // model is null!!
  final cars = [
    Car(id: '1', owner: person1, buildYear: 2020, type: 'BMW', model: 'Van'),
    Car(id: '2', owner: person1, buildYear: 2019, type: 'AUDI', model: 'LIMO'),
    Car(
        id: '3',
        owner: person2,
        buildYear: 2017,
        type: 'MERCEDES',
        model: 'LIMO'),
    Car(id: '4', owner: person2, buildYear: 2012, type: 'VW', model: 'GOLF'),
    Car(id: '5', owner: person2, buildYear: 2013, type: 'MAN', model: 'LKW'),
  ];

  await db.carRepository.insertMany(cars, override: true);

  for (final car in cars) {
    await car.update();
  }

  person1.name = 'Peter';

  final res = db.personRepository.findOne(person1.id);

  final song = Song(
    authors: [person1, person1],
    bpm: 120,
    capo: 0,
    ccli: '1234',
    copyright: 'Hello Fresh',
    lyrics: 'My first lyrics',
    notes: 'Some notes',
    songKey: 'A',
    tags: [Tag(id: 'love'), Tag(id: 'peace'), Tag(id: 'joy')],
    title: 'My First Song 2',
    translator: [person2],
    transpose: 0,
  );

  await db.songRepository.insert(song);
  await song.update();

  for (final a in list) {
    await Synchronizer.receivedRemoteAtom(a);
  }

  await db.dispose();
}
