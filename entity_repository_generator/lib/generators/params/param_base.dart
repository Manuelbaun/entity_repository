part of entity_repository_generator;

abstract class ParamBase {
  final Field field;
  final String paramName;
  final InterfaceType type;
  final Map<InterfaceType, AnnotatedClazz> entityTypes;

  ParamBase({
    this.paramName,
    this.field,
    this.type,
    this.entityTypes,
  });

  /// The basic imple
  bool get isEntity;

  bool get hasSubType;

  String get stringfy;

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

  String toSerializeWrite([String prefix = 'obj']);
  String toMapEntry({String prefix = 'obj', bool isJson = false});
  String toRefsObjects([String prefix = 'obj']);

  String toSerializeReadField([String prefix = 'fields']);
  String toSerializeRead([String prefix = 'fields']);
  String toFieldFromMap([String prefix = 'fields']);

  String toEquality([String prefix = 'o']);

  @override
  String toString() => toPublicField;
}
