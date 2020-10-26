import 'package:entity_repository/entity_repository.dart';
import 'package:entity_repository_example/models/address.dart';
import 'package:entity_repository_example/models/car.dart';
import 'package:entity_repository_example/models/person.dart';
import 'package:entity_repository_example/models/song.dart';
import 'package:entity_repository_example/models/tag.dart';

///
/// Create the interfaces of the repositories
///
abstract class IAddressRepository implements RepositoryBase<Address> {}

abstract class ICarRepository implements RepositoryBase<Car> {}

abstract class IPersonRepository implements RepositoryBase<Person> {}

abstract class ISongRepository implements RepositoryBase<Song> {}

abstract class ITagRepository implements RepositoryBase<Tag> {}

///
/// Create the concrete repository classes
///
class AddressRepository extends RepositoryHive<Address>
    implements IAddressRepository {
  AddressRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<EntityBase> fac,
  ) : super(hiveInstance, fac, 12);
}

class CarRepository extends RepositoryHive<Car> implements ICarRepository {
  CarRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<EntityBase> fac,
  ) : super(hiveInstance, fac, 11);
}

class PersonRepository extends RepositoryHive<Person>
    implements IPersonRepository {
  PersonRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<EntityBase> fac,
  ) : super(hiveInstance, fac, 10);
}

class SongRepository extends RepositoryHive<Song> implements ISongRepository {
  SongRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<EntityBase> fac,
  ) : super(hiveInstance, fac, 14);
}

class TagRepository extends RepositoryHive<Tag> implements ITagRepository {
  TagRepository(
    HiveInterface hiveInstance,
    EntityMapFactory<EntityBase> fac,
  ) : super(hiveInstance, fac, 13);
}

///
/// The database
///
class EntityDatabase extends EntityConfiguration {
  EntityDatabase([String path = './hive_db']) : super(path);

  Future<void> initRepository() async {
    _addressRepository = AddressRepository(localHive, Address.fromMap);
    _carRepository = CarRepository(localHive, Car.fromMap);
    _personRepository = PersonRepository(localHive, Person.fromMap);
    _songRepository = SongRepository(localHive, Song.fromMap);
    _tagRepository = TagRepository(localHive, Tag.fromMap);

    /// Register all repositories
    localHive
      ..registerAdapter($AddressAdapter(_addressRepository))
      ..registerAdapter($CarAdapter(_carRepository))
      ..registerAdapter($PersonAdapter(_personRepository))
      ..registerAdapter($SongAdapter(_songRepository))
      ..registerAdapter($TagAdapter(_tagRepository));

    repositoryLocator
      ..register<Address>(_addressRepository)
      ..register<Car>(_carRepository)
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

  IPersonRepository _personRepository;
  IPersonRepository get personRepository => _personRepository;

  ISongRepository _songRepository;
  ISongRepository get songRepository => _songRepository;

  ITagRepository _tagRepository;
  ITagRepository get tagRepository => _tagRepository;

  Address createAddress({String id, String street, int houseNumber}) =>
      new Address(id: id, street: street, houseNumber: houseNumber)
        ..repo = _addressRepository;

  Car createCar(
          {String id,
          String model,
          String type,
          int buildYear,
          Person owner}) =>
      new Car(
          id: id, model: model, type: type, buildYear: buildYear, owner: owner)
        ..repo = _carRepository;

  Person createPerson(
          {String id,
          String name,
          int age,
          Address address,
          List<Person> friends,
          Set<Person> friends5,
          Map<int, Address> a5sf,
          Map<Person, Address> p2a}) =>
      new Person(
          id: id,
          name: name,
          age: age,
          address: address,
          friends: friends,
          friends5: friends5,
          a5sf: a5sf,
          p2a: p2a)
        ..repo = _personRepository;

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
      new Song(
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

  Tag createTag({
    String id,
  }) =>
      new Tag(
        id: id,
      )..repo = _tagRepository;

  Future<void> close() async {
    await repositoryLocator.disposeAll();
  }
}