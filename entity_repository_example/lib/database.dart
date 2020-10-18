import 'package:entity_repository/entity_repository.dart';
import 'package:hive/hive.dart';

import 'models/address.dart';
import 'models/car.dart';
import 'models/person.dart';
import 'models/song.dart';
import 'models/tag.dart';

///
/// the interfaces
///
abstract class IAddressRepository implements RepositoryBase<Address> {}

abstract class ICarRepository implements RepositoryBase<Car> {}

abstract class IPersonRepository implements RepositoryBase<Person> {}

abstract class ISongRepository implements RepositoryBase<Song> {}

abstract class ITagRepository implements RepositoryBase<Tag> {}

///
/// The implementation
///
class AddressRepository extends RepositoryHive<Address>
    implements IAddressRepository {
  AddressRepository(
      HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac);
}

class PersonRepository extends RepositoryHive<Person>
    implements IPersonRepository {
  PersonRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac);
}

class CarRepository extends RepositoryHive<Car> implements ICarRepository {
  CarRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac);
}

class SongRepository extends RepositoryHive<Song> implements ISongRepository {
  SongRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac);
}

class TagRepository extends RepositoryHive<Tag> implements ITagRepository {
  TagRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac);
}

///
/// The database
///
class Database extends EntityConfiguration {
  Database([String path = './hive_db']) : super(path);

  Future<void> initRepository() async {
    /// Register the Hive Adapters
    localHive
      ..registerAdapter($AddressAdapter())
      ..registerAdapter($PersonAdapter())
      ..registerAdapter($CarAdapter())
      ..registerAdapter($SongAdapter())
      ..registerAdapter($TagAdapter());

    /// Register all repositories
    Address.repo =
        _addressRepository = AddressRepository(localHive, Address.fromMap);

    Person.repo =
        _personRepository = PersonRepository(localHive, Person.fromMap);
    Car.repo = _carRepository = CarRepository(localHive, Car.fromMap);
    Song.repo = _songRepository = SongRepository(localHive, Song.fromMap);
    Tag.repo = _tagRepository = TagRepository(localHive, Tag.fromMap);

    repositoryLocator
      ..register<Address>(Address.repo)
      ..register<Person>(Person.repo)
      ..register<Car>(Car.repo)
      ..register<Song>(Song.repo)
      ..register<Tag>(Tag.repo);

    // init all repos
    await repositoryLocator.initAll(
      shoudSaveSubEntities: true,
      chainTracker: chainTracker,
      synchronizer: synchronizer,
    );
  }

  IAddressRepository _addressRepository;
  IAddressRepository get addressRepository => _addressRepository;

  IPersonRepository _personRepository;
  IPersonRepository get personRepository => _personRepository;

  ICarRepository _carRepository;
  ICarRepository get carRepository => _carRepository;

  ITagRepository _tagRepository;
  ITagRepository get tagRepository => _tagRepository;

  ISongRepository _songRepository;
  ISongRepository get songRepository => _songRepository;

  Future<void> dispose() async {
    await repositoryLocator.disposeAll();
  }
}
