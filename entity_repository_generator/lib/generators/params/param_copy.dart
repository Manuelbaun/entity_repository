// part of entity_repository_generator;

// class ParamCopy extends ParamBase {
//   ParamCopy({
//     String name,
//     Field field,
//     InterfaceType type,
//     Map<InterfaceType, AnnotatedClazz> entitiesTypes,
//   }) : super(
//             paramName: name,
//             field: field,
//             type: type,
//             entityTypes: entitiesTypes) {
//     if (type.isDartCoreList || type.isDartCoreSet || type.isDartCoreMap) {
//       subTypes = getAllTypes(type).toSet();
//     }
//   }

//   // not in base class, should actually be in the extended classes
//   Set<InterfaceType> subTypes = {};

//   /// is true, when this param is an entity type
//   bool get isEntity => _isEntityParam(type);

//   bool _isEntityParam(InterfaceType type) {
//     final anno = entityTypes[type];
//     return anno != null;
//   }

//   bool get hasSubType => subTypes.isNotEmpty;

//   String get stringfy {
//     if (isEntity) {
//       return '$paramName: \${$toRefNameGetter}';
//     } else if (type.isDartCoreList || type.isDartCoreSet) {
//       if (_isEntityParam(subTypes.first)) {
//         return '$paramName: \${$toRefNameGetter}';
//       }
//     } else if (type.isDartCoreMap) {
//       if (_isEntityParam(subTypes.first) || _isEntityParam(subTypes.last)) {
//         return '$paramName: \${$toRefNameGetter}';
//       } else {
//         return '$paramName: \${$paramName?.map((key, value) => MapEntry(key, value))}';
//       }
//     }

//     return '$paramName: \$$paramName';
//   }

//   String get toParamInit {
//     return '$type $paramName';
//   }

//   String get paramNameThis {
//     return 'this.$paramName';
//   }

//   /// _[paramName] = [paramName]
//   String get toParamInitPrivate {
//     return '_$paramName = $paramName';
//   }

//   String get toPublicFieldGet {
//     return '$type get $paramName;';
//   }

//   String get toPublicField {
//     return '$type $paramName;';
//   }

//   String get toPublicFieldOverride {
//     return '@override\n$type $paramName;';
//   }

//   String get toPrivateField {
//     return '$type _$paramName;';
//   }

//   String get toGetter {
//     var lookup = isEntity;
//     if (subTypes.isNotEmpty) {
//       var h1 = false, h2 = false;
//       h1 = _isEntityParam(subTypes.first);

//       if (subTypes.length > 1) h2 = _isEntityParam(subTypes.last);

//       lookup = h1 || h2;
//     }

//     final buff = StringBuffer()
//       ..writeln('@override')
//       ..writeln('$type get $paramName => ')
//       ..writeln(
//           lookup ? '_$paramName ??= $toLookUpMethodName;' : '_$paramName;');

//     return buff.toString();
//   }

//   String get toSetter {
//     final buff = StringBuffer()
//       ..writeln('@override')
//       ..writeln('set $paramName($type $paramName) {')
//       ..writeln('_$paramName = $paramName;');

//     if (containsEntities) {
//       buff
//         ..writeln('$_toRefName = $toRefIdIfExist;')
//         ..writeln('setKeyValue(${field.index}, $_toRefName);');
//     } else {
//       buff.writeln('setKeyValue(${field.index}, $paramName);');
//     }

//     buff.writeln('}');

//     return buff.toString();
//   }

//   String get toPrivateFieldGetterSetter {
//     return '''$toPrivateField'''
//         '''\n\n$toGetter'''
//         '''\n\n$toSetter \n\n''';
//   }

//   String get toRefNameGetter {
//     return '${paramName}Refs';
//   }

//   String get _toRefName {
//     return '_${paramName}Refs';
//   }

//   String get toLookUpMethodName {
//     final upName = paramName[0].toUpperCase() + paramName.substring(1);
//     return '_lookUp$upName()';
//   }

//   String toLookupMethod() {
//     final typeName = type.getDisplayString();

//     String method;

