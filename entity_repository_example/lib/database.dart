import 'package:entity_repository/entity_repository.dart';

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
    implements IAddressRepository {}

class PersonRepository extends RepositoryHive<Person>
    implements IPersonRepository {}

class CarRepository extends RepositoryHive<Car> implements ICarRepository {}

class SongRepository extends RepositoryHive<Song> implements ISongRepository {}

class TagRepository extends RepositoryHive<Tag> implements ITagRepository {}

///
/// The database
///
class Database {
  Future<void> initRepository() async {
    Address.repo = AddressRepository();
    Person.repo = PersonRepository();
    Car.repo = CarRepository();
    Song.repo = SongRepository();
    Tag.repo = TagRepository();

    /// First Register all repositories and as adapters
    EntitiyRepositoryConfig.repositoryLocator
      ..configure(path: './hive_db')
      ..registerEntity<Address>(Address.repo, $AddressAdapter())
      ..registerEntity<Person>(Person.repo, $PersonAdapter())
      ..registerEntity<Car>(Car.repo, $CarAdapter())
      ..registerEntity<Song>(Song.repo, $SongAdapter())
      ..registerEntity<Tag>(Tag.repo, $TagAdapter());

    EntitiyRepositoryConfig.repositoryLocator
      ..registerFromMapFactory<Address>(Address.fromMap)
      ..registerFromMapFactory<Person>(Person.fromMap)
      ..registerFromMapFactory<Car>(Car.fromMap)
      ..registerFromMapFactory<Song>(Song.fromMap)
      ..registerFromMapFactory<Tag>(Tag.fromMap);

    // init all daos, will open the boxes
    await EntitiyRepositoryConfig.repositoryLocator.initAll();
  }

  IAddressRepository get addressRepository =>
      EntitiyRepositoryConfig.repositoryLocator.get<Address>()
          as IAddressRepository;

  IPersonRepository get personRepository =>
      EntitiyRepositoryConfig.repositoryLocator.get<Person>()
          as IPersonRepository;

  ICarRepository get carRepository =>
      EntitiyRepositoryConfig.repositoryLocator.get<Car>() as ICarRepository;

  ITagRepository get tagRepository =>
      EntitiyRepositoryConfig.repositoryLocator.get<Tag>() as ITagRepository;

  ISongRepository get songRepository =>
      EntitiyRepositoryConfig.repositoryLocator.get<Song>() as ISongRepository;

  Future<void> dispose() async {
    await EntitiyRepositoryConfig.repositoryLocator.disposeAll();
  }
}
