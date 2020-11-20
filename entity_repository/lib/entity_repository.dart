library entity_repository;

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:hive/src/hive_impl.dart';

export 'package:hive/hive.dart' show BinaryReader, BinaryWriter, HiveInterface;

part 'src/model/entity_base.dart';

part 'src/core/repository_base.dart';
part 'src/core/repository_locator.dart';
part 'src/core/repository_hive.dart';
part 'src/core/errors.dart';
part 'src/core/index_base.dart';
part 'src/core/serializer.dart';

part 'src/adapters/index_adapter.dart';
part 'src/adapters/set_adapter.dart';

part 'src/annotation/entity_model.dart';
part 'src/annotation/field.dart';

part 'src/mixins/indices_access.dart';

part 'src/sync/atom.dart';
part 'src/sync/synchronizer.dart';
part 'src/sync/syncable.dart';

part 'src/utils/chain_tracker.dart';
part 'src/utils/data_helper.dart';
part 'src/utils/equality.dart';
part 'src/utils/nesting_hashing.dart';
part 'src/utils/id_generator.dart';

// ignore: avoid_classes_with_only_static_members
class CustomAdapterTypes {
  static const int setAdapter = 0;
  static const int indexAdapter = 1;

  static const map = <Type, int>{
    // SetAdapter: 0,
    IndexAdapter: 1,
  };

  static int get maxAdapter {
    var i = 0;

    for (final v in map.values) {
      if (i < v) i = v;
    }

    return i;
  }
}

/// ********
/// The Databse configure class
///
/// must be extended
///
abstract class EntityDatabaseClass {
  EntityDatabaseClass(this.path)
      : assert(path != null),
        assert(path.isNotEmpty) {
    localHive = HiveImpl()..init(path);
    repositoryLocator = RepositoryLocator();
    chainTracker = ChainTracker();
    synchronizer = Synchronizer(repositoryLocator);
  }

  final String path;
  bool shouldSaveWithSubEntities = true;

  RepositoryLocator repositoryLocator;

  ChainTracker chainTracker;

  Synchronizer synchronizer;

  HiveInterface localHive;
}
