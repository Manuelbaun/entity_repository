import 'package:entity_repository/entity_repository.dart';
import 'package:entity_repository_example/models/adapterIds.dart';
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
      : super(hiveInstance, fac, AdapterIds.address);
}

class PersonRepository extends RepositoryHive<Person>
    implements IPersonRepository {
  PersonRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac, AdapterIds.address);
}

class CarRepository extends RepositoryHive<Car> implements ICarRepository {
  CarRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac, AdapterIds.address);
}

class SongRepository extends RepositoryHive<Song> implements ISongRepository {
  SongRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac, AdapterIds.address);
}

class TagRepository extends RepositoryHive<Tag> implements ITagRepository {
  TagRepository(HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac)
      : super(hiveInstance, fac, AdapterIds.address);
}

///
/// The database
///
class Database extends EntityConfiguration {
  Database([String path = './hive_db']) : super(path);

  Future<void> initRepository() async {
    /// Register all repositories
    _addressRepository = AddressRepository(localHive, Address.fromMap);
    _personRepository = PersonRepository(localHive, Person.fromMap);
    _carRepository = CarRepository(localHive, Car.fromMap);
    _songRepository = SongRepository(localHive, Song.fromMap);
    _tagRepository = TagRepository(localHive, Tag.fromMap);

    /// Register the Hive Adapters
    localHive
      ..registerAdapter($AddressAdapter(_addressRepository))
      ..registerAdapter($PersonAdapter(_personRepository))
      ..registerAdapter($CarAdapter(_carRepository))
      ..registerAdapter($SongAdapter(_songRepository))
      ..registerAdapter($TagAdapter(_tagRepository));

    repositoryLocator
      ..register<Address>(_addressRepository)
      ..register<Person>(_personRepository)
      ..register<Car>(_carRepository)
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

  IPersonRepository _personRepository;
  IPersonRepository get personRepository => _personRepository;

  ICarRepository _carRepository;
  ICarRepository get carRepository => _carRepository;

  ITagRepository _tagRepository;
  ITagRepository get tagRepository => _tagRepository;

  ISongRepository _songRepository;
  ISongRepository get songRepository => _songRepository;

  Future<void> close() async {
    await repositoryLocator.disposeAll();
  }
}
