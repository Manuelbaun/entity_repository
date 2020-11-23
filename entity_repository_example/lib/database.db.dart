import 'package:entity_repository/entity_repository.dart';
import 'package:entity_repository_example/models/address.dart';
import 'package:entity_repository_example/models/car.dart';
import 'package:entity_repository_example/models/notes.dart';
import 'package:entity_repository_example/models/person.dart';
import 'package:entity_repository_example/models/song.dart';
import 'package:entity_repository_example/models/tag.dart';

///
/// Create the interfaces of the repositories
///
abstract class IAddressRepository implements RepositoryBase<Address> {
  Address create({String id, String street, int houseNumber});
}

abstract class ICarRepository implements RepositoryBase<Car> {
  Car create(
      {String id, String model, String type, int buildYear, Person owner});
}

abstract class INotesRepository implements RepositoryBase<Notes> {
  Notes create(
      {String id,
      String title,
      String content,
      DateTime created,
      DateTime edited,
      Person creator,
      Person lastEditor});
}

abstract class IPersonRepository implements RepositoryBase<Person> {
  Person create(
      {String id,
      String name,
      int age,
      Address address,
      List<Person> friends,
      Set<Person> friends5,
      Map<int, Address> a5sf,
      Map<Person, Address> p2a});
}

abstract class ISongRepository implements RepositoryBase<Song> {
  Song create(
      {String id,
      String title,
      int bpm,
      int transpose,
      String songKey,
      int capo,
      String lyrics,
      String notes,
      String ccli,
      List<Person> authors,
      List<int> authors2,
      String copyright,
      List<Person> translator,
      List<Tag> tags});
}

abstract class ITagRepository implements RepositoryBase<Tag> {
  Tag create({
    String id,
  });
}

///
/// Create the concrete repository classes
///
class AddressRepository extends RepositoryHive<Address>
    implements IAddressRepository {
  AddressRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<Address> fac,
  ) : super(hiveInstance, fac, 12);
  @override
  Address create({String id, String street, int houseNumber}) =>
      Address(id: id, street: street, houseNumber: houseNumber)..repo = this;
}

class CarRepository extends RepositoryHive<Car> implements ICarRepository {
  CarRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<Car> fac,
  ) : super(hiveInstance, fac, 11);
  @override
  Car create(
          {String id,
          String model,
          String type,
          int buildYear,
          Person owner}) =>
      Car(id: id, model: model, type: type, buildYear: buildYear, owner: owner)
        ..repo = this;
}

class NotesRepository extends RepositoryHive<Notes>
    implements INotesRepository {
  NotesRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<Notes> fac,
  ) : super(hiveInstance, fac, 15);
  @override
  Notes create(
          {String id,
          String title,
          String content,
          DateTime created,
          DateTime edited,
          Person creator,
          Person lastEditor}) =>
      Notes(
          id: id,
          title: title,
          content: content,
          created: created,
          edited: edited,
          creator: creator,
          lastEditor: lastEditor)
        ..repo = this;
}

class PersonRepository extends RepositoryHive<Person>
    implements IPersonRepository {
  PersonRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<Person> fac,
  ) : super(hiveInstance, fac, 10);
  @override
  Person create(
          {String id,
          String name,
          int age,
          Address address,
          List<Person> friends,
          Set<Person> friends5,
          Map<int, Address> a5sf,
          Map<Person, Address> p2a}) =>
      Person(
          id: id,
          name: name,
          age: age,
          address: address,
          friends: friends,
          friends5: friends5,
          a5sf: a5sf,
          p2a: p2a)
        ..repo = this;
}

class SongRepository extends RepositoryHive<Song> implements ISongRepository {
  SongRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<Song> fac,
  ) : super(hiveInstance, fac, 14);
  @override
  Song create(
          {String id,
          String title,
          int bpm,
          int transpose,
          String songKey,
          int capo,
          String lyrics,
          String notes,
          String ccli,
          List<Person> authors,
          List<int> authors2,
          String copyright,
          List<Person> translator,
          List<Tag> tags}) =>
      Song(
          id: id,
          title: title,
          bpm: bpm,
          transpose: transpose,
          songKey: songKey,
          capo: capo,
          lyrics: lyrics,
          notes: notes,
          ccli: ccli,
          authors: authors,
          authors2: authors2,
          copyright: copyright,
          translator: translator,
          tags: tags)
        ..repo = this;
}

