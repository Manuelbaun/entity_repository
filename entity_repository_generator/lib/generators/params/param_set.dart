part of entity_repository_generator;

/// TODO: extends from ParamList?
/// Because many things are the same! => DRY
class ParamSet extends Param {
  ParamSet({
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

  String get toRefIdIfExist {
    return isEntityType(subTypes.first)
        // ? '$paramName?.map((e) => e.id)?.toList()'
        ? '$paramName?.map((e) => e.id)?.toSet()'
        : paramName;
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
          return locator.get<$enType>().findMany($toRefNamePrivate).toSet();
        }
        return {};
      }''';
  }

  /// serialize
  ///
  /// ..writeByte(...)
  /// ..write(...)
  String toSerializeWrite([String prefix = 'obj']) {
    var fieldString = isOrHasEntities ? toRefNameGetter : paramName;

    // if (type.isDartCoreSet) {
    fieldString += '?.toList()';
    // }

    final buff = StringBuffer()
      ..writeln('..writeByte(${field.index})\n')
      ..writeln('..write($prefix.$fieldString)\n');

    return buff.toString();
  }

  String toSerializeRead([String prefix = 'fields']) {
    final type = subTypes.first;

    if (isOrHasEntities) {
      /// [Set to list]
      return '..$toRefNamePrivate = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
    } else {
      /// [Set to list]
      return '..$paramName = (fields[${field.index}] as List)?.toSet()?.cast<$type>()';
    }
  }

  String get toRefField_ {
    final type = subTypes.first;
    final setType = isEntityType(type) ? 'Set<String>' : 'Set<$type>';
    return '$setType $toRefNamePrivate;';
  }

  String get toRefFieldGetter {
    final type = isEntityType(subTypes.first) ? 'String' : subTypes.first;
    return 'Set<$type> get $toRefNameGetter => $toRefNamePrivate ??= $toRefIdIfExist;';
  }

  String toRefsObjects([String prefix = 'obj']) {
    if (isOrHasEntities) {
      final ifString = 'if($paramName != null && $paramName.isNotEmpty)';
      return '$ifString {$prefix.addAll($paramName);}';
    }

    return '';
  }

  String toSerializeReadField([String prefix = 'fields']) {
    final type = subTypes.first;

    if (isOrHasEntities) {
      /// [Set to list]
      return '$toRefNameGetter: (fields[${field.index}] as List)?.toSet()?.cast<String>()';
    } else {
      /// [Set to list]
      return '$paramName : (fields[${field.index}] as List)?.toSet()?.cast<$type>()';
    }
  }

  String toFieldFromMap([String prefix = 'fields']) {
    var str = '';
    final type = subTypes.first;

    if (isOrHasEntities) {
      str =
          '$toRefNamePrivate = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
    } else {
      str =
          '_$paramName = (fields[${field.index}] as List)?.toSet()?.cast<$type>()';
    }
    return 'if(fields.containsKey(${field.index})) { $str; }';
  }

  String get stringfy {
    if (isOrHasEntities) return '$paramName: \${$toRefNameGetter}';
    return '$paramName: \$$paramName';
  }

  @override
  String toString() => toPublicField;

  @override
  String toEquality([String prefix = 'o']) {
    return 'setEquality(o.${paramName}, ${paramName})';
  }
}
