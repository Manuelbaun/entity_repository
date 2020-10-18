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
    final addressAdapter = $AddressAdapter();
    final personAdapter = $PersonAdapter();
    final carAdapter = $CarAdapter();
    final songAdapter = $SongAdapter();
    final tagAdapter = $TagAdapter();

    /// First Register all repositories and as adapters
    localHive
      ..registerAdapter(addressAdapter)
      ..registerAdapter(personAdapter)
      ..registerAdapter(carAdapter)
      ..registerAdapter(songAdapter)
      ..registerAdapter(tagAdapter);

    Address.repo = AddressRepository(localHive, Address.fromMap);
    Person.repo = PersonRepository(localHive, Person.fromMap);
    Car.repo = CarRepository(localHive, Car.fromMap);
    Song.repo = SongRepository(localHive, Song.fromMap);
    Tag.repo = TagRepository(localHive, Tag.fromMap);

    repositoryLocator
      ..register<Address>(Address.repo)
      ..register<Person>(Person.repo)
      ..register<Car>(Car.repo)
      ..register<Song>(Song.repo)
      ..register<Tag>(Tag.repo);

    await repositoryLocator.initAll(
      chainTracker: chainTracker,
      shoudSaveSubEntities: true,
      synchronizer: synchronizer,
    );
  }

  IAddressRepository get addressRepository =>
      repositoryLocator.get<Address>() as IAddressRepository;

  IPersonRepository get personRepository =>
      repositoryLocator.get<Person>() as IPersonRepository;

  ICarRepository get carRepository =>
      repositoryLocator.get<Car>() as ICarRepository;

  ITagRepository get tagRepository =>
      repositoryLocator.get<Tag>() as ITagRepository;

  ISongRepository get songRepository =>
      repositoryLocator.get<Song>() as ISongRepository;

  Future<void> dispose() async {
    await repositoryLocator.disposeAll();
  }
}