class TagRepository extends RepositoryHive<Tag> implements ITagRepository {
  TagRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<Tag> fac,
  ) : super(hiveInstance, fac, 13);
  @override
  Tag create({
    String id,
  }) =>
      Tag(
        id: id,
      )..repo = this;
}

///
/// The database
///
class EntityDatabase extends EntityDatabaseClass {
  EntityDatabase([String path = './hive_db']) : super(path);

  Future<void> initRepository() async {
    _addressRepository = AddressRepository(localHive, Address.fromMap);
    _carRepository = CarRepository(localHive, Car.fromMap);
    _notesRepository = NotesRepository(localHive, Notes.fromMap);
    _personRepository = PersonRepository(localHive, Person.fromMap);
    _songRepository = SongRepository(localHive, Song.fromMap);
    _tagRepository = TagRepository(localHive, Tag.fromMap);

    /// Register all repositories
    localHive
      ..registerAdapter($AddressAdapter(_addressRepository))
      ..registerAdapter($CarAdapter(_carRepository))
      ..registerAdapter($NotesAdapter(_notesRepository))
      ..registerAdapter($PersonAdapter(_personRepository))
      ..registerAdapter($SongAdapter(_songRepository))
      ..registerAdapter($TagAdapter(_tagRepository));

    repositoryLocator
      ..register<Address>(_addressRepository)
      ..register<Car>(_carRepository)
      ..register<Notes>(_notesRepository)
      ..register<Person>(_personRepository)
      ..register<Song>(_songRepository)
      ..register<Tag>(_tagRepository);

// At the end, init all repos,
    await repositoryLocator.initAll(
      shoudSaveSubEntities: true,
      chainTracker: chainTracker,
      synchronizer: synchronizer,
    );
  }

  IAddressRepository _addressRepository;
  IAddressRepository get addressRepository => _addressRepository;

  ICarRepository _carRepository;
  ICarRepository get carRepository => _carRepository;

  INotesRepository _notesRepository;
  INotesRepository get notesRepository => _notesRepository;

  IPersonRepository _personRepository;
  IPersonRepository get personRepository => _personRepository;

  ISongRepository _songRepository;
  ISongRepository get songRepository => _songRepository;

  ITagRepository _tagRepository;
  ITagRepository get tagRepository => _tagRepository;

  ///
  /// These methods will be redirected, once the dart team fixes
  /// the auto completion for typedef function signigtures
  ///
  @override
  Address createAddress({String id, String street, int houseNumber}) =>
      Address(id: id, street: street, houseNumber: houseNumber)
        ..repo = _addressRepository;

  @override
  Car createCar(
          {String id,
          String model,
          String type,
          int buildYear,
          Person owner}) =>
      Car(id: id, model: model, type: type, buildYear: buildYear, owner: owner)
        ..repo = _carRepository;

  @override
  Notes createNotes(
          {String id,
          String title,
          String content,
          DateTime created,
          DateTime edited,
          Person creator,
          Person lastEditor}) =>
      Notes(
          id: id,
          title: title,
          content: content,
          created: created,
          edited: edited,
          creator: creator,
          lastEditor: lastEditor)
        ..repo = _notesRepository;

  @override
  Person createPerson(
          {String id,
          String name,
          int age,
          Address address,
          List<Person> friends,
          Set<Person> friends5,
          Map<int, Address> a5sf,
          Map<Person, Address> p2a}) =>
      Person(
          id: id,
          name: name,
          age: age,
          address: address,
          friends: friends,
          friends5: friends5,
          a5sf: a5sf,
          p2a: p2a)
        ..repo = _personRepository;

  @override
  Song createSong(
          {String id,
          String title,
          int bpm,
          int transpose,
          String songKey,
          int capo,
          String lyrics,
          String notes,
          String ccli,
          List<Person> authors,
          List<int> authors2,
          String copyright,
          List<Person> translator,
          List<Tag> tags}) =>
      Song(
          id: id,
          title: title,
          bpm: bpm,
          transpose: transpose,
          songKey: songKey,
          capo: capo,
          lyrics: lyrics,
          notes: notes,
          ccli: ccli,
          authors: authors,
          authors2: authors2,
          copyright: copyright,
          translator: translator,
          tags: tags)
        ..repo = _songRepository;

  @override
  Tag createTag({
    String id,
  }) =>
      Tag(
        id: id,
      )..repo = _tagRepository;

  Future<void> close() async {
    await repositoryLocator.disposeAll();
  }
}