//     if (subTypes.isEmpty) {
//       if (isEntity) {
//         method = '''$type $toLookUpMethodName {
//         return locator.get<$typeName>().findOne($_toRefName);
//       }''';
//       } else {
//         throw Exception(
//             'Could not find the Type: $typeName in the entity reference list.');
//       }
//     } else if (type.isDartCoreList) {
//       final enType = subTypes.first;
//       method = '''
//       $type $toLookUpMethodName {
//         if($_toRefName != null){

//           return locator.get<$enType>().findMany($_toRefName).toList();
//         }
//         return [];
//       }''';
//     } else if (type.isDartCoreSet) {
//       final enType = subTypes.first;
//       method = '''
//       $type $toLookUpMethodName {
//         if($_toRefName != null){
//           return locator.get<$enType>().findMany($_toRefName).toSet();
//         }
//         return {};
//       }''';
//     } else if (type.isDartCoreMap) {
//       final type1 = subTypes.first;
//       final type2 = subTypes.last;

//       final ass1 = _isEntityParam(type1)
//           ? 'locator.get<$type1>().findOne(entry.key)'
//           : 'entry.key';

//       final ass2 = _isEntityParam(type2)
//           ? 'locator.get<$type2>().findOne(entry.value)'
//           : 'entry.value';

//       method = '''
//       $type $toLookUpMethodName {

//         if($_toRefName != null){
//           final map = <$type1, $type2>{} ;
//           for(final entry in $_toRefName.entries) {
//             final v1 = $ass1;
//             final v2 = $ass2;

//             map[v1] = v2;
//           }

//           return map;
//         }
//         return {};
//       }''';
//     }

//     return method;
//   }

//   String get toRefField_ {
//     var tt = 'String';

//     if (type.isDartCoreList) {
//       if (_isEntityParam(subTypes.first)) {
//         tt = 'List<String>';
//       } else {
//         tt = 'List<${subTypes.first}>';
//       }
//     } else if (type.isDartCoreMap) {
//       final t1 = _isEntityParam(subTypes.first) ? 'String' : subTypes.first;

//       final t2 = _isEntityParam(subTypes.last) ? 'String' : subTypes.last;

//       tt = 'Map<$t1, $t2>';
//     } else if (type.isDartCoreSet) {
//       if (_isEntityParam(subTypes.first)) {
//         tt = 'Set<String>';
//       } else {
//         tt = 'Set<${subTypes.first}>';
//       }
//     }

//     return '$tt $_toRefName;';
//   }

//   String get toRefFieldGetter {
//     var tt = 'String';

//     if (type.isDartCoreList) {
//       if (_isEntityParam(subTypes.first)) {
//         tt = 'List<String>';
//       } else {
//         tt = 'List<${subTypes.first}>';
//       }
//     } else if (type.isDartCoreMap) {
//       final t1 = _isEntityParam(subTypes.first) ? 'String' : subTypes.first;

//       final t2 = _isEntityParam(subTypes.last) ? 'String' : subTypes.last;

//       tt = 'Map<$t1, $t2>';
//     } else if (type.isDartCoreSet) {
//       if (_isEntityParam(subTypes.first)) {
//         tt = 'Set<String>';
//       } else {
//         tt = 'Set<${subTypes.first}>';
//       }
//     }

//     return '$tt get $toRefNameGetter => $_toRefName ??= $toRefIdIfExist;';
//   }

//   bool get containsEntities {
//     if (type.isDartCoreList && _isEntityParam(subTypes.first)) {
//       return true;
//     } else if (type.isDartCoreSet && _isEntityParam(subTypes.first)) {
//       /// [Set to List]
//       return true;
//     } else if (type.isDartCoreMap) {
//       if (_isEntityParam(subTypes.first) || _isEntityParam(subTypes.last)) {
//         return true;
//       }
//     } else if (isEntity) {
//       return true;
//     }
//     // else
//     return false;
//   }

//   // general, if set field
//   String get toRefIdIfExist {
//     if (type.isDartCoreList && _isEntityParam(subTypes.first)) {
//       return '$paramName?.map((e) => e.id)?.toList()';
//     } else if (type.isDartCoreSet && _isEntityParam(subTypes.first)) {
//       /// [Set to List]
//       return '$paramName?.map((e) => e.id)'; //?.toList()';
//     } else if (type.isDartCoreMap) {
//       final has1 = _isEntityParam(subTypes.first);
//       final has2 = _isEntityParam(subTypes.last);
//       final t1 = has1 ? 'key.id' : 'key';
//       final t2 = has2 ? 'value.id' : 'value';

