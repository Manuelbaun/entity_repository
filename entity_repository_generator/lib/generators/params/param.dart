part of entity_repository_generator;

/**
 * This Param class is a simple type, no list/map/set etc.
 * It can be a simple primitive or also another entity case
 */
class Param implements ParamBase {
  Param(this.parameter, {this.field, this.entityTypes}) {
    _isOrHasEntities = isEntity;
  }

  ///
  /// Members
  ///
  final Field field;
  final ParameterElement parameter;
  final Map<InterfaceType, AnnotatedClazz> entityTypes;

  /// is true, when this param is an entity type
  /// TODO: Change the API
  bool _isOrHasEntities = false;
  bool get isOrHasEntities => _isOrHasEntities;
  bool get isEntity => Helper.isEntityType(rawType);

  // The actual type of the Param, not processed,
  String get paramName => parameter.displayName;
  String get type => rawType.getDisplayString(withNullability: false);
  String get typeOrEntityString => isEntity ? 'String' : type;

  @deprecated
  InterfaceType get rawType => parameter.type as InterfaceType;

  bool get hasSubType => false; //subTypes.isNotEmpty;

  /// Utility
  /// TODO: change, nullableSuffix is *
  // String get typeName => typeRaw.getDisplayString(withNullability: false);
  String get paramNamePrivate => '_$paramName';
  String get paramNameThis => 'this.$paramName';

  String get toParamInit => '$type $paramName';
  String get toPrivateField => '$type $paramNamePrivate;';
  String get toPublicField => '$toParamInit;';

  String get toPublicFieldGet => '$type get $paramName;';
  String get toRefField_ => 'String $toRefNamePrivate;';

  String get toParamInitPrivate => '$paramNamePrivate = $paramName';
  String get toPublicFieldOverride => '@override\n$toPublicField';

  String get toRefNameGetter => '${paramName}Refs';
  String get toRefNamePrivate => '_${paramName}Refs';
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
      ..writeln('$type get $paramName => ')
      ..writeln(isOrHasEntities
          ? '$paramNamePrivate ??= $toLookUpMethodName;'
          : '$paramNamePrivate;');

    return buff.toString();
  }

  String get toSetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('set $paramName($toParamInit) {')
      ..writeln('$paramNamePrivate = $paramName;');

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
      return '''$type $toLookUpMethodName {
        return locator.get<$type>().findOne($toRefNamePrivate);
      }''';
    } else {
      /// TODO: THis should not happen
      throw EntityRepositorGeneratorError(
          'Could not find the Type: $type in the entity reference list.');
    }
  }

  String toRefsObjects([String prefix = 'obj']) =>
      isEntity ? 'if($paramName != null) $prefix.add($paramName);' : '';

  String toFieldFromMap([String prefix = 'fields']) {
    return '''
    if($prefix.containsKey(${field.index})) { 
      $paramNamePrivate = $prefix[${field.index}] as $typeOrEntityString; 
    }''';
  }

  String get asString {
    return isOrHasEntities
        ? '$paramName: \${$toRefNameGetter}'
        : '$paramName: \$$paramName';
  }

  @override
  String toString() => toPublicField;

  @override
  String get toEquality {
    if (isOrHasEntities) {
      return 'o.${toRefNameGetter} == $toRefNameGetter';
    }

    return 'o.${paramName} == $paramName';
  }

  @override
  String fromMapJson([bool isJson = false]) {
    final mapAccess = isJson ? "'${paramName}'" : field.index;

    final fieldy = isEntity ? '..$toRefNamePrivate =' : '$paramName :';

    return '$fieldy (fields[$mapAccess] as $typeOrEntityString)';
  }

  get fieldString => isOrHasEntities ? toRefNameGetter : paramName;

  @override
  String toSerializerWrite() {
    return '..writeByte(${field.index})\n..write(obj.$fieldString)\n';
  }
}
