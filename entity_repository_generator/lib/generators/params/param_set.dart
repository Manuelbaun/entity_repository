part of entity_repository_generator;

/// TODO: extends from ParamList?
/// Because many things are the same! => DRY
class ParamSet extends Param {
  ParamSet(
    ParameterElement parameter, {
    Field field,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) : super(parameter, field: field, entityTypes: entityTypes) {
    subTypes = Helper.getAllTypes(rawType).toSet();

    _isOrHasEntities = Helper.isEntityType(subTypes.first);
  }

  Set<InterfaceType> subTypes = {};

  bool get hasSubType => subTypes.isNotEmpty;

  InterfaceType get subTypeRaw => subTypes.first;
  String get subType => isOrHasEntities ? 'String' : subTypes.first.toString();

  String get toRefIdIfExist {
    return Helper.isEntityType(subTypes.first)
        ? '$paramName?.map((e) => e.id)?.toSet()'
        : paramName;
  }

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
          return locator.get<$enType>().findMany($toParamNameRefPrivate).toSet();
        }
        return {};
      }''';
  }

  String get toRefFieldPrivate {
    final setType = isOrHasEntities ? 'Set<String>' : type;
    return '$setType $toParamNameRefPrivate;';
  }

  String get toRefFieldGetter {
    final type =
        Helper.isEntityType(subTypes.first) ? 'String' : subTypes.first;
    return 'Set<$type> get $toParamNameRef => $toParamNameRefPrivate ??= $toRefIdIfExist;';
  }

  String toRefsObjects([String prefix = 'obj']) {
    if (isOrHasEntities) {
      final ifString = 'if($paramName != null && $paramName.isNotEmpty)';
      return '$ifString {$prefix.addAll($paramName);}';
    }

    return '';
  }

  String toFieldFromMap([String prefix = 'fields']) {
    var str = '';
    final type = subTypes.first;

    if (isOrHasEntities) {
      str =
          '$toParamNameRefPrivate = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
    } else {
      str =
          '_$paramName = (fields[${field.index}] as List)?.toSet()?.cast<$type>()';
    }
    return 'if(fields.containsKey(${field.index})) { $str; }';
  }

  @override
  String toString() => toPublicField;

  String get toEquality {
    if (isOrHasEntities) {
      return 'setEquality(o.${toParamNameRef}, ${toParamNameRef})';
    }

    return 'setEquality(o.${paramName}, ${paramName})';
  }

  @override
  String fromMapJson([bool isJson = false]) {
    final mapAccess = isJson ? "'${paramName}'" : field.index;

    final fieldy =
        isOrHasEntities ? '..$toParamNameRefPrivate =' : '$paramName :';
    return '$fieldy (fields[$mapAccess] as List)?.cast<${subType}>()?.toSet()';
  }

  @override
  String toSerializerWrite({bool isJson = false, bool isMapEntry = false}) {
    // Set will be converted to list
    final fieldString = this.fieldString + '?.toList()';
    return '..writeByte(${field.index})\n..write(obj.$fieldString)\n';
  }
}
