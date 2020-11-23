part of entity_repository_generator;

/// Only default factory constructor is supported and
/// it will be stored in the [ClassParams]
class ModelVisitor extends SimpleElementVisitor {
  ModelVisitor({
    this.entityTypes,
    this.model,
    this.classElement,
  })  : assert(entityTypes != null),
        assert(model != null);

  EntityModel model;

  final ClassElement classElement;

  String get repoName => '${entityName}Repository';

  String get repoNameLowerCase => '${entityName.toLowerCase()}Repository';

  Map<InterfaceType, AnnotatedClazz> entityTypes = {};

  DartType _className;
  String redirectName;

  /// TODO: change, nullableSuffix is *
  String get entityName => _className.getDisplayString(withNullability: false);
  String get entityNameLowerCase => entityName.toLowerCase();
  String get adapterName => '\$${entityName}Adapter';
  String get referenceClassName => '${redirectName}ReferenceLookUp';

  /// TODO: remove false, when generator is implemented
  bool get generateIndicies => false; //|| model?.index?.isNotEmpty;

  String _sourceCode;

  List<ParamBase> get params => _allParams;
  List<ParamBase> get paramsNonEntity => _nonEnitityParam;
  List<ParamBase> get paramsEntities => _entityParam;
  bool get hasEntityReference => _entityParam.isNotEmpty;

  final _allParams = <ParamBase>[];
  final _nonEnitityParam = <ParamBase>[];
  final _entityParam = <ParamBase>[];

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
      final field = Helper.getFieldAnn(par);

      if (!fieldHelper.add(field.index)) {
        throw GeneratorError(
            '''Field number ${field.index} on $par was already used.'''
            ''' Please choose another one.''');
      }

      print(par.declaration);

      final p = ParamBase.genericFactory(
        field: field,
        entityTypes: entityTypes,
        parameter: par,
      );

      // final res = _isEntityType(p);

      if (p.isOrHasEntities) {
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
    final name = Helper.getRedirectedConstructorName(con);

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
      log.info(ColorPrint.toYellow('''[Entity Repository Generator] '''
          '''Ignore $element, as it is not the default factory constructor.'''));
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
}
