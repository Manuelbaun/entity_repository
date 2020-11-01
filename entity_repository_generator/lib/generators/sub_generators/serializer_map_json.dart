part of entity_repository_generator;

class SerializerMapJson {
  static StringBuffer generateToMapJson(ModelVisitor visitor,
      {bool isJson = false}) {
    String prefix = "map";

    String generateMapEntry(ParamBase p) {
      final mapAccess = isJson ? "'${p.paramName}'" : p.field.index;

      final addCondition = p.hasSubType ? '&& ${p.paramName}.isNotEmpty' : '';
      final fieldName = p.isOrHasEntities ? p.toRefNameGetter : p.paramName;
      return """
        if(${p.paramName} != null $addCondition) {
          $prefix[$mapAccess] = $fieldName;
        }""";
    }

    /// todo: Id should also be in params!!!
    final idField = isJson ? "$prefix['id'] = id;" : '$prefix[0] = id;';
    final mapType = isJson ? '<String, dynamic>' : '<int, dynamic>';
    final methodName = isJson ? 'toJson' : 'toMap';

    ///Write bin
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('Map$mapType $methodName() {')
      ..writeln('final $prefix = $mapType{};')
      ..writeln('/// store the id as field 0')
      ..writeln(idField)
      ..writeAll(visitor.params.map(generateMapEntry), '\n')
      ..writeln('return $prefix;')
      ..writeln('}');

    return buff;
  }

  static StringBuffer generateFactoryFromMapJson(ModelVisitor visitor,
      {bool isJson = false}) {
    final allFields = visitor.paramsNonEntity.map((p) {
      final res = SerializerMapJson.toSerializeRead(p,
          isMapEntry: true, isJson: isJson);
      return res;
    });

    final allReads = visitor.paramsEntities.map((p) {
      final res = SerializerMapJson.toSerializeRead(p, isJson: isJson);
      return res;
    });

    final methodName = isJson
        ? '.fromJson(Map<String, dynamic> fields)'
        : '.fromMap(Map<int, dynamic> fields)';

    final idField = isJson ? "fields['id']" : 'fields[0]';

    final buff = StringBuffer()
      ..write('\n\n')
      ..write('factory ${visitor.redirectName}')
      ..write(methodName)
      ..write('{')
      ..writeln('return ${visitor.redirectName}(')
      ..writeln('id: $idField as String,')
      ..writeAll(allFields, ',\n')
      ..write(')')
      ..writeAll(allReads, '\n')
      ..write(';}');

    return buff;
  }

  static String toSerializeRead(ParamBase p,
      {bool isJson = false, bool isMapEntry = false}) {
    // access via json or index numbers!
    final mapAccess = isJson ? "'${p.paramName}'" : p.field.index;

    // check wheter type or, if param is entity => string => id ref
    var type = p.type;

    var cast = '';
    if (p is ParamList) {
      type = 'List';
      cast = '?.cast<${p.subType}>()';
    } else if (p is ParamSet) {
      /// Set will be converted to list
      type = 'List';
      cast = '?.cast<${p.subType}>()?.toSet()';
    } else if (p is ParamMap) {
      type = 'Map';
      cast = '?.cast<${p.keyType}, ${p.valueType}>()';
    }

    if (isMapEntry) {
      final fieldName = p.isOrHasEntities ? p.toRefNameGetter : p.paramName;
      return '$fieldName : (fields[$mapAccess] as $type)$cast';
    } else {
      // if it is entity, or has entites, then take private ref field name;
      final fieldName = p.isOrHasEntities ? p.toRefNamePrivate : p.paramName;
      return '..$fieldName = (fields[$mapAccess] as $type)$cast';
    }
  }
}
