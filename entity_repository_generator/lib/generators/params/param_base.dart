part of entity_repository_generator;

abstract class ParamBase {
  final Field field;
  final String paramName;
  final InterfaceType typeRaw;

  String get type;

  final Map<InterfaceType, AnnotatedClazz> entityTypes;

  ParamBase({
    this.paramName,
    this.field,
    this.typeRaw,
    this.entityTypes,
  });

  /// The basic imple
  bool get isEntity;
  bool isOrHasEntities = false;

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

  String toLookupMethod();

  String get toRefField_;

  String get toRefFieldGetter;

  // general, if set field
  String get toRefIdIfExist;

  String toRefsObjects([String prefix = 'obj']);

  String toFieldFromMap([String prefix = 'fields']);

  String get toEquality;

  @override
  String toString() => toPublicField;
}
