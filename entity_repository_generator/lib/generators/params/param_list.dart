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
          typeRaw: type,
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
