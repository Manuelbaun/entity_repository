library entity_repository;

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'src/utils/cuid.dart';

export 'package:hive/hive.dart' show BinaryReader, BinaryWriter;

part 'src/model/data_model.dart';

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
part 'src/mixins/reference_lookup.dart';

part 'src/utils/data_helper.dart';
part 'src/utils/equality.dart';

// ignore: avoid_classes_with_only_static_members
class CustomAdapterTypes {
  static const int setAdapter = 0;
  static const int indexAdapter = 1;

  static const map = <Type, int>{
    SetAdapter: 0,
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

/// dao locator instance singelton
final _RepositoryLocator repositoryLocator = _RepositoryLocator()
  ..registerAdapter<IndexImpl>(IndexAdapter(CustomAdapterTypes.indexAdapter))
  ..registerAdapter<Set>(SetAdapter(CustomAdapterTypes.setAdapter));
