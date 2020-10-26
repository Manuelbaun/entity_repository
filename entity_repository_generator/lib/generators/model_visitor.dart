part of entity_repository_generator;

/// Only default factory constructor is supported and
/// it will be stored in the [ClassParams]
class ModelVisitor extends SimpleElementVisitor {
  ModelVisitor({
    @required this.entityTypes,
    @required this.model,
    @required this.classElement,
  })  : assert(entityTypes != null),
        assert(model != null);

  EntityModel model;

  final ClassElement classElement;

  String get repoName => '${entityName}Repository';

  String get repoNameLowerCase => '${entityName.toLowerCase()}Repository';

  Map<InterfaceType, AnnotatedClazz> entityTypes = {};

  DartType _className;
  String redirectName;

  String get entityName => _className.getDisplayString();
  String get entityNameLowerCase => _className.getDisplayString().toLowerCase();
  String get adapterName => '\$${entityName}Adapter';
  String get referenceClassName => '${redirectName}ReferenceLookUp';

  /// TODO: remove false, when generator is implemented
  bool get generateIndicies => false || model?.index?.isNotEmpty;

  String _sourceCode;

  List<Param> get params => _allParams;
  List<Param> get paramsNonEntity => _nonEnitityParam;
  List<Param> get paramsEntities => _entityParam;
  bool get hasEntityReference => _entityParam.isNotEmpty;

  final _allParams = <Param>[];
  final _nonEnitityParam = <Param>[];
  final _entityParam = <Param>[];

  @override
  void visitConstructorElement(ConstructorElement element) {
    // Check, if the requirements are met
    if (element.type.returnType is! InterfaceType) return;

    final type = element.type.returnType as InterfaceType;

    if (!_checkIfFactoryDefaultConstructor(element)) return;

    _checkIfAbstractClass(type);

    _setSourceCode(element);
    // start generating
    _className = element.type.returnType;
    redirectName = _getRedirectConstructorName(element);

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
        entitiesTypes: entityTypes,
      );

      final res = _isEntityType(p);
      if (res) {
        _entityParam.add(p);
      } else {
        _nonEnitityParam.add(p);
      }

      _allParams.add(p);
    }
  }

  @override
  void visitMethodElement(MethodElement element) {
    /// TODO: copy method to the class and abstract class
  }

  void _setSourceCode(ConstructorElement element) {
    _sourceCode = element.source.contents.data;
  }

  /// This method will find the redirect constructor name of a factory
  /// constructor.
  String _getRedirectConstructorName(ConstructorElement element) {
    final con = _sourceCode.substring(element.nameOffset);
    final name = getRedirectedConstructorName(con);

    // test on rediceted constructor name
    if (name == null || name.isEmpty) {
      throw GeneratorError('Redirected consturctor cannot be null or empty!');
    }
    return name;
  }

  /// This will check, if the constructor is the default factory constructur
  /// all other factory constructors will be ignored
  ///
  /// It throws an error, if element is not a factory constructor
  bool _checkIfFactoryDefaultConstructor(ConstructorElement element) {
    if (element.isDefaultConstructor) {
      if (!element.isFactory) {
        throw GeneratorError('''$element must be a factory constructor!''');
      }
    } else if (element.isFactory) {
      Print.yellow('''[Entity Repository Generator INFO] '''
          '''Ignore $element, as it is not the default factory constructor.''');
    }
    return element.isFactory && element.isDefaultConstructor;
  }

  /// This method ensures, that a class must be abstract
  /// when annotated with [EntityModel] annotation
  void _checkIfAbstractClass(InterfaceType type) {
    /// if abstract, => all good
    if (type.element.isAbstract) return;

    throw GeneratorError('''${type.element} must be an abstract class!''');
  }

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

  bool _testType(InterfaceType type) {
    final anno = entityTypes[type];
    return anno != null;
    // && anno.model.repository;
  }
}
