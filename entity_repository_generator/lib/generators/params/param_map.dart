part of entity_repository_generator;

class ParamMap extends Param {
  ParamMap(
    ParameterElement parameter, {
    Field field,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) : super(parameter, field: field, entityTypes: entityTypes);

  bool get hasSubType => subTypes.isNotEmpty;

  InterfaceType get keyTypeRaw => subTypes.first;
  InterfaceType get valueTypeRaw => subTypes.last;

  bool get keyIsEntity => isEntityType(keyTypeRaw);
  bool get valueIsEntity => isEntityType(valueTypeRaw);

  String get keyType => keyIsEntity ? 'String' : keyTypeRaw.toString();
  String get valueType => valueIsEntity ? 'String' : valueTypeRaw.toString();

  String get toRefIdIfExist {
    final key = keyIsEntity ? 'key.id' : 'key';
    final value = valueIsEntity ? 'value.id' : 'value';

    /// TODO: debug!
    return isOrHasEntities
        ? '$paramName?.map((key, value) => MapEntry($key, $value))'
        : paramName;
  }

  /// if that is common, then remote me
  /// TODO:
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
    final assignKey = keyIsEntity
        ? 'locator.get<$keyTypeRaw>().findOne(entry.key)'
        : 'entry.key';

    final assignValue = valueIsEntity
        ? 'locator.get<$valueTypeRaw>().findOne(entry.value)'
        : 'entry.value';

    return '''
      $typeRaw $toLookUpMethodName {
        if($toRefNamePrivate != null){
          final map = <$keyTypeRaw, $valueTypeRaw>{};
          for(final entry in $toRefNamePrivate.entries) {
            final key = $assignKey;
            final value = $assignValue;
            map[key] = value ;
          }

          return map;
        }
        return {};
      }''';
  }

  String get toRefField_ {
    return 'Map<$keyType, $valueType> $toRefNamePrivate;';
  }

  String get toRefFieldGetter {
    return 'Map<$keyType, $valueType> get $toRefNameGetter => $toRefNamePrivate ??= $toRefIdIfExist;';
  }

  String toRefsObjects([String prefix = 'obj']) {
    final ifString = 'if($paramName != null && $paramName.isNotEmpty)';

    if (keyIsEntity && !valueIsEntity)
      return '$ifString {obj.addAll($paramName.keys);}';
    if (!keyIsEntity && valueIsEntity)
      return '$ifString {obj.addAll($paramName.values);}';
    if (keyIsEntity && valueIsEntity) {
      return '$ifString {obj..addAll($paramName.keys)..addAll($paramName.values);}';
    }

    return '';
  }

  String toFieldFromMap([String prefix = 'fields']) {
    final fieldName = (isOrHasEntities) ? toRefNamePrivate : '_$paramName';

    final str =
        '$fieldName = ($prefix[${field.index}] as Map)?.cast<$keyType, $valueType>()';
    return 'if($prefix.containsKey(${field.index})) { $str; }';
  }

  String get toEquality {
    if (isOrHasEntities) {
      return 'mapEquality(o.${toRefNameGetter}, ${toRefNameGetter})';
    }

    return 'mapEquality(o.${paramName}, ${paramName})';
  }

  @override
  String toString() => toPublicField;

  @override
  String fromMapJson([bool isJson = false]) {
    // access via json or index numbers!
    final mapAccess = isJson ? "'${paramName}'" : field.index;

    final assign =
        '(fields[$mapAccess] as Map)?.cast<${keyType}, ${valueType}>()';

    return isOrHasEntities
        ? '..$toRefNamePrivate = $assign'
        : '$paramName : $assign';
  }
}
