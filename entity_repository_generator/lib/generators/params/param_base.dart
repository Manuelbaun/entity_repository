part of entity_repository_generator;

abstract class ParamBase {
  final Field field;
  final ParameterElement parameter;
  final Map<InterfaceType, AnnotatedClazz> entityTypes;

  /// base Constructor
  ParamBase(this.parameter, {this.field, this.entityTypes});

  /// Factory class
  factory ParamBase.genericFactory({
    Field field,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
    ParameterElement parameter,
  }) {
    if (parameter.type.isDartCoreList) {
      return ParamList(parameter, field: field, entityTypes: entityTypes);
    } else if (parameter.type.isDartCoreSet) {
      return ParamSet(parameter, field: field, entityTypes: entityTypes);
    } else if (parameter.type.isDartCoreMap) {
      return ParamMap(parameter, field: field, entityTypes: entityTypes);
    }

    return Param(parameter, field: field, entityTypes: entityTypes);
  }

  String get paramName;
  String get type;
  InterfaceType get typeRaw;
  bool get isOrHasEntities;

  bool get isEntity;

  bool get hasSubType;
  String get asString;
  String get typeName;
  String get paramNamePrivate;
  String get toParamInit;
  String get paramNameThis;
  String get toParamInitPrivate;
  String get toPublicFieldGet;
  String get toPublicField;
  String get toPublicFieldOverride;
  String get toPrivateField;
  String get toGetter;
  String get toSetter;
  String get toPrivateFieldGetterSetter;
  String get toRefNameGetter;
  String get toRefNamePrivate;
  String get toLookUpMethodName;
  String get toRefField_;
  String get toRefFieldGetter;
  // general, if set field
  String get toRefIdIfExist;
  String get toEquality;

  String toLookupMethod();
  String toRefsObjects([String prefix = 'obj']);
  String toFieldFromMap([String prefix = 'fields']);

  String fromMapJson([bool isJson = false]);
  String toSerializerWrite();

  @override
  String toString() => toPublicField;
}
