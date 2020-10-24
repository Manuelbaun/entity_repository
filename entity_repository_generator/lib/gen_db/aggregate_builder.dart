import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:entity_repository/entity_repository.dart';
import 'package:entity_repository_generator/builder.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

// https://github.com/dart-lang/build/blob/master/docs/writing_an_aggregate_builder.md
class ListAllFilesBuilder implements Builder {
  ListAllFilesBuilder(this.generators) {}

  final Generator generators;

  // specify the folder  for performance reason?!!
  static final _allFilesInLib = new Glob('lib/**');

  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      p.join('lib', 'test_db.dart'),
    );
  }

  Map<String, List<String>> get buildExtensions {
    return const {
      r'$lib$': const ['test_db.dart'],
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

    final dbGen = GenerateDataBase(allElements);

    final res = dbGen.generate();

    await buildStep.writeAsString(
      _allFileOutput(buildStep),
      res,
    );
  }
}

class GenerateDataBase {
  final Set<ModelVisitor> models;
  GenerateDataBase(this.models);

  String pathImport(ModelVisitor v) {
    final ll = v.classElement.location.components.first ?? '';
    return "import '$ll';";
  }

  String generate() {
    final str = StringBuffer();

    str
      ..writeln("import 'package:entity_repository/entity_repository.dart';")
      ..writeAll(models.map(pathImport), '\n')
      ..write('\n\n')
      ..writeln('/// ')
      ..writeln('/// Create the interfaces of the repositories')
      ..writeln('/// ')
      ..writeAll(models.map(writeInterfaceRepository), '\n')
      ..writeln('\n\n')
      ..writeln('/// ')
      ..writeln('/// Create the concrete repository classes')
      ..writeln('/// ')
      ..writeAll(models.map(writeRepositorHive), '\n')
      ..write('\n\n')
      ..write(writeDB());

    return str.toString();
  }

  String writeInterfaceRepository(ModelVisitor v) {
    return 'abstract class I${v.entityName}Repository implements RepositoryBase<${v.entityName}> {}';
  }

  String writeRepositorHive(ModelVisitor v) {
    final typeID =
        '${v.model.typeId}'; // 'AdapterIds.${v.entityName.toLowerCase()}';

    return '''class ${v.entityName}Repository extends RepositoryHive<${v.entityName}>
    implements I${v.entityName}Repository {
      ${v.entityName}Repository( HiveInterface hiveInstance, EntityMapFactory<EntityBase> fac,)
      : super(hiveInstance, fac, $typeID);}''';
  }

  StringBuffer writeDB() {
    final str = StringBuffer();

    str
      ..writeln('/// ')
      ..writeln('/// The database')
      ..writeln('/// ')
      ..writeln('class EntityDatabase extends EntityConfiguration {')
      ..writeln("EntityDatabase([String path = './hive_db']) : super(path);\n")

      /// generate init
      ..writeln('Future<void> initRepository() async {')
      ..writeAll(models.map(createRepo), '\n')
      ..writeln('/// Register all repositories')
      ..writeln('localHive')
      ..writeAll(models.map(registerAdapter), '\n')
      ..write(';\n\n')
      ..writeln('repositoryLocator')
      ..writeAll(models.map(registerLocator), '\n')
      ..write(';\n\n')

      /// init all repositories
      ..write('''// At the end, init all repos,
        await repositoryLocator.initAll(
        shoudSaveSubEntities: true,
        chainTracker: chainTracker,
        synchronizer: synchronizer,);''')
      ..writeln('}')
      ..write('\n\n')

      /// repo accessors
      ..writeAll(models.map(createRepoGetters), '\n')
      ..write('\n\n')

      /// repo accessors
      ..writeAll(models.map(createEntityConstructor), '\n')
      ..write('\n\n')

      /// generete close
      ///
      ..write('''Future<void> close() async {
    await repositoryLocator.disposeAll(); }''')

      /// close db
      ..writeln('}');

    return str;
  }

  String createRepo(ModelVisitor v) {
    final low = v.entityName.toLowerCase();
    final normal = v.entityName;

    return '_${low}Repository = ${normal}Repository(localHive, ${normal}.fromMap);';
  }

  String registerAdapter(ModelVisitor v) {
    final low = v.entityName.toLowerCase();
    final normal = v.entityName;
    final createAdapter = '\$${normal}Adapter(_${low}Repository)';

    return '..registerAdapter($createAdapter)';
  }

  String registerLocator(ModelVisitor v) {
    final low = v.entityName.toLowerCase();
    final normal = v.entityName;
    return '..register<${normal}>(_${low}Repository)';
  }

  String createRepoGetters(ModelVisitor v) {
    final low = v.entityName.toLowerCase();
    final normal = v.entityName;
    return '''
    I${normal}Repository _${low}Repository;
    I${normal}Repository get ${low}Repository => _${low}Repository;
    ''';
  }

  String createEntityConstructor(ModelVisitor v) {
    final low = v.entityName.toLowerCase();
    final normal = v.entityName;

    final str = StringBuffer()
      ..write('$normal create${normal}({')
      ..write('String id,')
      ..writeAll(v.params.map((e) => e.toParamInit), ',')
      ..write('}) => ')
      ..write('new ${normal}(id:id,')
      ..writeAll(v.params.map((e) => '${e.name}:${e.name}'), ',')
      ..writeln(')..repo = _${low}Repository;');

    return str.toString();
  }
}
