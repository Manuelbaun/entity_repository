part of entity_repository_generator;

/**
 * This Param class is a simple type, no list/map/set etc.
 * It can be a simple primitive or also another entity case
 */
class Param implements ParamBase {
  final Field field;
  final String paramName;
  // The actual type of the Param, not processed,
  final InterfaceType typeRaw;

  String get type => isEntity ? 'String' : typeRaw.toString();

  final Map<InterfaceType, AnnotatedClazz> entityTypes;

  Param({
    this.paramName,
    this.field,
    this.typeRaw,
    this.entityTypes,
  }) {
    if (typeRaw.isDartCoreList ||
        typeRaw.isDartCoreSet ||
        typeRaw.isDartCoreMap) {
      subTypes = getAllTypes(typeRaw).toSet();
    }

    /// TODO: refactore this
    if (typeRaw.isDartCoreList && isEntityType(subTypes.first)) {
      isOrHasEntities = true;
    } else if (typeRaw.isDartCoreSet && isEntityType(subTypes.first)) {
      /// [Set to List]
      isOrHasEntities = true;
    } else if (typeRaw.isDartCoreMap) {
      if (isEntityType(subTypes.first) || isEntityType(subTypes.last)) {
        isOrHasEntities = true;
      }
    } else if (isEntity) {
      isOrHasEntities = true;
    }
  }

  /// is true, when this param is an entity type
  bool isOrHasEntities = false;
  bool get isEntity => isEntityType(typeRaw);
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
        paramName: name, field: field, typeRaw: type, entityTypes: entityTypes);
  }

  /// Utility
  String get typeName => typeRaw.getDisplayString();
  String get paramNamePrivate => '_$paramName';
  String get paramNameThis => 'this.$paramName';
  String get toParamInit => '$typeRaw $paramName';
  String get toParamInitPrivate => '$paramNamePrivate = $paramName';
  String get toPublicFieldGet => '$typeRaw get $paramName;';
  String get toPublicField => '$typeRaw $paramName;';
  String get toPublicFieldOverride => '@override\n$typeRaw $paramName;';
  String get toPrivateField => '$typeRaw $paramNamePrivate;';
  String get toRefNameGetter => '${paramName}Refs';
  String get toRefNamePrivate => '_${paramName}Refs';
  String get toRefField_ => 'String $toRefNamePrivate;';
  String get toRefFieldGetter =>
      'String get $toRefNameGetter => $toRefNamePrivate ??= $toRefIdIfExist;';

  ///
  /// ------------------------------------------------------
  /// These here neets to be overritten
  ///

  String get toRefIdIfExist => isEntity ? '$paramName?.id' : paramName;

  String get toGetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('$typeRaw get $paramName => ')
      ..writeln(isOrHasEntities
          ? '_$paramName ??= $toLookUpMethodName;'
          : '_$paramName;');

    return buff.toString();
  }

  String get toSetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('set $paramName($typeRaw $paramName) {')
      ..writeln('_$paramName = $paramName;');

    if (isOrHasEntities) {
      buff
        ..writeln('$toRefNamePrivate = $toRefIdIfExist;')
        ..writeln('setKeyValue(${field.index}, $toRefNamePrivate);');
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
      return '''$typeRaw $toLookUpMethodName {
        return locator.get<$typeName>().findOne($toRefNamePrivate);
      }''';
    } else {
      /// TODO: THis should not happen
      throw Exception(
          'Could not find the Type: $typeName in the entity reference list.');
    }
  }

  String toRefsObjects([String prefix = 'obj']) =>
      isEntity ? 'if($paramName != null) $prefix.add($paramName);' : '';

  String toFieldFromMap([String prefix = 'fields']) {
    var str = isEntity
        ? '$toRefNamePrivate = ($prefix[${field.index}] as String)'
        : '_$paramName = $prefix[${field.index}] as $typeRaw';

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
