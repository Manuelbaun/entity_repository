library entity_repository;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:msgpack_dart/msgpack_dart.dart';

export 'package:hive/hive.dart' show BinaryReader, BinaryWriter;

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
part 'src/utils/encoding_msg_pack.dart';
part 'src/utils/equality.dart';
part 'src/utils/nesting_hashing.dart';
part 'src/utils/id_generator.dart';

// shortid.characters('0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$@');
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

final _valueEncoder = _ExtendetEncoder();
final _valueDecoder = _ExtendetDecoder();

/// encodes into bytes
Uint8List msgpackEncode(dynamic v) => serialize(v, extEncoder: _valueEncoder);

/// decodes bytes into object/types
T msgpackDecode<T>(Uint8List v) =>
    deserialize(v, extDecoder: _valueDecoder) as T;

abstract class EntitiyRepositoryConfig {
  static final _RepositoryLocator repositoryLocator = _RepositoryLocator();
// ..registerAdapter<IndexImpl>(IndexAdapter(CustomAdapterTypes.indexAdapter));

  static bool shouldSaveWithSubEntities = true;

  /// helper class to track the entites, which are already stored
  static ChainTracker chainTracker = ChainTracker();

  static Synchronizer synchronizer = Synchronizer();
}
