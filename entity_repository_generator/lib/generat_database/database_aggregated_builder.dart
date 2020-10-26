import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:pedantic/pedantic.dart';
import 'package:build/build.dart';
import 'package:entity_repository/entity_repository.dart';
import 'package:entity_repository_generator/builder.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';
import 'package:dart_style/dart_style.dart';

import 'entity_database_generator.dart';

// https://github.com/dart-lang/build/blob/master/docs/writing_an_aggregate_builder.md

final _formatter = DartFormatter();

/// TODO: Fix the repo generator, when issue fixed
/// https://github.com/dart-lang/language/issues/1268
class DatabaseBuilderAggregated implements Builder {
  DatabaseBuilderAggregated(
    this.generators, {
    String Function(String code) formatOutput,
    String generatedExtension = '.g.dart',
    List<String> additionalOutputExtensions = const [],
    String header,
  })  : _generatedExtension = generatedExtension,
        formatOutput = formatOutput ?? _formatter.format;

  /// The [buildExtensions] configuration for `.dart`
  final String _generatedExtension;

  /// Function that determines how the generated code is formatted.
  final String Function(String) formatOutput;
  final Generator generators;

  // specify the folder  for performance reason?!!
  static final _allFilesInLib = new Glob('lib/**/*dart');

  static AssetId _fileOutputLocaiton(BuildStep buildStep) {
    final path = p.join('lib', 'database.db.dart');

    final asset = AssetId(
      buildStep.inputId.package,
      path,
    );

    return asset;
  }

  Map<String, List<String>> get buildExtensions {
    return const {
      r'lib/$lib$': const ['lib/database.db.dart'],
    };
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final allElements = <ModelVisitor>{};
    final resolver = buildStep.resolver;
    final assets = buildStep.findAssets(_allFilesInLib);

    await for (final input in assets) {
      try {
        final library = await resolver.libraryFor(input);

        final annotated = LibraryReader(library)
            .classes
            .where((e) => entityModelChecker.hasAnnotationOf(e))
            .map((e) {
          final visitor = ModelVisitor(
            model: getEntityModel(e),
            entityTypes: getAllEntityModelReferences(e),
            classElement: e,
          );

          e.visitChildren(visitor);
          return visitor;
        });

        allElements.addAll(annotated);
      } catch (e) {
        print(EntityRepositoryError('$e'));
      }
    }

    /// TODO: run the database class generator here!!
    // final library = await buildStep.inputLibrary;

    final dbGen = GenerateDataBase(allElements);
    final res = dbGen.generate();
    final outputId = _fileOutputLocaiton(buildStep);
    var formattedOutput;
    try {
      formattedOutput = formatOutput(res);
    } catch (e, stack) {
      log.severe(
        '''
An error `${e.runtimeType}` occurred while formatting the generated source for
  ''',
        e,
        stack,
      );
    }

    try {
      unawaited(buildStep.writeAsString(outputId, formattedOutput));
    } catch (e, stack) {
      log.shout(e);
    }
  }
}