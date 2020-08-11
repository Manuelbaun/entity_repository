part of entity_repository_generator;

class Clazz {
  DartType type;
  String name;
  List<Param> params = [];

  final List<Param> _nonEnitityParam = [];
  final List<Param> _entityParam = [];

  List<Param> get paramsNonEntity => _nonEnitityParam;
  List<Param> get paramsEntities => _entityParam;

  Map<String, ClassElement> enitiyTypes = {};

  void add(Param p) {
    final res = _isEntityType(p);
    if (res) {
      _entityParam.add(p);
    } else {
      _nonEnitityParam.add(p);
    }

    params.add(p);
  }

  bool get hasEntityReference => _entityParam.isNotEmpty;

  bool _isEntityType(Param par) {
    if (par.hasSubType) {
      final res = par.subTypes.firstWhere(_testType, orElse: () => null);

      if (res != null) {
        return true;
      }
    } else {
      return _testType(par.type);
    }
    return false;
  }

  bool _testType(InterfaceType type) =>
      enitiyTypes.containsKey(type.getDisplayString());

  String get referenceClassName => '${name}ReferenceLookUp';
}
