library entity_repository_generator;

import 'package:build/build.dart';

import 'package:source_gen/source_gen.dart';
import 'package:entity_repository/entity_repository.dart';

import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:ansicolor/ansicolor.dart';

import 'package:analyzer/dart/element/element.dart';

part 'generators/helper.dart';
part 'generators/generator.dart';
part 'generators/model_visitor.dart';
part 'generators/clazz.dart';
part 'generators/param.dart';
part 'utils/errors.dart';

Builder entityRepositoryGenerator(BuilderOptions options) =>
    SharedPartBuilder([EntityRepositoryGenerator()], 'property_entity_repo');
