import 'package:entity_repository/entity_repository.dart';

import 'models/address.dart';
import 'models/car.dart';
import 'models/person.dart';
import 'models/song.dart';
import 'models/tag.dart';

Future<void> daosInit() async {
  Hive
    ..init('./hive_test')
    ..registerAdapter<IndexImpl>(IndexAdapter())
    ..registerAdapter<Set>(SetAdapter())
    ..registerAdapter<Person>($PersonAdapter())
    ..registerAdapter<Address>($AddressAdapter())
    ..registerAdapter<Car>($CarAdapter())
    ..registerAdapter<Song>($SongAdapter())
    ..registerAdapter<Tag>($TagAdapter());

  /// First Register all daos and as hive adapters
  /// should it be done by Type?
  repositoryLocator
    ..registerDao<Person>($PersonRepo())
    ..registerDao<Address>($AddressRepo())
    ..registerDao<Car>($CarRepo())
    ..registerDao<Song>($SongRepo())
    ..registerDao<Tag>($TagRepo());

  // init all daos, will open the boxes
  await repositoryLocator.initAll();
}

Future<void> daoDispose() async {
  await repositoryLocator.disposeAll();

  /// TODO: indexbox dispose!
}
