part of entity_repository_generator;

// const TYPE_CHECKER_ON_FIELD = TypeChecker.fromRuntime(Field);

// const TYPE_CHECKER_ENTITY_MODEL = TypeChecker.fromRuntime(EntityModel);

// final ALL_ENTITES = <InterfaceType, AnnotatedClazz>{};
// final ALL_ENTITY_MODELS = <int, EntityModel>{};
// final ALL_ENTITY_MODEL_ELEMENTS = <int, Element>{};

// Field getFieldAnn(Element element) {
//   try {
//     final obj = TYPE_CHECKER_ON_FIELD.annotationsOfExact(element)?.first;
//     return Field(obj.getField('index').toIntValue());
//   } catch (e) {
//     throw GeneratorError('''$e
//   Could not find a field annotation on constructor parameter $element.
//   Plase provide field annotation\n''');
//   }
// }

// Map<InterfaceType, AnnotatedClazz> getAllEntityModelReferences(
//     Element element) {
//   if (element is ClassElement) {
//     final alltypes = <InterfaceType>[];

//     for (final con in element.constructors) {
//       for (final parm in con.parameters) {
//         final at = getAllTypes(parm.type);
//         alltypes.addAll(at);
//       }
//     }

//     for (final type in alltypes) {
//       final res = TYPE_CHECKER_ENTITY_MODEL.hasAnnotationOf(type.element);

//       if (res) {
//         final meta = getEntityModel(type.element, addGlobal: false);

//         ALL_ENTITES[type] = AnnotatedClazz(
//           type: type,
//           element: type.element,
//           model: meta,
//         );
//       }
//     }
//   }

//   return ALL_ENTITES;
// }

// EntityModel getEntityModel(Element element, {bool addGlobal = true}) {
//   final res = TYPE_CHECKER_ENTITY_MODEL.annotationsOfExact(element);
//   if (res.isEmpty) return null;

//   if (res.length > 1) {
//     throw GeneratorError('$element has more then one EntityModel annotation.');
//   }

//   final obj = res?.first;
//   final typeId = obj.getField('typeId').toIntValue();

//   /// if typeId already exists, just return
//   if (!addGlobal && ALL_ENTITY_MODELS[typeId] != null) {
//     return ALL_ENTITY_MODELS[typeId];
//   }

//   final index = obj
//           .getField('index')
//           ?.toListValue()
//           ?.map((e) => e.toSetValue()?.map((e) => e.toStringValue())?.toSet())
//           ?.toList() ??
//       <Set<String>>[];

//   final repo = obj.getField('repository').toBoolValue();
//   final immo = obj.getField('immutable').toBoolValue();

//   if (typeId < CustomAdapterTypes.maxAdapter) {
//     throw GeneratorError(
//       '''TypeId of $element is less or equal then ${CustomAdapterTypes.maxAdapter}.'''
//       ''' Please increase it.''',
//     );
//   }

//   final entityModel = EntityModel(
//     typeId,
//     index: index,
//     repository: repo,
//     immutable: immo,
//   );

//   if (addGlobal) {
//     /// throws error, if the typeid was previously used
//     if (ALL_ENTITY_MODEL_ELEMENTS[typeId] != null &&
//         ALL_ENTITY_MODEL_ELEMENTS[typeId] != element) {
//       final em = ALL_ENTITY_MODEL_ELEMENTS[typeId];
//       throw GeneratorError(
//         '''TypeId $typeId of $element is already in use of the $em''',
//       );
//     }

//     ALL_ENTITY_MODELS[typeId] = entityModel;
//     ALL_ENTITY_MODEL_ELEMENTS[typeId] = element;
//   }

//   return entityModel;
// }

// // bool testIfIsOrHasEntites(DartType type) {
// //   ALL_ENTITES;
// //   //
// // }

// bool isEntityType(InterfaceType type) {
//   return ALL_ENTITES[type] != null;
// }

