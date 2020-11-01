part of entity_repository_generator;

class ParamList extends Param {
  ParamList({
    String name,
    Field field,
    InterfaceType type,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) : super(
          paramName: name,
          field: field,
          type: type,
          entityTypes: entityTypes,
        );

  bool get hasSubType => subTypes.isNotEmpty;

  String get toRefIdIfExist {
    return isEntityType(subTypes.first)
        ? '$paramName?.map((e) => e.id)?.toList()'
        : paramName;
  }

  String get toRefField_ {
    final type = subTypes.first;
    final setType = isEntityType(type) ? 'List<String>' : 'List<$type>';
    return '$setType $toRefNamePrivate;';
  }

  String get toRefFieldGetter {
    final type = isEntityType(subTypes.first) ? 'String' : subTypes.first;
    return 'List<$type> get $toRefNameGetter => $toRefNamePrivate ??= $toRefIdIfExist;';
  }
  // String get toLookUpMethodName => '_lookUp${paramName.capitalize()}()';

  String get toPrivateFieldGetterSetter {
    final buff = StringBuffer()
      ..write(toPrivateField)
      ..write('\n\n')
      ..write(toGetter)
      ..write('\n\n')
      ..write(toSetter);

    return buff.toString();
  }

  String toLookupMethod() {
    final enType = subTypes.first;

    return '''
      $type $toLookUpMethodName {
        if($toRefNamePrivate != null){
          return locator.get<$enType>().findMany($toRefNamePrivate).toList();
        }
        return [];
      }''';
  }

  /// serialize
  ///
  /// ..writeByte(...)
  /// ..write(...)
  String toSerializeWrite([String prefix = 'obj']) {
    final fieldString = isOrHasEntities ? toRefNameGetter : paramName;

    final buff = StringBuffer()
      ..writeln('..writeByte(${field.index})\n')
      ..writeln('..write($prefix.$fieldString)\n');

    return buff.toString();
  }

  String toSerializeRead([String prefix = 'fields']) {
    return isOrHasEntities
        ? '..$toRefNamePrivate = (fields[${field.index}] as List)?.cast<String>()'
        : '..$paramName = (fields[${field.index}] as List)?.cast<${subTypes.first}>()';
  }

  String toRefsObjects([String prefix = 'obj']) {
    if (isOrHasEntities) {
      final ifString = 'if($paramName != null && $paramName.isNotEmpty)';
      return '$ifString {obj.addAll($paramName);}';
    }

    return '';
  }

  String toSerializeReadField([String prefix = 'fields']) {
    final type = subTypes.first;
    if (isOrHasEntities) {
      return '$toRefNameGetter: (fields[${field.index}] as List)?.cast<String>()';
    } else {
      return '$paramName : (fields[${field.index}] as List)?.cast<$type>()';
    }
  }

  String toFieldFromMap([String prefix = 'fields']) {
    var str = '';
    final type = subTypes.first;

    if (isOrHasEntities) {
      str =
          '$toRefNamePrivate = (fields[${field.index}] as List)?.cast<String>()';
    } else {
      str = '_$paramName = (fields[${field.index}] as List)?.cast<$type>()';
    }
    return 'if(fields.containsKey(${field.index})) { $str; }';
  }

  String get stringfy {
    if (isOrHasEntities) return '$paramName: \${$toRefNameGetter}';
    return '$paramName: \$$paramName';
  }

  @override
  String toEquality([String prefix = 'o']) {
    return 'listEquality(o.${paramName}, ${paramName})';
  }

  @override
  String toString() => toPublicField;
}
