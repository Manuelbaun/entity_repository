import 'package:entity_repository/entity_repository.dart';

import 'models/address.dart';
import 'models/car.dart';
import 'models/person.dart';
import 'models/song.dart';
import 'models/tag.dart';

Future<void> initRepository() async {
  /// First Register all daos and as hive adapters
  /// should it be done by Type?
  repositoryLocator
    ..configure(path: './hive_test')
    ..registerAdapter<Tag>($TagAdapter())
    ..registerEntity<Person>($PersonRepo(), $PersonAdapter())
    ..registerEntity<Address>($AddressRepo(), $AddressAdapter())
    ..registerEntity<Car>($CarRepo(), $CarAdapter())
    ..registerEntity<Song>($SongRepo(), $SongAdapter());

  // init all daos, will open the boxes
  await repositoryLocator.initAll();
}

Future<void> daoDispose() async {
  await repositoryLocator.disposeAll();
}
