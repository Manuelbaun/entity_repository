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

  /// contains the name with a private _ ::
  ///
  /// '_$paramName'
  String get toParamNamePrivate => '_$paramName';

  /// contains the type and the name ::
  ///
  /// '$type $paramName'
  String get toTypeParam => '$type $paramName';

  /// contains the type and the name and is private ::
  ///
  /// '$type $paramNamePrivate;'
  String get toTypeParamPrivate => '$type $toParamNamePrivate;';

  /// '$toTypeParam;'
  String get toPublicField => '$toTypeParam;';

  /// '$type get $paramName;'
  String get toPublicFieldGet => '$type get $paramName;';

  /// assigns the {paramName} to {paramNamePrivate}
  String get toParamPrivateAssign => '$toParamNamePrivate = $paramName';

  /// '${paramName}Refs'
  String get toParamNameRef => '${paramName}Refs';

  /// '_$toParamNameRef'
  String get toParamNameRefPrivate => '_$toParamNameRef';

  /// 'String $toParamNameRefPrivate;'
  String get toRefFieldPrivate => 'String $toParamNameRefPrivate;';

  /// 'String get $toParamNameRef => $toParamNameRefPrivate ??= $toRefIdIfExist;';
  String get toRefFieldGetter =>
      'String get $toParamNameRef => $toParamNameRefPrivate ??= $toRefIdIfExist;';

  ///
  String get toRefIdIfExist {
    print(isEntity);
    if (isEntity) {
      return '$paramName?.id';
    } else {
      return paramName;
    }
  }

  String get toGetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('$type get $paramName => ')
      ..writeln(isOrHasEntities
          ? '$toParamNamePrivate ??= $toLookUpMethodName;'
          : '$toParamNamePrivate;');

    return buff.toString();
  }

  String get toSetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('set $paramName($toTypeParam) {')
      ..writeln('$toParamNamePrivate = $paramName;');

    if (isOrHasEntities) {
      buff
        ..writeln('$toParamNameRefPrivate = $toRefIdIfExist;')
        ..writeln('setKeyValue(${field.index}, $toParamNameRefPrivate);');
    } else {
      buff.writeln('setKeyValue(${field.index}, $paramName);');
    }

    buff.writeln('}');

    return buff.toString();
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

  //  final upName = name[0].toUpperCase() + name.substring(1);
  String get toLookUpMethodName => '_lookUp${paramName.capitalize()}()';

  String toLookupMethod() {
    if (isEntity) {
      return '''$type $toLookUpMethodName {
        return locator.get<$type>().findOne($toParamNameRefPrivate);
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
    final fieldName = isEntity ? toParamNameRefPrivate : toParamNamePrivate;
    return '''
    if($prefix.containsKey(${field.index})) { 
      $fieldName = $prefix[${field.index}] as $typeOrEntityString; 
    }''';
  }

  String get asString {
    return isOrHasEntities
        ? '$paramName: \${$toParamNameRef}'
        : '$paramName: \$$paramName';
  }

  @override
  String toString() => toPublicField;

  @override
  String get toEquality {
    if (isOrHasEntities) {
      return 'o.${toParamNameRef} == $toParamNameRef';
    }

    return 'o.${paramName} == $paramName';
  }

  @override
  String fromMapJson([bool isJson = false]) {
    final mapAccess = isJson ? "'${paramName}'" : field.index;

    final fieldy = isEntity ? '..$toParamNameRefPrivate =' : '$paramName :';

    return '$fieldy (fields[$mapAccess] as $typeOrEntityString)';
  }

  get fieldString => isOrHasEntities ? toParamNameRef : paramName;

  @override
  String toSerializerWrite() {
    return '..writeByte(${field.index})\n..write(obj.$fieldString)\n';
  }
}
