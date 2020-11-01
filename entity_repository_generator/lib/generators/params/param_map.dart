part of entity_repository_generator;

class ParamMap extends Param {
  ParamMap({
    String name,
    Field field,
    InterfaceType type,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) : super(
            paramName: name,
            field: field,
            type: type,
            entityTypes: entityTypes);

  bool get hasSubType => subTypes.isNotEmpty;

  bool get _keyIsEntity => isEntityType(subTypes.first);
  bool get _valueIsEntity => isEntityType(subTypes.last);

  String get toRefIdIfExist {
    final key = _keyIsEntity ? 'key.id' : 'key';
    final value = _valueIsEntity ? 'value.id' : 'value';

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
    final key = subTypes.first;
    final value = subTypes.last;

    final assignKey =
        _keyIsEntity ? 'locator.get<$key>().findOne(entry.key)' : 'entry.key';

    final assignValue = _valueIsEntity
        ? 'locator.get<$value>().findOne(entry.value)'
        : 'entry.value';

    // final v1 = $assignKey;
    // final v2 = $assignValue;
    return '''
      $type $toLookUpMethodName {
        if($toRefNamePrivate != null){
          final map = <$key, $value>{} ;
          for(final entry in $toRefNamePrivate.entries) {
            map[$assignKey] = $assignValue;
          }

          return map;
        }
        return {};
      }''';
  }

  String get toRefField_ {
    final key = _keyIsEntity ? 'String' : subTypes.first;
    final value = _valueIsEntity ? 'String' : subTypes.last;
    return 'Map<$key, $value> $toRefNamePrivate;';
  }

  String get toRefFieldGetter {
    final t1 = _keyIsEntity ? 'String' : subTypes.first;
    final t2 = _valueIsEntity ? 'String' : subTypes.last;

    return 'Map<$t1, $t2> get $toRefNameGetter => $toRefNamePrivate ??= $toRefIdIfExist;';
  }

  /// serialize
  /// TODO: check is this is also generic???
  ///
  String toSerializeWrite([String prefix = 'obj']) {
    var fieldString = isOrHasEntities ? toRefNameGetter : paramName;

    final buff = StringBuffer()
      ..writeln('..writeByte(${field.index})\n')
      ..writeln('..write($prefix.$fieldString)\n');

    return buff.toString();
  }

  String toSerializeRead([String prefix = 'fields']) {
    final keyType = _keyIsEntity ? 'String' : subTypes.first;
    final valueType = _valueIsEntity ? 'String' : subTypes.last;
    final fieldName = isOrHasEntities ? toRefNamePrivate : paramName;

    return '..$fieldName = (fields[${field.index}] as Map)?.cast<$keyType, $valueType>()';
  }

  String toRefsObjects([String prefix = 'obj']) {
    final ifString = 'if($paramName != null && $paramName.isNotEmpty)';

    if (_keyIsEntity && !_valueIsEntity)
      return '$ifString {obj.addAll($paramName.keys);}';
    if (!_keyIsEntity && _valueIsEntity)
      return '$ifString {obj.addAll($paramName.values);}';
    if (_keyIsEntity && _valueIsEntity) {
      return '$ifString {obj..addAll($paramName.keys)..addAll($paramName.values);}';
    }

    return '';
  }

// merge ??? with upper
  String toSerializeReadField([String prefix = 'fields']) {
    final key = _keyIsEntity ? 'String' : subTypes.first;
    final value = _valueIsEntity ? 'String' : subTypes.last;
    final fieldName = (isOrHasEntities) ? toRefNameGetter : paramName;

    return '$fieldName : ($prefix[${field.index}] as Map)?.cast<$key, $value>()';
  }

  String toFieldFromMap([String prefix = 'fields']) {
    final key = _keyIsEntity ? 'String' : subTypes.first;
    final value = _valueIsEntity ? 'String' : subTypes.last;
    final fieldName = (isOrHasEntities) ? toRefNamePrivate : '_$paramName';

    final str =
        '$fieldName = ($prefix[${field.index}] as Map)?.cast<$key, $value>()';
    return 'if($prefix.containsKey(${field.index})) { $str; }';
  }

  String get stringfy {
    if (isOrHasEntities) {
      return '$paramName: \${$toRefNameGetter}';
    } else {
      return '$paramName: \${$paramName?.map((key, value) => MapEntry(key, value))}';
    }
  }

  @override
  String toEquality([String prefix = 'o']) {
    return 'mapEquality(o.${paramName}, ${paramName})';
  }

  @override
  String toString() => toPublicField;
}
