part of entity_repository_generator;

class ParamList extends Param {
  ParamList(
    ParameterElement parameter, {
    Field field,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) : super(parameter, field: field, entityTypes: entityTypes) {
    final allTypes = Helper.getAllTypes(rawType);
    subTypes = allTypes.toSet();

    _isOrHasEntities = Helper.isEntityType(subTypes.first);
  }

  Set<InterfaceType> subTypes = {};
  bool get hasSubType => subTypes.isNotEmpty;

  String get subType => isOrHasEntities ? 'String' : subTypes.first.toString();

  String get toRefIdIfExist {
    return Helper.isEntityType(subTypes.first)
        ? '$paramName?.map((e) => e.id)?.toList()'
        : paramName;
  }

  String get toRefFieldPrivate {
    final type = subTypes.first;
    final setType = Helper.isEntityType(type) ? 'List<String>' : 'List<$type>';
    return '$setType $toParamNameRefPrivate;';
  }

  String get toRefFieldGetter {
    final type =
        Helper.isEntityType(subTypes.first) ? 'String' : subTypes.first;
    return 'List<$type> get $toParamNameRef => $toParamNameRefPrivate ??= $toRefIdIfExist;';
  }
  // String get toLookUpMethodName => '_lookUp${paramName.capitalize()}()';

  String get toPrivateFieldGetterSetter {
    final buff = StringBuffer()
      ..write(toTypeParamPrivate)
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
        if($toParamNameRefPrivate != null){
          return locator.get<$enType>().findMany($toParamNameRefPrivate).toList();
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
          '$toParamNameRefPrivate = (fields[${field.index}] as List)?.cast<String>()';
    } else {
      str =
          '$toParamNamePrivate = (fields[${field.index}] as List)?.cast<$type>()';
    }
    return 'if(fields.containsKey(${field.index})) { $str; }';
  }

  String get toEquality {
    if (isOrHasEntities) {
      return 'listEquality(o.${toParamNameRef}, ${toParamNameRef})';
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
        ? '..$toParamNameRefPrivate = $assign'
        : '$paramName : $assign';
  }
}
