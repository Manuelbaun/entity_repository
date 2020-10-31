part of entity_repository_generator;

abstract class ParamBase {
  Field field;
  String name;
  InterfaceType type;
  Set<InterfaceType> subTypes = {};

  Map<InterfaceType, AnnotatedClazz> _entityTypes;

  ParamBase({
    this.name,
    this.field,
    this.type,
    Map<InterfaceType, AnnotatedClazz> entityTypes,
  }) : _entityTypes = entityTypes {
    if (type.isDartCoreList || type.isDartCoreSet || type.isDartCoreMap) {
      subTypes = getAllTypes(type).toSet();
    }
  }

  /// The basic imple
  bool get isEntity => _isEntityParam(type);
  bool _isEntityParam(InterfaceType type) {
    final anno = _entityTypes[type];
    return anno != null;
  }

  bool get hasSubType;

  String get stringfy;

  String get toParamInit;

  String get toParamInitThis;

  String get toParamInitPrivate;

  String get toPublicFieldGet;

  String get toPublicField;

  String get toPublicFieldOverride;

  String get toPrivateField;

  String get toGetter;

  String get toSetter;

  String get toPrivateFieldGetterSetter;

  String get toReferenceNameGetter;

  String get toReferenceNamePrivate;

  String get toLookUpMethodName;

  String toLookupMethod();

  String get toReferenceFieldPrivate;

  String get toReferenceFieldGetter;

  bool get containsEntities;

  // general, if set field
  String get mapEntityToIdsRefs;

  /// serialize
  ///
  /// ..writeByte(...)
  /// ..write(...)
  String toSerializeWrite([String prefix = 'obj.']);

  String get toSerializeRead;

  String get toMapEntry;

  String get toMapEntryJson;

  String get toRefsObjects;

  String get toSerializeReadField;

  String get toFieldFromMap;

  @override
  String toString() => toPublicField;
}
