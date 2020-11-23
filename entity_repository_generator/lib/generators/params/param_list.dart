part of entity_repository_generator;

class ParamList extends Param {
  ParamList(
    ParameterElement parameter, {
    Field field,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) : super(
          parameter,
          field: field,
          entityTypes: entityTypes,
        );

  bool get hasSubType => subTypes.isNotEmpty;

  InterfaceType get subTypeRaw => subTypes.first;
  String get subType => isOrHasEntities ? 'String' : subTypes.first.toString();

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
      $typeRaw $toLookUpMethodName {
        if($toRefNamePrivate != null){
          return locator.get<$enType>().findMany($toRefNamePrivate).toList();
        }
        return [];
      }''';
  }

  String toRefsObjects([String prefix = 'obj']) {
    if (isOrHasEntities) {
      final ifString = 'if($paramName != null && $paramName.isNotEmpty)';
      return '$ifString {obj.addAll($paramName);}';
    }

    return '';
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

  String get toEquality {
    if (isOrHasEntities) {
      return 'listEquality(o.${toRefNameGetter}, ${toRefNameGetter})';
    }

    return 'listEquality(o.${paramName}, ${paramName})';
  }

  @override
  String toString() => toPublicField;

  @override
  String fromMapJson([bool isJson = false]) {
    // access via json or index numbers!
    final mapAccess = isJson ? "'${paramName}'" : field.index;

    final assign = '(fields[$mapAccess] as List)?.cast<${subType}>()';

    return isOrHasEntities
        ? '..$toRefNamePrivate = $assign'
        : '$paramName : $assign';
  }
}
