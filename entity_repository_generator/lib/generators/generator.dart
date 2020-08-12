part of entity_repository_generator;

class EntityRepositoryGenerator extends GeneratorForAnnotation<EntityModel> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor()
      ..referenceEntities = checkEntityReference(element)
      ..model = getEntityModel(element);

    element.visitChildren(visitor);

    final res = StringBuffer()
      ..write(generateAbstractClassInterface(visitor))
      ..write(generateReferenceLookup(visitor))
      ..write(generateClass(visitor))
      ..write(generateSerializerAdapter(visitor))
      ..write(generateRepositoryClass(visitor));

    final str = res.toString();
    return str;
  }

  StringBuffer generateAbstractClassInterface(ModelVisitor visitor) {
    final buff = StringBuffer();
    final className = visitor.className.getDisplayString();
    final cls = visitor.clazz;

    buff
      ..writeln('/// Interface to/off the class [$className]')
      ..writeln('abstract class _\$$className extends DataModel<$className> {')
      ..writeln('_\$$className(String id): super(id);')
      ..writeAll(cls.params.map((e) => e.toPublicField), '\n')

      /// copy with
      ..write(generateCopyWithSignature(visitor))
      ..write(';')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateReferenceLookup(ModelVisitor visitor) {
    final buff = StringBuffer();
    final cls = visitor.clazz;
    if (!cls.hasEntityReference) return buff;

    final refs = cls.paramsEntities.map((e) => e.toReferenceField);

    final accessors = cls.paramsEntities.map(
      (e) => e.toLookupMethod(),
    );

    buff
      ..writeln('mixin ${cls.referenceClassName} {')
      ..writeAll(refs, '\n')
      ..writeAll(accessors, '\n')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateClass(ModelVisitor visitor) {
    final buff = StringBuffer();
    final name = visitor.classNaming;
    final cls = visitor.clazz;

    /// assign parameter to class fields

    final constructorParams = [
      ...cls.paramsEntities.map((e) => e.toParamInit).toList(),
      ...cls.paramsNonEntity.map((e) => e.toParamInitThis).toList(),
    ];

    final constructorPrivateParamsInit =
        cls.paramsEntities.map((e) => e.toParamInitPrivate).toList();

    // class fields
    final classFieldsRegular =
        cls.paramsNonEntity.map((e) => e.toPublicFieldOverride).toList();

    /// remove set if only readable???
    final classFieldsEntityGetterSetter =
        cls.paramsEntities.map((e) => e.toGetSetPrivate).toList();

    final stringFields = cls.params.map((e) => e.stringfy).join(', ');
    final toString =
        "@override\nString toString() => '''$name(id: \$id, $stringFields)''';";

    buff
      ..write('class ${cls.name} extends ${(DataModel).$name}<$name> ')
      ..write(cls.hasEntityReference ? 'with ${cls.referenceClassName}' : '')
      ..write(' implements $name {\n')
      ..write('${cls.name}({String id,') // constructor
      ..writeAll(constructorParams, ',')
      ..write('}) : ') // constructor
      ..writeAll(constructorPrivateParamsInit, ',')
      ..write(constructorPrivateParamsInit.isNotEmpty ? ',' : '')
      ..writeln('super(id);\n')
      ..writeAll(classFieldsRegular, '\n')
      ..writeAll(classFieldsEntityGetterSetter, '\n')
      ..write(generateClassCopyConstructor(visitor))
      ..write(generateClassEquality(visitor))
      ..write(generateClassToString(visitor))
      ..writeln('}'); // end

    return buff;
  }

  StringBuffer generateClassToString(ModelVisitor visitor) {
    final buff = StringBuffer();
    final cls = visitor.clazz;
    final name = visitor.classNaming;

    buff
      ..writeln('\n@override')
      ..writeln('String toString() => ')
      ..writeln('// ignore: lines_longer_than_80_chars')
      ..write("'$name(id: \$id ")
      ..write(cls.params.isNotEmpty ? ', ' : '')
      ..writeAll(cls.params.map((e) => e.stringfy), ', ')
      ..write(")'")
      ..write(';');

    return buff;
  }

  StringBuffer generateCopyWithSignature(ModelVisitor visitor,
      {bool override = false}) {
    final buff = StringBuffer();
    final className = visitor.className.getDisplayString();
    final cls = visitor.clazz;

    buff
      ..writeln(override ? '\n@override' : '')
      ..writeln('$className copyWith({String id,')
      ..writeAll(cls.params.map((e) => e.toParamInit), ',')
      ..writeln('})');
    return buff;
  }

  StringBuffer generateClassCopyConstructor(ModelVisitor visitor) {
    final buff = StringBuffer();
    final cls = visitor.clazz;

    buff
      ..write(generateCopyWithSignature(visitor, override: true))
      ..writeln('{')
      ..writeln('return ${cls.name}(')
      ..writeln('id:id ?? this.id,')
      ..writeAll(
          cls.params.map((e) => '${e.name}: ${e.name} ?? this.${e.name}'), ',')
      ..writeln(');')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateClassEquality(ModelVisitor visitor) {
    final buff = StringBuffer();
    final cls = visitor.clazz;

    buff
      ..writeln('\n@override')
      ..writeln('bool operator ==(Object o) {')
      ..writeln('if (identical(this, o)) return true;')
      ..writeln('return o is ${visitor.clazz.name}')
      ..write(cls.params.isNotEmpty ? ' && ' : '')
      ..writeAll(cls.params.map((e) {
        if (e.type.isDartCoreList) {
          return 'listEquality(o.${e.name}, ${e.name})';
        } else if (e.type.isDartCoreSet) {
          return 'setEquality(o.${e.name}, ${e.name})';
        } else if (e.type.isDartCoreMap) {
          return 'mapEquality(o.${e.name}, ${e.name})';
        }

        return 'o.${e.name} == ${e.name}';
      }), ' && ')
      ..writeln(';}')

      /// hashCode Gen
      ..writeln('\n@override')
      ..writeln('int get hashCode {')
      ..writeln('return')
      ..writeAll(cls.params.map((e) => '${e.name}.hashCode'), ' ^ ')
      ..write(';')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateSerializerAdapter(ModelVisitor visitor) {
    final buff = StringBuffer();
    final params = visitor.clazz.params;

    const readerField = '''
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };''';

    buff
      ..writeln('/// The serialize adapter of type [${visitor.clazz.name}]')
      ..writeln(
          'class ${visitor.adapterName} implements ${(Serializer).$name}<${visitor.clazz.name}> {')
      ..writeln('@override\n final int typeId = ${visitor.model.typeId};\n')

      /// read bin
      ..writeln('@override')
      ..writeln('${visitor.clazz.name} read(BinaryReader reader) {')
      ..writeln(readerField)
      ..writeln('\n\nreturn ${visitor.clazz.name}(id: fields[0] as String)')
      ..writeAll(params.map((e) => e.toSerializeRead), '\n')
      ..writeln(';}')

      ///Write bin
      ..writeln('\n\n@override')
      ..writeln('void write(BinaryWriter writer, ${visitor.clazz.name} obj) {')
      ..writeln('writer')
      ..writeln('..writeByte(${params.length + 1})')
      ..writeln('..writeByte(0)')
      ..writeln('..write(obj.id)')
      ..writeAll(params.map((e) => e.toSerializeWrite), '\n')
      ..writeln(';}')
      ..write(generateSerializerAdapterEquality(visitor))
      ..write('}');

    return buff;
  }

  StringBuffer generateSerializerAdapterEquality(ModelVisitor visitor) {
    final buff = StringBuffer();

    final equal = '''@override
    int get hashCode => typeId.hashCode;

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is ${visitor.adapterName} &&
            runtimeType == other.runtimeType &&
            typeId == other.typeId;
            ''';

    buff.write(equal);
    return buff;
  }

  StringBuffer generateRepositoryClass(ModelVisitor visitor) {
    final buff = StringBuffer();
    final clazz = visitor.className;

    if (visitor.model.repository) {
      buff
        ..writeln('/// The [\$${clazz}Repo] class of type [$clazz]')
        ..write(
            'class \$${clazz}Repo extends ${(RepositoryHive).$name}<$clazz> ')
        ..write(visitor.generateIndicies
            ? 'with ${(IndicesAccess).$name}<$clazz>'
            : '')
        ..write('{')
        ..write(generateRepositoryClassIndices(visitor))
        ..write('}');
    }

    return buff;
  }
}

StringBuffer generateRepositoryClassIndices(ModelVisitor visitor) {
  final buff = StringBuffer();

  if (visitor.generateIndicies) {
    /// TODO: create index, when clear, what todo with index
// if (false) {
//   final indices = visitor.model.index;
//   final indexLength = indices.length + 1;

//   // generate index names
//   for (var i = 1; i < indexLength; i++) {
//     final e = indices.elementAt(i - 1);
//     buff.writeln("static const String _index$i = '${e.join('-')}';");
//   }

//   // generate getter for index
//   buff.writeln('\n\n');
//   for (var i = 1; i < indexLength; i++) {
//     buff.writeln(
//         '${(IndexBase).$name}<String> get index$i => indexGet(_index$i);');
//   }
//   buff.writeln('\n\n');

//   // generate register
//   final indexNames =
//       List.generate(indices.length, (i) => '_index${i + 1}').join(',');
//   buff
//     ..write('Future<void> _ensureRegisterdindices() ')
//     ..write('=> registerindices([$indexNames]);')
//     ..writeln('\n');

//   // get index keys
//   // for (var i = 1; i < indexLength; i++) {
//   //   final e = indices.elementAt(i - 1);
//   //   buff.writeln("static const String _index$i = '${e.join('-')}';");
//   // }
// }
  }

  return buff;
}
