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
            typeRaw: type,
            entityTypes: entityTypes);

  bool get hasSubType => subTypes.isNotEmpty;

  InterfaceType get subTypeRaw => subTypes.first;
  String get subType => isOrHasEntities ? 'String' : subTypes.first.toString();

  String get toRefIdIfExist {
    return isEntityType(subTypes.first)
        ? '$paramName?.map((e) => e.id)?.toSet()'
        : paramName;
  }

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
          return locator.get<$enType>().findMany($toRefNamePrivate).toSet();
        }
        return {};
      }''';
  }

  String get toRefField_ {
    final setType = isOrHasEntities ? 'Set<String>' : typeRaw;
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

  @override
  String toString() => toPublicField;

  String get toEquality {
    if (isOrHasEntities) {
      return 'setEquality(o.${toRefNameGetter}, ${toRefNameGetter})';
    }

    return 'setEquality(o.${paramName}, ${paramName})';
  }
}
