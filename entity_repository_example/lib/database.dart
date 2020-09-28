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
    /// First Register all repositories and as adapters
    repositoryLocator
      ..configure(path: './hive_db')
      ..registerEntity<Address>(AddressRepository(), $AddressAdapter())
      ..registerEntity<Person>(PersonRepository(), $PersonAdapter())
      ..registerEntity<Car>(CarRepository(), $CarAdapter())
      ..registerEntity<Song>(SongRepository(), $SongAdapter())
      ..registerEntity<Tag>(TagRepository(), $TagAdapter());

    // init all daos, will open the boxes
    await repositoryLocator.initAll();

    repositoryLocator
      ..registerMapFactory<Address>(Address.fromMap)
      ..registerMapFactory<Person>(Person.fromMap)
      ..registerMapFactory<Car>(Car.fromMap)
      ..registerMapFactory<Song>(Song.fromMap)
      ..registerMapFactory<Tag>(Tag.fromMap);

    print(repositoryLocator.factories);
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
