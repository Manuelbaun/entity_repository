part of entity_repository_generator;

/**
 * This Param class is a simple type, no list/map/set etc.
 * It can be a simple primitive or also another entity case
 */
class Param implements ParamBase {
  final Field field;
  final String paramName;
  final InterfaceType type;
  final Map<InterfaceType, AnnotatedClazz> entityTypes;

  Param({
    this.paramName,
    this.field,
    this.type,
    this.entityTypes,
  }) {
    if (type.isDartCoreList || type.isDartCoreSet || type.isDartCoreMap) {
      subTypes = getAllTypes(type).toSet();
    }

    /// TODO: refactore this
    if (type.isDartCoreList && isEntityType(subTypes.first)) {
      isOrHasEntities = true;
    } else if (type.isDartCoreSet && isEntityType(subTypes.first)) {
      /// [Set to List]
      isOrHasEntities = true;
    } else if (type.isDartCoreMap) {
      if (isEntityType(subTypes.first) || isEntityType(subTypes.last)) {
        isOrHasEntities = true;
      }
    } else if (isEntity) {
      isOrHasEntities = true;
    }
  }

  /// is true, when this param is an entity type
  bool isOrHasEntities = false;
  bool get isEntity => isEntityType(type);
  bool isEntityType(InterfaceType type) => entityTypes[type] != null;

  Set<InterfaceType> subTypes = {};
  bool get hasSubType => false; //subTypes.isNotEmpty;

  ///
  /// Factory class
  ///
  factory Param.genericFactory({
    String name,
    Field field,
    InterfaceType type,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) {
    if (type.isDartCoreList) {
      return ParamList(
          name: name, field: field, type: type, entityTypes: entityTypes);
    } else if (type.isDartCoreSet) {
      return ParamSet(
          name: name, field: field, type: type, entityTypes: entityTypes);
    } else if (type.isDartCoreMap) {
      return ParamMap(
          name: name, field: field, type: type, entityTypes: entityTypes);
    }
    return Param(
        paramName: name, field: field, type: type, entityTypes: entityTypes);
  }

  /// Utility
  String get typeName => type.getDisplayString();
  String get _paramName => '_$paramName';
  String get paramNameThis => 'this.$paramName';
  String get toParamInit => '$type $paramName';
  String get toParamInitPrivate => '$_paramName = $paramName';
  String get toPublicFieldGet => '$type get $paramName;';
  String get toPublicField => '$type $paramName;';
  String get toPublicFieldOverride => '@override\n$type $paramName;';
  String get toPrivateField => '$type $_paramName;';
  String get toRefNameGetter => '${paramName}Refs';
  String get _toRefName => '_${paramName}Refs';
  String get toRefField_ => 'String $_toRefName;';
  String get toRefFieldGetter =>
      'String get $toRefNameGetter => $_toRefName ??= $toRefIdIfExist;';

  ///
  /// ------------------------------------------------------
  /// ------------------------------------------------------
  /// ------------------------------------------------------
  /// These here neets to be overritten
  ///
  ///

  String get toRefIdIfExist => isEntity ? '$paramName?.id' : paramName;

  String get toGetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('$type get $paramName => ')
      ..writeln(isOrHasEntities
          ? '_$paramName ??= $toLookUpMethodName;'
          : '_$paramName;');

    return buff.toString();
  }

  String get toSetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('set $paramName($type $paramName) {')
      ..writeln('_$paramName = $paramName;');

    if (isOrHasEntities) {
      buff
        ..writeln('$_toRefName = $toRefIdIfExist;')
        ..writeln('setKeyValue(${field.index}, $_toRefName);');
    } else {
      buff.writeln('setKeyValue(${field.index}, $paramName);');
    }

    buff.writeln('}');

    return buff.toString();
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

  //  final upName = name[0].toUpperCase() + name.substring(1);
  String get toLookUpMethodName => '_lookUp${paramName.capitalize()}()';

