// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:entity_repository_generator/utils/top_level.dart';
import 'package:source_gen/source_gen.dart';

import '../builder.dart';

class EntityDatabaseGenerator extends Generator {
  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final topLevelVarCount = topLevelNumVariables(library).length;

    library.allElements.forEach((element) {
      print(element);
    });

    final list = library.allElements.toList();

    return '''
// Source library: ${library.element.source.uri}
const topLevelNumVarCount = $topLevelVarCount;
''';
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
