part of entity_repository_generator;

class EntityRepositoryGenerator extends GeneratorForAnnotation<EntityModel> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor(
      model: getEntityModel(element),
      entityTypes: getAllEntityModelReferences(element),
    );

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
    final buff = StringBuffer()
      ..writeln('/// Interface to/off the class [${visitor.entityName}]')
      ..write('abstract class _\$${visitor.entityName} ')
      ..write('extends DataModel<${visitor.entityName}> {\n')
      ..writeln('_\$${visitor.entityName}(String id): super(id);')
      ..writeAll(visitor.params.map((e) => e.toPublicField), '\n')

      // copy with
      ..write(generateCopyWithSignature(visitor))
      ..write(';')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateReferenceLookup(ModelVisitor visitor) {
    final buff = StringBuffer();

    if (!visitor.hasEntityReference) return buff;

    buff
      ..writeln('/// Generate the reference look up mixin')
      ..writeln('mixin ${visitor.referenceClassName} {')
      ..writeAll(visitor.paramsEntities.map((e) => e.toReferenceField), '\n')
      ..writeAll(
          visitor.paramsEntities.map(
            (e) => e.toLookupMethod(),
          ),
          '\n')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateClass(ModelVisitor visitor) {
    final buff = StringBuffer();

    /// assign parameter to class fields

    final constructorParams = [
      ...visitor.paramsEntities.map((e) => e.toParamInit).toList(),
      ...visitor.paramsNonEntity.map((e) => e.toParamInitThis).toList(),
    ];

    final constructorPrivateParamsInit =
        visitor.paramsEntities.map((e) => e.toParamInitPrivate).toList();

    // class fields
    final classFieldsRegular =
        visitor.paramsNonEntity.map((e) => e.toPublicFieldOverride).toList();

    /// remove set if only readable???
    final classFieldsEntityGetterSetter =
        visitor.paramsEntities.map((e) => e.toGetSetPrivate).toList();

    buff
      ..write('class ${visitor.redirectName} extends ')
      ..write('${(DataModel).$name}<${visitor.entityName}> ')
      ..write(visitor.hasEntityReference
          ? 'with ${visitor.referenceClassName}'
          : '')
      ..write(' implements ${visitor.entityName} {\n')
      ..write('${visitor.redirectName}({String id,') // constructor
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
    final buff = StringBuffer()
      ..writeln('\n@override')
      ..writeln('String toString() => ')
      ..writeln('// ignore: lines_longer_than_80_chars')
      ..write("'${visitor.entityName}(id: \$id ")
      ..write(visitor.params.isNotEmpty ? ', ' : '')
      ..writeAll(visitor.params.map((e) => e.stringfy), ', ')
      ..write(")'")
      ..write(';');

    return buff;
  }

  StringBuffer generateCopyWithSignature(ModelVisitor visitor,
      {bool override = false}) {
    final buff = StringBuffer()
      ..writeln(override ? '\n@override' : '')
      ..writeln('${visitor.entityName} copyWith({String id,')
      ..writeAll(visitor.params.map((e) => e.toParamInit), ',')
      ..writeln('})');

    return buff;
  }

  StringBuffer generateClassCopyConstructor(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..write(generateCopyWithSignature(visitor, override: true))
      ..writeln('{')
      ..writeln('return ${visitor.redirectName}(')
      ..writeln('id:id ?? this.id,')
      ..writeAll(
          visitor.params.map((e) => '${e.name}: ${e.name} ?? this.${e.name}'),
          ',')
      ..writeln(');')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateClassEquality(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..writeln('\n@override')
      ..writeln('bool operator ==(Object o) {')
      ..writeln('if (identical(this, o)) return true;')
      ..writeln('return o is ${visitor.redirectName} &&')
      ..write('o.id == id')
      ..write(visitor.params.isNotEmpty ? ' && ' : '')
      ..writeAll(visitor.params.map((e) {
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
      ..writeln('return id.hashCode')
      ..write(visitor.params.isNotEmpty ? ' ^ ' : '')
      ..writeAll(visitor.params.map((e) => '${e.name}.hashCode'), ' ^ ')
      ..write(';')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateSerializerAdapter(ModelVisitor visitor) {
    final buff = StringBuffer();

    const readerField = '''
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };''';

    buff
      ..writeln('/// The serialize adapter of type [${visitor.redirectName}]')
      ..write('class ${visitor.adapterName} implements ')
      ..write('${(Serializer).$name}<${visitor.redirectName}> {')
      ..writeln('@override\n final int typeId = ${visitor.model.typeId};\n')

      /// read bin
      ..writeln('@override')
      ..writeln('${visitor.redirectName} read(BinaryReader reader) {')
      ..writeln(readerField)
      ..writeln('\n\nreturn ${visitor.redirectName}(id: fields[0] as String)')
      ..writeAll(visitor.params.map((e) => e.toSerializeRead), '\n')
      ..writeln(';}')

      ///Write bin
      ..writeln('\n\n@override')
      ..writeln(
          'void write(BinaryWriter writer, ${visitor.redirectName} obj) {')
      ..writeln('writer')
      ..writeln('..writeByte(${visitor.params.length + 1})')
      ..writeln('..writeByte(0)')
      ..writeln('..write(obj.id)')
      ..writeAll(visitor.params.map((e) => e.toSerializeWrite), '\n')
      ..writeln(';}')
      ..write(generateSerializerAdapterEquality(visitor))
      ..write('}');

    return buff;
  }

  StringBuffer generateSerializerAdapterEquality(ModelVisitor visitor) {
    final buff = StringBuffer()..write('''@override
    int get hashCode => typeId.hashCode;

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is ${visitor.adapterName} &&
            runtimeType == other.runtimeType &&
            typeId == other.typeId;
            ''');

    return buff;
  }

  StringBuffer generateRepositoryClass(ModelVisitor visitor) {
    final buff = StringBuffer();

    if (!visitor.model.repository) return buff;

    buff
      ..write('/// The [\$${visitor.entityName}Repo] class ')
      ..write('of type [${visitor.entityName}]')
      ..write('class \$${visitor.entityName}Repo ')
      ..write('extends ${(RepositoryHive).$name}<${visitor.entityName}> ')
      ..write(visitor.generateIndicies
          ? 'with ${(IndicesAccess).$name}<${visitor.entityName}>'
          : '')
      ..write('{')
      ..write(generateRepositoryClassIndices(visitor))
      ..write('}');

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