//       if (has1 || has2) {
//         return '$paramName?.map((key, value) => MapEntry($t1, $t2))';
//       } else {
//         return paramName;
//       }
//     } else if (isEntity) {
//       return '$paramName?.id';
//     }
//     // else
//     return paramName;
//   }

//   /// serialize
//   ///
//   /// ..writeByte(...)
//   /// ..write(...)
//   String toSerializeWrite([String prefix = 'obj.']) {
//     String fieldString;

//     if ((type.isDartCoreSet || type.isDartCoreList) &&
//         _isEntityParam(subTypes.first)) {
//       fieldString = toRefNameGetter;

//       if (type.isDartCoreSet) {
//         fieldString += '?.toList()';
//       }
//     } else if (type.isDartCoreMap) {
//       final has1 = _isEntityParam(subTypes.first);
//       final has2 = _isEntityParam(subTypes.last);

//       if (has1 || has2) {
//         fieldString = toRefNameGetter;
//       } else {
//         fieldString = paramName;
//       }
//     } else if (isEntity) {
//       fieldString = toRefNameGetter;
//     } else
//       fieldString = paramName;

//     return '''..writeByte(${field.index})\n'''
//         '''..write($prefix$fieldString)\n''';
//   }

//   String get toSerializeRead {
//     if (type.isDartCoreList) {
//       final st = subTypes.first;

//       if (_isEntityParam(st)) {
//         return '..$_toRefName = (fields[${field.index}] as List)?.cast<String>()';
//       } else {
//         return '..$paramName = (fields[${field.index}] as List)?.cast<$st>()';
//       }
//     } else if (type.isDartCoreSet) {
//       final st = subTypes.first;

//       if (_isEntityParam(st)) {
//         /// [Set to list]
//         return '..$_toRefName = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
//       } else {
//         /// [Set to list]
//         return '..$paramName = (fields[${field.index}] as List)?.toSet()?.cast<$st>()';
//       }
//     } else if (type.isDartCoreMap) {
//       final enType1 = _isEntityParam(subTypes.first);
//       final enType2 = _isEntityParam(subTypes.last);

//       final t1 = enType1 ? 'String' : subTypes.first;
//       final t2 = enType2 ? 'String' : subTypes.last;

//       final fieldName = (enType1 || enType2) ? _toRefName : paramName;

//       return '..$fieldName = (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
//     } else if (isEntity) {
//       return '..$_toRefName = (fields[${field.index}] as String)';
//     }

//     return '..$paramName = fields[${field.index}] as $type';
//   }

//   String get toMapEntry {
//     var condition = '$paramName != null ';
//     var str = 'obj[${field.index}] = ';

//     if ((type.isDartCoreList || type.isDartCoreSet) &&
//         _isEntityParam(subTypes.first)) {
//       /// [Set to list] need to convert to list!
//       condition += '&& $paramName.isNotEmpty';
//       str += toRefNameGetter;
//     } else if (type.isDartCoreMap) {
//       final has1 = _isEntityParam(subTypes.first);
//       final has2 = _isEntityParam(subTypes.last);

//       if (has1 || has2) {
//         condition += '&& $paramName.isNotEmpty';
//         str += toRefNameGetter;
//       } else {
//         str += paramName;
//       }
//     } else if (isEntity) {
//       str += toRefNameGetter;
//     } else {
//       str += paramName;
//     }

//     /// apply condition if null or empty=> should not be in the map
//     return '''if($condition) {$str;}''';
//   }

//   String get toMapEntryJson {
//     var condition = '$paramName != null ';
//     var str = "obj['$paramName'] = ";

//     if ((type.isDartCoreList || type.isDartCoreSet) &&
//         _isEntityParam(subTypes.first)) {
//       /// [Set to list] need to convert to list!
//       condition += '&& $paramName.isNotEmpty';
//       str += toRefNameGetter;
//     } else if (type.isDartCoreMap) {
//       final has1 = _isEntityParam(subTypes.first);
//       final has2 = _isEntityParam(subTypes.last);