  String toLookupMethod() {
    if (isEntity) {
      return '''$type $toLookUpMethodName {
        return locator.get<$typeName>().findOne($_toRefName);
      }''';
    } else {
      /// TODO: THis should not happen
      throw Exception(
          'Could not find the Type: $typeName in the entity reference list.');
    }
  }

  /// serialize
  ///
  /// ..writeByte(...)
  /// ..write(...)
  String toSerializeWrite([String prefix = 'obj']) {
    final fieldString = isEntity ? toRefNameGetter : paramName;
    final buff = StringBuffer()
      ..writeln('..writeByte(${field.index})\n')
      ..writeln('..write($prefix.$fieldString)\n');

    return buff.toString();
  }

  String toSerializeRead([String prefix = 'fields']) {
    return isEntity
        ? '..$_toRefName = ($prefix[${field.index}] as String)'
        : '..$paramName = $prefix[${field.index}] as $type';
  }

  /// apply condition if null or empty=> should not be in the map
  String toMapEntry({String prefix = 'obj', bool isJson = false}) {
    final mapAccess = isJson ? "'$paramName'" : field.index;
    final addCondition = hasSubType ? '&& $paramName.isNotEmpty' : '';

    return """
  if($paramName != null $addCondition) {
    $prefix[$mapAccess] = ${isOrHasEntities ? toRefNameGetter : paramName};
  }""";
  }

  String toRefsObjects([String prefix = 'obj']) =>
      isEntity ? 'if($paramName != null) $prefix.add($paramName);' : '';

  String toSerializeReadField([String prefix = 'fields']) {
    return isEntity
        ? '$toRefNameGetter : ($prefix[${field.index}] as String)'
        : '$paramName : $prefix[${field.index}] as $type';
  }

  String toFieldFromMap([String prefix = 'fields']) {
    var str = isEntity
        ? '$_toRefName = ($prefix[${field.index}] as String)'
        : '_$paramName = $prefix[${field.index}] as $type';

    return 'if($prefix.containsKey(${field.index})) { $str; }';
  }

  String get stringfy {
    if (isEntity) return '$paramName: \${$toRefNameGetter}';
    return '$paramName: \$$paramName';
  }

  @override
  String toString() => toPublicField;

  @override
  String toEquality([String prefix = 'o']) {
    return 'o.${paramName} == $paramName';
  }
}

// String toLookupMethod() {
//   final typeName = type.getDisplayString();

//   String method;

//   if (subTypes.isEmpty) {
//     if (isEntity) {
//       method = '''$type $toLookUpMethodName {
//         return locator.get<$typeName>().findOne($_toRefName);
//       }''';
//     } else {
//       throw Exception(
//           'Could not find the Type: $typeName in the entity reference list.');
//     }
//   } else if (type.isDartCoreList) {
//     final enType = subTypes.first;
//     method = '''
//       $type $toLookUpMethodName {
//         if($_toRefName != null){

//           return locator.get<$enType>().findMany($_toRefName).toList();
//         }
//         return [];
//       }''';
//   } else if (type.isDartCoreSet) {
//     final enType = subTypes.first;
//     method = '''
//       $type $toLookUpMethodName {
//         if($_toRefName != null){
//           return locator.get<$enType>().findMany($_toRefName).toSet();
//         }
//         return {};
//       }''';
//   } else if (type.isDartCoreMap) {
//     final type1 = subTypes.first;
//     final type2 = subTypes.last;

//     final ass1 = _isEntityParam(type1)
//         ? 'locator.get<$type1>().findOne(entry.key)'
//         : 'entry.key';

//     final ass2 = _isEntityParam(type2)
//         ? 'locator.get<$type2>().findOne(entry.value)'
//         : 'entry.value';

//     method = '''
//       $type $toLookUpMethodName {

//         if($_toRefName != null){
//           final map = <$type1, $type2>{} ;
//           for(final entry in $_toRefName.entries) {
//             final v1 = $ass1;
//             final v2 = $ass2;

//             map[v1] = v2;
//           }

//           return map;
//         }
//         return {};
//       }''';
//   }

//   return method;
// }
