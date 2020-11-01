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
        if($_toRefName != null){
          return locator.get<$enType>().findMany($_toRefName).toSet();
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
      return '..$_toRefName = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
    } else {
      /// [Set to list]
      return '..$paramName = (fields[${field.index}] as List)?.toSet()?.cast<$type>()';
    }
  }

  /// apply condition if null or empty=> should not be in the map
  /// TODO: Check again
  /// TODO: merge toMapEntry and to MapEntry JSON!!!
  // String toMapEntry([String prefix = 'obj']) {
  //   var condition = '$paramName != null ';
  //   var str = '$prefix[${field.index}] = ';

  //   if (isOrHasEntities) {
  //     condition += '&& $paramName.isNotEmpty';
  //     str += toRefNameGetter;
  //   }

  //   return 'if($condition) {$str;}';
  // }

  String get toRefField_ {
    final type = subTypes.first;
    final setType = isEntityType(type) ? 'Set<String>' : 'Set<$type>';
    return '$setType $_toRefName;';
  }

  String get toRefFieldGetter {
    final type = isEntityType(subTypes.first) ? 'String' : subTypes.first;
    return 'Set<$type> get $toRefNameGetter => $_toRefName ??= $toRefIdIfExist;';
  }

  // // TODO Merge with toMapEntry
  // String toMapEntryJson([String prefix = 'obj']) {
  //   var condition = '$paramName != null && $paramName.isNotEmpty';
  //   var str = "$prefix['$paramName'] = $toRefNameGetter";

  //   return 'if($condition) {$str;}';
  // }

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
          '$_toRefName = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
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
