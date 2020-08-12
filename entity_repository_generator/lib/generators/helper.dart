part of entity_repository_generator;

const _fieldChecker = TypeChecker.fromRuntime(Field);
// const _dataModelChecker = TypeChecker.fromRuntime(DataModel);
const entityModelChecker = TypeChecker.fromRuntime(EntityModel);

Field getFieldAnn(Element element) {
  try {
    final obj = _fieldChecker.annotationsOfExact(element)?.first;
    return Field(obj.getField('index').toIntValue());
  } catch (e) {
    throw GeneratorError('''$e
  Could not find a field annotation on constructor parameter $element. 
  Plase provide field annotation\n''');
  }
}

Map<String, ClassElement> checkEntityReference(Element element) {
  final map = <String, ClassElement>{};

  if (element is ClassElement) {
    final alltypes = <InterfaceType>[];

    for (final con in element.constructors) {
      for (final parm in con.parameters) {
        final at = getAllTypes(parm.type);
        alltypes.addAll(at);
      }
    }

    for (final type in alltypes) {
      final res = entityModelChecker.hasAnnotationOf(type.element);

      if (res) {
        map[type.getDisplayString()] = type.element;
      }
    }
  }

  return map;
}

EntityModel getEntityModel(Element element) {
  final obj = entityModelChecker.annotationsOfExact(element)?.first;
  if (obj == null) return null;

  final index = obj
          .getField('index')
          ?.toListValue()
          ?.map((e) => e.toSetValue()?.map((e) => e.toStringValue())?.toSet())
          ?.toList() ??
      <Set<String>>[];

  final repo = obj.getField('repository').toBoolValue();
  final immo = obj.getField('immutable').toBoolValue();
  final typeId = obj.getField('typeId').toIntValue();

  if (typeId < CustomAdapterTypes.maxAdapter) {
    throw GeneratorError(
      '''TypeId of $element is less or equal then ${CustomAdapterTypes.maxAdapter}.'''
      ''' Please increase it.''',
    );
  }
  return EntityModel(
    typeId,
    index: index,
    repository: repo,
    immutable: immo,
  );
}

/// runs through all sub types
List<InterfaceType> getAllTypes(DartType type) {
  final list = <InterfaceType>[];

  if (type is InterfaceType) {
    if (type.typeArguments.isEmpty) {
      list.add(type);
    } else {
      for (final t in type.typeArguments) {
        list.addAll(getAllTypes(t));
      }
    }
  }
  return list;
}

// copied from freezed package

final _redirectedConstructorNameRegexp =
    RegExp(r'^[^;{}]+?=[\s\n\t]*([^<>(){}]+?)(?:<.+?>)*?;', dotAll: true);
String getRedirectedConstructorName(String source) {
  var firstOpeningParenthesisIndex = 0;
  while (firstOpeningParenthesisIndex < source.length &&
      source[firstOpeningParenthesisIndex] != '(') {
    firstOpeningParenthesisIndex++;
  }

  var parenthesisOpened = 1;
  var constructorInitializerIndex = firstOpeningParenthesisIndex + 1;
  while (constructorInitializerIndex < source.length && parenthesisOpened > 0) {
    if (source[constructorInitializerIndex] == '(') {
      parenthesisOpened++;
    }
    if (source[constructorInitializerIndex] == ')') {
      parenthesisOpened--;
    }
    constructorInitializerIndex++;
  }

  if (constructorInitializerIndex >= source.length) return null;

  return _redirectedConstructorNameRegexp
      .firstMatch(source.substring(constructorInitializerIndex))
      ?.group(1);
}

bool filterHasNotAnnotationOfModel(ParameterElement e) {
  return !filterHasAnnotationOfModel(e);
}

bool filterHasAnnotationOfModel(ParameterElement e) {
  if (e.type is InterfaceType) {
    final it = e.type as InterfaceType;

    for (final v in it.typeArguments) {
      if (v.element is ClassElement) {
        final dec = (v.element as ClassElement).declaration;

        if (entityModelChecker.hasAnnotationOf(dec)) {
          return true;
        }
      }
    }
  }
  return false;
}

extension TypeX on Type {
  String get $name {
    final str = toString();
    final str2 = str.split('<');
    return str2[0];
  }
}
