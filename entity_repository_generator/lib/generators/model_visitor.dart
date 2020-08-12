part of entity_repository_generator;

/// Only default factory constructor is supported and it will be stored in the [Clazz]
class ModelVisitor extends SimpleElementVisitor {
  EntityModel model;
  Map<String, ClassElement> referenceEntities = {};

  Clazz clazz;

  /// TODO: remove false, when generator is implemented
  bool get generateIndicies => false || model.index.isNotEmpty;

  String adapterName;
  DartType className;
  int typeId;
  String get classNaming => className.getDisplayString();
  Map<String, DartType> fields = {};

  Map<String, ConstructorElement> constructors = {};

  // should generete interface with only get fields?
  final onlyGetter = false;

  String _sourceCode;

  @override
  void visitConstructorElement(ConstructorElement element) {
    InterfaceType type;

    if (element.type.returnType is InterfaceType) {
      type = element.type.returnType as InterfaceType;
    } else {
      return;
    }

    _checkIfAbstractClass(type);

    // will only generate for the default constructor
    if (!_checkIfFactoryDefaultConstructor(element)) return;

    className = element.type.returnType;
    adapterName = '\$${className}Adapter';

    clazz = Clazz()
      ..type = element.type.returnType
      ..name = _getRedirectConstructorName(element)
      ..enitiyTypes = referenceEntities;

    final fieldHelper = <int>{};

    for (final par in element.parameters) {
      if (par.displayName == 'id') continue;
      final field = getFieldAnn(par);

      if (!fieldHelper.add(field.index)) {
        throw GeneratorError(
            '''Field number ${field.index} on $par was already used.'''
            ''' Please choose another one.''');
      }

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
      throw GeneratorError('Redirected consturctor cannot be null or empty!');
    }
    return name;
  }

  bool _checkIfFactoryDefaultConstructor(ConstructorElement element) {
    if (element.isDefaultConstructor) {
      if (!element.isFactory) {
        throw GeneratorError('''$element must be a factory constructor!''');
      }
    } else {
      Print.yellow('''[Entity Repository Generator INFO] '''
          '''$element will be ignored, as it is not the default factory constructor.''');
    }
    return element.isFactory && element.isDefaultConstructor;
  }

  /// This method ensures, that a class must be abstract
  /// when annotated with [EntityModel] annotation
  void _checkIfAbstractClass(InterfaceType type) {
    final el = type.element;

    /// if abstract, => all good
    if (el.isAbstract) return;

    throw GeneratorError('''$el must be an abstract class!''');
  }
}
