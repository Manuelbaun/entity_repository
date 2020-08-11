library entity_repository;

import 'dart:async';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'src/utils/cuid.dart';

export 'package:hive/hive.dart' show BinaryReader, BinaryWriter, Hive;

part 'src/model/data_model.dart';

part 'src/core/repository_base.dart';
part 'src/core/repository_locator.dart';
part 'src/core/repository_hive.dart';
part 'src/core/errors.dart';
part 'src/core/index_base.dart';

part 'src/adapters/indexes_adapter.dart';
part 'src/adapters/set_adapter.dart';
part 'src/core/serializer.dart';

part 'src/mixins/indexes_access.dart';
part 'src/mixins/reference_lookup.dart';

part 'src/consts.dart';
part 'src/utils/data_helper.dart';