//       if (has1 || has2) {
//         condition += '&& $paramName.isNotEmpty';
//         str += toRefNameGetter;
//       } else {
//         str += paramName;
//       }
//     } else if (isEntity) {
//       str += toRefNameGetter;
//     } else {
//       str += paramName;
//     }

//     /// apply condition if null or empty=> should not be in the map
//     return '''if($condition) {$str;}''';
//   }

//   String get toRefsObjects {
//     final ifString = 'if($paramName != null && $paramName.isNotEmpty)';
//     try {
//       if ((type.isDartCoreList || type.isDartCoreSet) &&
//           _isEntityParam(subTypes.first)) {
//         ///
//         return '$ifString {obj.addAll($paramName);}';
//       } else if (type.isDartCoreMap) {
//         final has1 = _isEntityParam(subTypes.first);
//         final has2 = _isEntityParam(subTypes.last);

//         if (has1 && !has2) return '$ifString {obj.addAll($paramName.keys);}';
//         if (!has1 && has2) return '$ifString {obj.addAll($paramName.values);}';
//         if (has1 && has2) {
//           return '$ifString {obj..addAll($paramName.keys)..addAll($paramName.values);}';
//         }
//       } else if (isEntity) {
//         return 'if($paramName != null) obj.add($paramName);';
//       }
//     } catch (e) {
//       print(e);
//     }

//     return '';
//   }

//   String get toSerializeReadField {
//     if (type.isDartCoreList) {
//       final st = subTypes.first;

//       if (_isEntityParam(st)) {
//         return '$toRefNameGetter: (fields[${field.index}] as List)?.cast<String>()';
//       } else {
//         return '$paramName : (fields[${field.index}] as List)?.cast<$st>()';
//       }
//     } else if (type.isDartCoreSet) {
//       final st = subTypes.first;

//       if (_isEntityParam(st)) {
//         /// [Set to list]
//         return '$toRefNameGetter: (fields[${field.index}] as List)?.toSet()?.cast<String>()';
//       } else {
//         /// [Set to list]
//         return '$paramName : (fields[${field.index}] as List)?.toSet()?.cast<$st>()';
//       }
//     } else if (type.isDartCoreMap) {
//       final enType1 = _isEntityParam(subTypes.first);
//       final enType2 = _isEntityParam(subTypes.last);

//       final t1 = enType1 ? 'String' : subTypes.first;
//       final t2 = enType2 ? 'String' : subTypes.last;

//       final fieldName = (enType1 || enType2) ? toRefNameGetter : paramName;

//       return '$fieldName : (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
//     } else if (isEntity) {
//       return '$toRefNameGetter : (fields[${field.index}] as String)';
//     }

//     return '$paramName : fields[${field.index}] as $type';
//   }

//   String get toFieldFromMap {
//     var str = '';
//     if (type.isDartCoreList) {
//       final st = subTypes.first;

//       if (_isEntityParam(st)) {
//         str = '$_toRefName = (fields[${field.index}] as List)?.cast<String>()';
//       } else {
//         str = '_$paramName = (fields[${field.index}] as List)?.cast<$st>()';
//       }
//     } else if (type.isDartCoreSet) {
//       final st = subTypes.first;

//       if (_isEntityParam(st)) {
//         str =
//             '$_toRefName = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
//       } else {
//         str =
//             '_$paramName = (fields[${field.index}] as List)?.toSet()?.cast<$st>()';
//       }
//     } else if (type.isDartCoreMap) {
//       final enType1 = _isEntityParam(subTypes.first);
//       final enType2 = _isEntityParam(subTypes.last);

//       final t1 = enType1 ? 'String' : subTypes.first;
//       final t2 = enType2 ? 'String' : subTypes.last;

//       final fieldName = (enType1 || enType2) ? _toRefName : '_$paramName';

//       str = '$fieldName = (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
//     } else if (isEntity) {
//       str = '$_toRefName = (fields[${field.index}] as String)';
//     } else {
//       str = '_$paramName = fields[${field.index}] as $type';
//     }

//     return 'if(fields.containsKey(${field.index})) { $str; }';
//   }

//   @override
//   String toString() => toPublicField;
// }
