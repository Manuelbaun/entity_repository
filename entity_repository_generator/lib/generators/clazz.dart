part of entity_repository_generator;

class Clazz {
  DartType type;
  String name;
  List<Param> params = [];

  final List<Param> _non = [];
  final List<Param> _en = [];

  List<Param> get paramsNonEntity => _non;
  List<Param> get paramsEntities => _en;

  Map<String, ClassElement> enitiyTypes = {};

  void add(Param p) {
    final res = _isEntityType(p);
    if (res) {
      _en.add(p);
    } else {
      _non.add(p);
    }

    params.add(p);
  }

  bool get hasEntityReference => _en.isNotEmpty;

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