// /// runs through all sub types
// /// TODO: Fix me one day, this does not work properly!!!!
// List<InterfaceType> getAllTypes(DartType type) {
//   final list = <InterfaceType>[];

//   if (type is InterfaceType) {
//     if (type.typeArguments.isEmpty) {
//       list.add(type);
//     } else {
//       for (final t in type.typeArguments) {
//         final subs = getAllTypes(t);
//         list.addAll(subs);
//       }
//     }
//   }
//   return list;
// }

// // copied from freezed package

// final _redirectedConstructorNameRegexp =
//     RegExp(r'^[^;{}]+?=[\s\n\t]*([^<>(){}]+?)(?:<.+?>)*?;', dotAll: true);

// String getRedirectedConstructorName(String source) {
//   var firstOpeningParenthesisIndex = 0;
//   while (firstOpeningParenthesisIndex < source.length &&
//       source[firstOpeningParenthesisIndex] != '(') {
//     firstOpeningParenthesisIndex++;
//   }

//   var parenthesisOpened = 1;
//   var constructorInitializerIndex = firstOpeningParenthesisIndex + 1;
//   while (constructorInitializerIndex < source.length && parenthesisOpened > 0) {
//     if (source[constructorInitializerIndex] == '(') {
//       parenthesisOpened++;
//     }
//     if (source[constructorInitializerIndex] == ')') {
//       parenthesisOpened--;
//     }
//     constructorInitializerIndex++;
//   }

//   if (constructorInitializerIndex >= source.length) return null;

//   return _redirectedConstructorNameRegexp
//       .firstMatch(source.substring(constructorInitializerIndex))
//       ?.group(1);
// }

// bool filterHasNotAnnotationOfModel(ParameterElement e) {
//   return !filterHasAnnotationOfModel(e);
// }

// bool filterHasAnnotationOfModel(ParameterElement e) {
//   if (e.type is InterfaceType) {
//     final it = e.type as InterfaceType;

//     for (final v in it.typeArguments) {
//       if (v.element is ClassElement) {
//         final dec = (v.element as ClassElement).declaration;

//         if (TYPE_CHECKER_ENTITY_MODEL.hasAnnotationOf(dec)) {
//           return true;
//         }
//       }
//     }
//   }
//   return false;
// }

extension TypeX on Type {
  String get $name {
    final str = toString();
    final str2 = str.split('<');
    return str2[0];
  }
}

extension on String {
  String capitalize() {
    return this[0].toUpperCase() + this.substring(1);
  }
}

class Helper {
  static const TYPE_CHECKER_FIELD = TypeChecker.fromRuntime(Field);
  static const TYPE_CHECKER_ENTITY_MODEL = TypeChecker.fromRuntime(EntityModel);

  static final ALL_ENTITES = <InterfaceType, AnnotatedClazz>{};
  static final ALL_ENTITY_MODELS = <int, EntityModel>{};
  static final ALL_ENTITY_MODEL_ELEMENTS = <int, Element>{};

  static bool hasEntityModelAnnotation(ClassElement e) {
    return TYPE_CHECKER_ENTITY_MODEL.hasAnnotationOf(e);
  }

  static Field getFieldAnn(Element element) {
    try {
      final obj = TYPE_CHECKER_FIELD.annotationsOfExact(element)?.first;
      return Field(obj.getField('index').toIntValue());
    } catch (e) {
      throw GeneratorError('''$e
  Could not find a field annotation on constructor parameter $element.
  Plase provide field annotation\n''');
    }
  }

  static Map<InterfaceType, AnnotatedClazz> getAllEntityModelReferences(
      Element element) {
    if (element is ClassElement) {
      final alltypes = <InterfaceType>[];

      for (final con in element.constructors) {
        for (final parm in con.parameters) {
          final at = getAllTypes(parm.type);
          alltypes.addAll(at);
        }
      }

      for (final type in alltypes) {
        final res = TYPE_CHECKER_ENTITY_MODEL.hasAnnotationOf(type.element);

        if (res) {
          final meta = getEntityModel(type.element, addGlobal: false);

          ALL_ENTITES[type] = AnnotatedClazz(
            type: type,
            element: type.element,
            model: meta,
          );
        }
      }
    }

    return ALL_ENTITES;
  }

