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
      ..write(SerializerAdapter.generate(visitor));

    final str = res.toString();

    final str2 = str.replaceAll('*', '');
    return str2;
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
      ..write(SerializerMapJson.generateFactoryFromMapJson(visitor))
      ..write(
          SerializerMapJson.generateFactoryFromMapJson(visitor, isJson: true))
      ..write(generateGetAllReferenceObjects(visitor))
      ..write(SerializerMapJson.generateToMapJson(visitor))
      ..write(SerializerMapJson.generateToMapJson(visitor, isJson: true))
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
      ..writeAll(visitor.params.map((e) => e.asString), ', ')
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

  StringBuffer generateGetAllReferenceObjects(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..writeln('\n\n@override')
      ..writeln('Set<${(EntityBase).$name}> getAllRefObjects() {')
      ..writeln('final obj = <${(EntityBase).$name}>{};\n')
      ..writeAll(visitor.params.map((e) => e.toRefsObjects()), '\n')
      ..writeln('return obj;')
      ..writeln('}');

    return buff;
  }

  StringBuffer generateApplyUpdates(ModelVisitor visitor) {
    final buff = StringBuffer()
      ..writeln('\n\n@override')
      ..writeln('void applyUpdates(Map<int, dynamic> fields) {')
      ..writeAll(visitor.params.map((e) => e.toFieldFromMap()), '\n')
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
      ..writeAll(visitor.params.map((e) => e.toEquality), ' && ')
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
}
