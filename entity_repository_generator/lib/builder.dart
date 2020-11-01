library entity_repository_generator;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:entity_repository/entity_repository.dart';

import 'generat_database/database_aggregated_builder.dart';
import 'generat_database/entity_database_generator.dart';
part 'errors/generator_error.dart';

part 'generators/annotated_clazz.dart';
part 'generators/helper.dart';
part 'generators/generator.dart';
part 'generators/sub_generators/serializer_map_json.dart';
part 'generators/sub_generators/serializer_adapter.dart';

part 'generators/model_visitor.dart';
part 'generators/params/param.dart';
part 'generators/params/param_base.dart';
part 'generators/params/param_list.dart';
part 'generators/params/param_map.dart';
part 'generators/params/param_set.dart';
part 'utils/errors.dart';
part 'utils/color_print.dart';

Builder entityRepositoryGenerator(BuilderOptions options) =>
    SharedPartBuilder([EntityRepositoryGenerator()], 'property_entity_repo');

Builder entityDatabaseGenerator(BuilderOptions options) =>
    DatabaseBuilderAggregated(EntityDatabaseGenerator());
