// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// import 'package:build/build.dart';
// import 'package:entity_repository_generator/utils/top_level.dart';
// import 'package:source_gen/source_gen.dart';

import '../builder.dart';

// class EntityDatabaseGenerator3 extends Generator {
//   @override
//   String generate(LibraryReader library, BuildStep buildStep) {
//     final topLevelVarCount = topLevelNumVariables(library).length;

//     library.allElements.forEach((element) {
//       print(element);
//     });

//     // final list = library.allElements.toList();

//     return '''
// // Source library: ${library.element.source.uri}
// const topLevelNumVarCount = $topLevelVarCount;
// ''';
//   }
// }

class EntityDatabaseGenerator {
  EntityDatabaseGenerator() : super();

  String pathImport(ModelVisitor v) {
    final ll = v.classElement.location.components.first ?? '';
    return "import '$ll';";
  }

  String generate(Set<ModelVisitor> models) {
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
      ..write(writeDB(models));

    return str.toString();
  }

  StringBuffer writeInterfaceRepository(ModelVisitor v) {
    final str = StringBuffer()
      ..write('abstract class I${v.repoName} ')
      ..write('implements RepositoryBase<${v.entityName}>')
      ..write('{')
      ..write(generateEntityFactorySignature(v))
      ..write(';')
      ..write('}');

    return str;
  }

  StringBuffer writeRepositorHive(ModelVisitor v) {
    final str = StringBuffer()
      ..write('class ${v.repoName} ')
      ..write('extends RepositoryHive<${v.entityName}>')
      ..write('implements I${v.repoName} {')
      ..write('${v.repoName}(HiveInterface hiveInstance,')
      ..writeln('EntityMapFactory<${v.entityName}> fac,)')
      ..writeln(': super(hiveInstance, fac, ${v.model.typeId});')
      ..write(generateEntityCreateMethod(v, useThis: true))
      ..write('}');

    return str;
  }

  StringBuffer writeDB(Set<ModelVisitor> models) {
    final str = StringBuffer();

    str
      ..writeln('/// ')
      ..writeln('/// The database')
      ..writeln('/// ')
      ..writeln('class EntityDatabase extends EntityDatabaseClass {')
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
      ..writeln('///')
      ..writeln(
          '/// These methods will be redirected, once the dart team fixes')
      ..writeln('/// the auto completion for typedef function signigtures')
      ..writeln('/// ')
      ..writeAll(models.map(generateEntityCreateMethod), '\n')
      ..write('\n\n')

      /// generete close
      ..writeln('Future<void> close() async ')
      ..writeln('{ await repositoryLocator.disposeAll(); }')

      /// close db
      ..writeln('}');

    return str;
  }

  String createRepo(ModelVisitor v) {
    return '_${v.repoNameLowerCase} = ${v.repoName}(localHive, ${v.entityName}.fromMap);';
  }

  String registerAdapter(ModelVisitor v) {
    return '..registerAdapter(${v.adapterName}(_${v.repoNameLowerCase}))';
  }

  String registerLocator(ModelVisitor v) {
    return '..register<${v.entityName}>(_${v.entityNameLowerCase}Repository)';
  }

  String createRepoGetters(ModelVisitor v) {
    return '''
    I${v.repoName} _${v.repoNameLowerCase};
    I${v.repoName} get ${v.repoNameLowerCase} => _${v.repoNameLowerCase};
    ''';
  }

  /// TODO:
  /// Remote the generateEntityCreateMethod from the
  String generateEntityCreateMethod(ModelVisitor v, {bool useThis = false}) {
    final name = v.entityName;
    final repo = useThis ? 'this' : '_${v.repoNameLowerCase}';

    final str = StringBuffer()
      ..write(generateEntityFactorySignature(v, withName: !useThis))
      ..write(' => ')
      ..write('new ${name}(id:id,')
      ..writeAll(v.params.map((e) => '${e.paramName}:${e.paramName}'), ',')
      ..writeln(')..repo = $repo;');

    return str.toString();
  }

  StringBuffer generateEntityFactorySignature(ModelVisitor v,
      {bool withName = false}) {
    final name = withName ? v.entityName : '';

    final str = StringBuffer()
      ..write('${v.entityName} create${name}({')
      ..write('String id,')
      ..writeAll(v.params.map((e) => e.toParamInit), ',')
      ..write('})');
    return str;
  }
}
