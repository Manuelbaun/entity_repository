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
      classElement: element,
    );

    element.visitChildren(visitor);

    final res = StringBuffer()
      ..write(generateAbstractClassInterface(visitor))
      ..write(generateClass(visitor))
      ..write(generateSerializerAdapter(visitor));

    final str = res.toString();
    // print(str);
    return str;
  }

  StringBuffer generateAbstractClassInterface(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..writeln('/// Interface to/off the class [${visitor.entityName}]')
      ..write('abstract class _\$${visitor.entityName} ')
      ..write('extends ${(EntityBase).$name}<${visitor.entityName}> {\n')
      ..writeln('_\$${visitor.entityName}(String id): super(id);')
      ..writeAll(visitor.params.map((e) => e.toPublicField), '\n')

      // copy with
      ..write(generateCopyWithMethod(visitor))
      ..write(';')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateReferenceLookup(ModelVisitor visitor) {
    final buff = StringBuffer();

    if (!visitor.hasEntityReference) return buff;

    buff
      ..writeln('/// ')
      ..writeln('/// Generate the reference look up ')
      ..writeln('/// ')
      ..writeAll(visitor.paramsEntities.map((e) => e.toRefField_), '\n\n')
      ..writeAll(visitor.paramsEntities.map((e) => e.toRefFieldGetter), '\n\n')
      ..writeAll(visitor.paramsEntities.map((e) => e.toLookupMethod()), '\n\n');

    return buff;
  }

  StringBuffer generateClass(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..write(generateClassName(visitor))
      ..write('{\n')
      // Constructor
      ..write(generateClassConstructor(visitor))
      ..write(generateClassCopyConstructor(visitor))
      // class fields
      ..writeAll(visitor.params.map((e) => e.toPrivateFieldGetterSetter), '\n')
      // methods
      ..write(generateFactoryFromMap(visitor))
      ..write(generateGetAllReferenceObjects(visitor))
      ..write(generateToMap(visitor))
      ..write(generateToJson(visitor))
      ..write(generateApplyUpdates(visitor))
      ..write(generateClassEquality(visitor))
      ..write(generateClassToString(visitor))
      ..write(generateReferenceLookup(visitor))
      // end
      ..writeln('}');

    return buff;
  }

  StringBuffer generateClassName(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..write('class ${visitor.redirectName} extends ')
      ..write('${(EntityBase).$name}<${visitor.entityName}> ')
      ..write(' implements ${visitor.entityName}');

    return buff;
  }

  StringBuffer generateClassConstructor(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..write('${visitor.redirectName}({String id, ')
      ..writeAll(visitor.params.map((e) => e.toParamInit), ',')
      ..write('}) : ') // constructor
      ..writeAll(visitor.params.map((e) => e.toParamInitPrivate), ',')
      ..write(visitor.params.isNotEmpty ? ',' : '')
      ..writeln('super(id);\n');

    return buff;
  }

  StringBuffer generateClassCopyConstructor(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..write(generateCopyWithMethod(visitor, override: true))
      ..writeln('{')
      ..writeln('return ${visitor.redirectName}(')
      ..writeln('id:id ?? this.id,')
      ..writeAll(
          visitor.params.map(
              (e) => '${e.paramName}: ${e.paramName} ?? this.${e.paramName}'),
          ',')
      ..writeln(');')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateClassToString(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..writeln('\n@override')
      ..writeln('String toString() => ')
      ..write("'${visitor.entityName}(id: \$id")
      ..write(visitor.params.isNotEmpty ? ', ' : '')
      ..writeAll(visitor.params.map((e) => e.stringfy), ', ')
      ..write(")'")
      ..write(';');

    return buff;
  }

  StringBuffer generateCopyWithMethod(ModelVisitor visitor,
      {bool override = false}) {
    final buff = StringBuffer()
      ..writeln(override ? '\n@override' : '')
      ..writeln('${visitor.entityName} copyWith({String id,')
      ..writeAll(visitor.params.map((e) => e.toParamInit), ',')
      ..writeln('})');

    return buff;
  }

  StringBuffer generateFactoryFromMap(ModelVisitor visitor) {
    final allFields = visitor.paramsNonEntity.map((e) {
      final res = e.toSerializeReadField();
      return res;
    });

    final allReads = visitor.paramsEntities.map((e) {
      final res = e.toSerializeRead();
      return res;
    });

    final buff = StringBuffer()
      ..write('\n\n')
      ..write('factory ${visitor.redirectName}')
      ..write('.fromMap(Map<int, dynamic> fields) {')
      ..writeln('return ${visitor.redirectName}(id: fields[0] as String,')
      ..writeAll(allFields, ',\n')
      ..write(')')
      ..writeAll(allReads, '\n')
      ..write(';}');

    return buff;
  }

  StringBuffer generateGetAllReferenceObjects(ModelVisitor visitor) {
    final buff = StringBuffer()

      ///Write bin
      ..writeln('\n\n@override')
      ..writeln('Set<${(EntityBase).$name}> getAllRefObjects() {')
      ..writeln('final obj = <${(EntityBase).$name}>{};\n')
      ..writeAll(visitor.params.map((e) => e.toRefsObjects()), '\n')
      ..writeln('return obj;')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateToMap(ModelVisitor visitor) {
    ///Write bin
    final buff = StringBuffer()
      ..writeln('\n\n@override')
      ..writeln('Map<int, dynamic> toMap() {')
      ..writeln('final obj = <int, dynamic>{};')
      ..writeln('/// store the id as field 0')
      ..writeln('obj[0] = id;\n')
      ..writeAll(visitor.params.map((e) => e.toMapEntry()), '\n')
      ..writeln('return obj;')
      ..writeln('}');

    return buff;
  }

  /// TODO: merge generateTojson
  StringBuffer generateToJson(ModelVisitor visitor) {
    final allJsonFields = visitor.params.map((e) {
      final res = e.toMapEntry(isJson: true);
      return res;
    });

    ///Write bin
    final buff = StringBuffer()
      ..writeln('\n\n@override')
      ..writeln('Map<String, dynamic> toJson() {')
      ..writeln('final obj = <String, dynamic>{};')
      ..writeln('/// store the id as field 0')
      ..writeln("obj['id'] = id;\n")
      ..writeAll(allJsonFields, '\n')
      ..writeln('return obj;')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateApplyUpdates(ModelVisitor visitor) {
    final buff = StringBuffer()

      ///Write bin
      ..writeln('\n\n@override')
      ..writeln('void applyUpdates(Map<int, dynamic> fields) {')
      ..writeAll(visitor.params.map((e) => e.toFieldFromMap()), '\n')
      ..writeln('}');

    // final str = buff.toString();
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
      ..writeAll(visitor.params.map((e) => e.toEquality()), ' && ')
      ..writeln(';}')

      /// hashCode Gen
      ..writeln('\n@override')
      ..writeln('int get hashCode {')
      ..writeln('return id.hashCode')
      ..write(visitor.params.isNotEmpty ? ' ^ ' : '')
      ..writeAll(visitor.params.map((e) => '${e.paramName}.hashCode'), ' ^ ')
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
      ..write('${visitor.adapterName}(this.repo);')
      ..writeln('final RepositoryBase<${visitor.entityName}> repo;')
      ..writeln('@override\n final int typeId = ${visitor.model.typeId};\n')

      /// read bin
      ..writeln('@override')
      ..writeln('${visitor.redirectName} read(BinaryReader reader) {')
      ..writeln(readerField)
      ..write('\n\n')
      ..writeln('return ${visitor.redirectName}.fromMap(fields)..repo = repo')
      ..writeln(';}')

      ///Write bin
      ..writeln('\n\n@override')
      ..writeln(
          'void write(BinaryWriter writer, ${visitor.redirectName} obj) {')
      ..writeln('writer')
      ..writeln('..writeByte(${visitor.params.length + 1})')
      ..writeln('..writeByte(0)')
      ..writeln('..write(obj.id)')
      ..writeAll(visitor.params.map((e) => e.toSerializeWrite()), '\n')
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
}
