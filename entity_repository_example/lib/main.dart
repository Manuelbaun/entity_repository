import 'entity.repos.dart';
import 'models/address.dart';

import 'models/car.dart';
import 'models/person.dart';
import 'models/song.dart';
import 'models/tag.dart';

void main() async {
  await daosInit();

  final dao = repositoryLocator.get<Person>();

  dao.findAll().forEach(print);

  final f0 = Person(name: 'Friend 0', age: 30);
  final f1 = Person(name: 'Friend 1', age: 30);
  final f2 = Person(name: 'Friend 2', age: 30);

  final p = Person(
      name: 'Hans',
      age: 30,
      address: Address()
        ..street = 'Icker'
        ..houseNumber = 2,
      friends: [f0, f1, f2]);

  // what happends next?
  f0.friends = [p];

  final p2 = Person(
    name: 'Hans',
    age: 30,
    address: Address()
      ..street = 'Icker'
      ..houseNumber = 2,
  );

  await dao.insert(f0);
  await dao.insert(p);
  await dao.insert(p2);

  await p.update();
  await p2.update();

  await p.update();

  dao.findAll().forEach(print);

  // model is null!!
  final cars = [
    Car(id: '1', owner: p, buildYear: 2020, type: 'BMW', model: 'Van'),
    Car(id: '2', owner: p, buildYear: 2019, type: 'AUDI', model: 'LIMO'),
    Car(id: '3', owner: p2, buildYear: 2017, type: 'MERCEDES', model: 'LIMO'),
    Car(id: '4', owner: p2, buildYear: 2012, type: 'VW', model: 'GOLF'),
    Car(id: '5', owner: p2, buildYear: 2013, type: 'MAN', model: 'LKW'),
  ];
  await repositoryLocator.get<Car>().insertMany(cars, override: true);

  for (final car in cars) {
    await car.update();
  }

  p.name = 'Peter';

  print(p.id);

  final res = dao.findOne(p.id);
  print(res);

  final song = Song(
    authors: [p, p],
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

  await repositoryLocator.get<Song>().insert(song);
  await song.update();

  repositoryLocator.get<Song>().findAll().forEach(print);
  repositoryLocator.get<Tag>().findAll().forEach(print);

  // await p.delete();
  print(dao.findAll().length);

  print(IndexesAccess.toStringy());

  // final resID = (repositoryLocator.get<Car>() as $CarRepo).findBy('Van', p);
  // print('Found ID $resID');

  await daoDispose();
}
