part of entity_repository_generator;

class ModelVisitor extends SimpleElementVisitor {
  EntityModel model;
  Map<String, ClassElement> referenceEntities = {};

  DartType className;
  int typeId;
  String get classNaming => className.getDisplayString();
  Map<String, DartType> fields = {};

  Map<String, ConstructorElement> constructors = {};

  // should generete interface with only get fields?
  final onlyGetter = false;

  String _sourceCode;

  /// first only default constructor is supported!
  Clazz clazz;

  @override
  void visitConstructorElement(ConstructorElement element) {
    /// First: get classname!
    className = element.type.returnType;

    _checkIfAbstractClass(element);
    _checkIfFactoryDefaultClass(element);

    clazz = Clazz()
      ..type = element.type.returnType
      ..name = _getRedirectConstructorName(element)
      ..enitiyTypes = referenceEntities;

    for (final par in element.parameters) {
      if (par.displayName == 'id') continue;
      final field = getFieldAnn(par);

      final p = Param(
        field: field,
        name: par.displayName,
        type: par.type as InterfaceType,
        entitiesTypes: referenceEntities,
      );

      clazz.add(p);
    }
  }

  String _getRedirectConstructorName(ConstructorElement element) {
    // constructor fields!
    _sourceCode = element.source.contents.data;
    final con = _sourceCode.substring(element.nameOffset);
    final name = getRedirectedConstructorName(con);

    // test on rediceted constructor name
    if (name == null || name.isEmpty) {
      throw AssertionError('Redirected consturctor cannot be null or empty!');
    }
    return name;
  }

  /// TODO: should only be default constructor ???
  void _checkIfFactoryDefaultClass(ConstructorElement element) {
    final isDefault = element.isFactory && element.isDefaultConstructor;

    if (!isDefault) {
      throw UnsupportedError('''${element.location}\n'''
          '''${className.getDisplayString()} must be default factory constructor!''');
    }
  }

  void _checkIfAbstractClass(ConstructorElement element) {
    if (className.element is ClassElement &&
        !(className.element as ClassElement).isAbstract) {
      throw UnsupportedError('''${element.location}\n'''
          '''${className.getDisplayString()} must be an abstract class!''');
    }
  }
}