  static EntityModel getEntityModel(Element element, {bool addGlobal = true}) {
    final res = TYPE_CHECKER_ENTITY_MODEL.annotationsOfExact(element);
    if (res.isEmpty) return null;

    if (res.length > 1) {
      throw GeneratorError(
          '$element has more then one EntityModel annotation.');
    }

    final obj = res?.first;
    final typeId = obj.getField('typeId').toIntValue();

    /// if typeId already exists, just return
    if (!addGlobal && ALL_ENTITY_MODELS[typeId] != null) {
      return ALL_ENTITY_MODELS[typeId];
    }

    final index = obj
            .getField('index')
            ?.toListValue()
            ?.map((e) => e.toSetValue()?.map((e) => e.toStringValue())?.toSet())
            ?.toList() ??
        <Set<String>>[];

    final repo = obj.getField('repository').toBoolValue();
    final immo = obj.getField('immutable').toBoolValue();

    if (typeId < CustomAdapterTypes.maxAdapter) {
      throw GeneratorError(
        '''TypeId of $element is less or equal then ${CustomAdapterTypes.maxAdapter}.'''
        ''' Please increase it.''',
      );
    }

    final entityModel = EntityModel(
      typeId,
      index: index,
      repository: repo,
      immutable: immo,
    );

    if (addGlobal) {
      /// throws error, if the typeid was previously used
      if (ALL_ENTITY_MODEL_ELEMENTS[typeId] != null &&
          ALL_ENTITY_MODEL_ELEMENTS[typeId] != element) {
        final em = ALL_ENTITY_MODEL_ELEMENTS[typeId];
        throw GeneratorError(
          '''TypeId $typeId of $element is already in use of the $em''',
        );
      }

      ALL_ENTITY_MODELS[typeId] = entityModel;
      ALL_ENTITY_MODEL_ELEMENTS[typeId] = element;
    }

    return entityModel;
  }

  static bool testIfIsOrHasEntites(DartType type) {
    ALL_ENTITES;
    //
  }

  static bool isEntityType(InterfaceType type) {
    return ALL_ENTITES[type] != null;
  }

  /// runs through all sub types
  /// TODO: Fix me one day, this does not work properly!!!!
  static List<InterfaceType> getAllTypes(DartType type) {
    final list = <InterfaceType>[];

    if (type is InterfaceType) {
      if (type.typeArguments.isEmpty) {
        list.add(type);
      } else {
        for (final t in type.typeArguments) {
          final subs = getAllTypes(t);
          list.addAll(subs);
        }
      }
    }
    return list;
  }

  static final _redirectedConstructorNameRegexp =
      RegExp(r'^[^;{}]+?=[\s\n\t]*([^<>(){}]+?)(?:<.+?>)*?;', dotAll: true);

  static String getRedirectedConstructorName(String source) {
    var firstOpeningParenthesisIndex = 0;
    while (firstOpeningParenthesisIndex < source.length &&
        source[firstOpeningParenthesisIndex] != '(') {
      firstOpeningParenthesisIndex++;
    }

    var parenthesisOpened = 1;
    var constructorInitializerIndex = firstOpeningParenthesisIndex + 1;
    while (
        constructorInitializerIndex < source.length && parenthesisOpened > 0) {
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

  static bool filterHasNotAnnotationOfModel(ParameterElement e) {
    return !filterHasAnnotationOfModel(e);
  }

  static bool filterHasAnnotationOfModel(ParameterElement e) {
    if (e.type is InterfaceType) {
      final it = e.type as InterfaceType;

      for (final v in it.typeArguments) {
        if (v.element is ClassElement) {
          final dec = (v.element as ClassElement).declaration;

          if (TYPE_CHECKER_ENTITY_MODEL.hasAnnotationOf(dec)) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
