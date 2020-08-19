library entity_repository_generator;

import 'package:build/build.dart';

import 'package:source_gen/source_gen.dart';
import 'package:entity_repository/entity_repository.dart';

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:meta/meta.dart';
import 'package:analyzer/dart/element/element.dart';

part 'generators/annotated_clazz.dart';
part 'generators/helper.dart';
part 'generators/generator.dart';
part 'generators/model_visitor.dart';
part 'generators/param.dart';
part 'utils/errors.dart';
part 'utils/color_print.dart';

Builder entityRepositoryGenerator(BuilderOptions options) =>
    SharedPartBuilder([EntityRepositoryGenerator()], 'property_entity_repo');
