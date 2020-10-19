part of entity_repository_generator;

class Param {
  Field field;
  String name;
  InterfaceType type;
  Set<InterfaceType> subTypes = {};
  final Map<InterfaceType, AnnotatedClazz> _entityTypes;

  /// is true, when this param is an entity type
  bool get isEntity => _isEntityParam(type);

  bool _isEntityParam(InterfaceType type) {
    // final name = type.getDisplayString();
    final anno = _entityTypes[type];
    return anno != null;
    //  && anno.model.repository;
    // return _entitiesTypes.containsKey(type);
    // && _entitiesTypes[name].model.repository;
  }

  Param({
    this.name,
    this.field,
    this.type,
    Map<InterfaceType, AnnotatedClazz> entitiesTypes,
  }) : _entityTypes = entitiesTypes {
    if (type.isDartCoreList || type.isDartCoreSet || type.isDartCoreMap) {
      subTypes = getAllTypes(type).toSet();
    }
  }

  bool get hasSubType => subTypes.isNotEmpty;

  String get stringfy {
    if (isEntity) {
      return '$name: \${$toReferenceName}';
    } else if (type.isDartCoreList || type.isDartCoreSet) {
      if (_isEntityParam(subTypes.first)) {
        return '$name: \${$toReferenceName}';
      }
    } else if (type.isDartCoreMap) {
      if (_isEntityParam(subTypes.first) || _isEntityParam(subTypes.last)) {
        return '$name: \${$toReferenceName}';
      } else {
        return '$name: \${$name?.map((key, value) => MapEntry(key, value))}';
      }
    }

    return '$name: \$$name';
  }

  String get toParamInit {
    return '$type $name';
  }

  String get toParamInitThis {
    return 'this.$name';
  }

  /// _[name] = [name]
  String get toParamInitPrivate {
    return '_$name = $name';
  }

  String get toPublicFieldGet {
    return '$type get $name;';
  }

  String get toPublicField {
    return '$type $name;';
  }

  String get toPublicFieldOverride {
    return '@override\n$type $name;';
  }

  String get toPrivateField {
    return '$type _$name;';
  }

  String get toGetter {
    var lookup = isEntity;
    if (subTypes.isNotEmpty) {
      var h1 = false, h2 = false;
      h1 = _isEntityParam(subTypes.first);

      if (subTypes.length > 1) h2 = _isEntityParam(subTypes.last);

      lookup = h1 || h2;
    }

    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('$type get $name => ')
      ..writeln(lookup ? '_$name ??= $toLookUpMethodName;' : '_$name;');

    return buff.toString();
  }

  String get toSetter {
    final buff = StringBuffer()
      ..writeln('@override')
      ..writeln('set $name($type $name) {')
      ..writeln('_$name = $name;');

    if (containsEntities) {
      buff
        ..writeln('$toReferenceName = $mapEntityToIdsRefs;')
        ..writeln('setKeyValue(${field.index}, $toReferenceName);');
    } else {
      buff.writeln('setKeyValue(${field.index}, $name);');
    }

    buff.writeln('}');

    return buff.toString();
  }

  String get toPrivateFieldGetterSetter {
    return '''$toPrivateField'''
        '''\n\n$toGetter'''
        '''\n\n$toSetter \n\n''';
  }

  String get toReferenceName {
    return '${name}Refs';
  }

  String get toLookUpMethodName {
    final upName = name[0].toUpperCase() + name.substring(1);
    return '_lookUp$upName()';
  }

  String toLookupMethod() {
    final typeName = type.getDisplayString();

    String method;

    if (subTypes.isEmpty) {
      if (isEntity) {
        method = '''$type $toLookUpMethodName {
        return locator.get<$typeName>().findOne($toReferenceName);
      }''';
      } else {
        throw Exception(
            'Could not find the Type: $typeName in the entity reference list.');
      }
    } else if (type.isDartCoreList) {
      final enType = subTypes.first;
      method = '''
      $type $toLookUpMethodName {
        if($toReferenceName != null){

          return locator.get<$enType>().findMany($toReferenceName).toList();
        }
        return [];
      }''';
    } else if (type.isDartCoreSet) {
      final enType = subTypes.first;
      method = '''
      $type $toLookUpMethodName {
        if($toReferenceName != null){
          return locator.get<$enType>().findMany($toReferenceName).toSet();
        }
        return {};
      }''';
    } else if (type.isDartCoreMap) {
      final type1 = subTypes.first;
      final type2 = subTypes.last;

      final ass1 = _isEntityParam(type1)
          ? 'locator.get<$type1>().findOne(entry.key)'
          : 'entry.key';

      final ass2 = _isEntityParam(type2)
          ? 'locator.get<$type2>().findOne(entry.value)'
          : 'entry.value';

      method = '''
      $type $toLookUpMethodName {

        if($toReferenceName != null){
          final map = <$type1, $type2>{} ;
          for(final entry in $toReferenceName.entries) {
            final v1 = $ass1;
            final v2 = $ass2;

            map[v1] = v2;
          }

          return map;
        }
        return {};
      }''';
    }

    return method;
  }

  String get toReferenceField {
    var tt = 'String';

    if (type.isDartCoreList) {
      if (_isEntityParam(subTypes.first)) {
        tt = 'List<String>';
      } else {
        tt = 'List<${subTypes.first}>';
      }
    } else if (type.isDartCoreMap) {
      final t1 = _isEntityParam(subTypes.first) ? 'String' : subTypes.first;

      final t2 = _isEntityParam(subTypes.last) ? 'String' : subTypes.last;

      tt = 'Map<$t1, $t2>';
    } else if (type.isDartCoreSet) {
      if (_isEntityParam(subTypes.first)) {
        tt = 'Set<String>';
      } else {
        tt = 'Set<${subTypes.first}>';
      }
    }

    return '$tt $toReferenceName;';
  }

  bool get containsEntities {
    if (type.isDartCoreList && _isEntityParam(subTypes.first)) {
      return true;
    } else if (type.isDartCoreSet && _isEntityParam(subTypes.first)) {
      /// [Set to List]
      return true;
    } else if (type.isDartCoreMap) {
      if (_isEntityParam(subTypes.first) || _isEntityParam(subTypes.last)) {
        return true;
      }
    } else if (isEntity) {
      return true;
    }
    // else
    return false;
  }

  // general, if set field
  String get mapEntityToIdsRefs {
    if (type.isDartCoreList && _isEntityParam(subTypes.first)) {
      return '$name?.map((e) => e.id)?.toList()';
    } else if (type.isDartCoreSet && _isEntityParam(subTypes.first)) {
      /// [Set to List]
      return '$name?.map((e) => e.id)'; //?.toList()';
    } else if (type.isDartCoreMap) {
      final has1 = _isEntityParam(subTypes.first);
      final has2 = _isEntityParam(subTypes.last);
      final t1 = has1 ? 'key.id' : 'key';
      final t2 = has2 ? 'value.id' : 'value';

      if (has1 || has2) {
        return '$name?.map((key, value) => MapEntry($t1, $t2))';
      } else {
        return name;
      }
    } else if (isEntity) {
      return '$name?.id';
    }
    // else
    return name;
  }

  /// serialize
  ///
  /// ..writeByte(...)
  /// ..write(...)
  String toSerializeWrite([String prefix = 'obj.']) {
    String fieldString;

    if ((type.isDartCoreSet || type.isDartCoreList) &&
        _isEntityParam(subTypes.first)) {
      fieldString = toReferenceName;

      if (type.isDartCoreSet) {
        fieldString += '?.toList()';
      }
    } else if (type.isDartCoreMap) {
      final has1 = _isEntityParam(subTypes.first);
      final has2 = _isEntityParam(subTypes.last);

      if (has1 || has2) {
        fieldString = toReferenceName;
      } else {
        fieldString = name;
      }
    } else if (isEntity) {
      fieldString = toReferenceName;
    } else
      fieldString = name;

    return '''..writeByte(${field.index})\n'''
        '''..write($prefix$fieldString)\n''';
  }

  String get toSerializeRead {
    if (type.isDartCoreList) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        return '..$toReferenceName = (fields[${field.index}] as List)?.cast<String>()';
      } else {
        return '..$name = (fields[${field.index}] as List)?.cast<$st>()';
      }
    } else if (type.isDartCoreSet) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        /// [Set to list]
        return '..$toReferenceName = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
      } else {
        /// [Set to list]
        return '..$name = (fields[${field.index}] as List)?.toSet()?.cast<$st>()';
      }
    } else if (type.isDartCoreMap) {
      final enType1 = _isEntityParam(subTypes.first);
      final enType2 = _isEntityParam(subTypes.last);

      final t1 = enType1 ? 'String' : subTypes.first;
      final t2 = enType2 ? 'String' : subTypes.last;

      final fieldName = (enType1 || enType2) ? toReferenceName : name;

      return '..$fieldName = (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
    } else if (isEntity) {
      return '..$toReferenceName = (fields[${field.index}] as String)';
    }

    return '..$name = fields[${field.index}] as $type';
  }

  String get toMapEntry {
    var condition = '$name != null ';
    var str = 'obj[${field.index}] = ';
    if ((type.isDartCoreList || type.isDartCoreSet) &&
        _isEntityParam(subTypes.first)) {
      /// [Set to list] need to convert to list!
      condition += '&& $name.isNotEmpty';
      str += toReferenceName;
    } else if (type.isDartCoreMap) {
      final has1 = _isEntityParam(subTypes.first);
      final has2 = _isEntityParam(subTypes.last);

      if (has1 || has2) {
        condition += '&& $name.isNotEmpty';
        str += toReferenceName;
      } else {
        str += '$name';
      }
    } else if (isEntity) {
      str += toReferenceName;
    } else {
      str += '$name';
    }

    /// apply condition if null or empty=> should not be in the map
    return '''if($condition) {$str;}''';
  }

  String get toRefsObjects {
    final ifString = 'if($name != null && $name.isNotEmpty)';
    try {
      if ((type.isDartCoreList || type.isDartCoreSet) &&
          _isEntityParam(subTypes.first)) {
        ///
        return '$ifString {obj.addAll($name);}';
      } else if (type.isDartCoreMap) {
        final has1 = _isEntityParam(subTypes.first);
        final has2 = _isEntityParam(subTypes.last);

        if (has1 && !has2) return '$ifString {obj.addAll($name.keys);}';
        if (!has1 && has2) return '$ifString {obj.addAll($name.values);}';
        if (has1 && has2) {
          return '$ifString {obj..addAll($name.keys)..addAll($name.values);}';
        }
      } else if (isEntity) {
        return 'if($name != null) obj.add($name);';
      }
    } catch (e) {
      print(e);
    }

    return '';
  }

  String get toSerializeReadField {
    if (type.isDartCoreList) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        return '$toReferenceName: (fields[${field.index}] as List)?.cast<String>()';
      } else {
        return '$name : (fields[${field.index}] as List)?.cast<$st>()';
      }
    } else if (type.isDartCoreSet) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        /// [Set to list]
        return '$toReferenceName: (fields[${field.index}] as List)?.toSet()?.cast<String>()';
      } else {
        /// [Set to list]
        return '$name : (fields[${field.index}] as List)?.toSet()?.cast<$st>()';
      }
    } else if (type.isDartCoreMap) {
      final enType1 = _isEntityParam(subTypes.first);
      final enType2 = _isEntityParam(subTypes.last);

      final t1 = enType1 ? 'String' : subTypes.first;
      final t2 = enType2 ? 'String' : subTypes.last;

      final fieldName = (enType1 || enType2) ? toReferenceName : name;

      return '$fieldName : (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
    } else if (isEntity) {
      return '$toReferenceName : (fields[${field.index}] as String)';
    }

    return '$name : fields[${field.index}] as $type';
  }

  String get toFieldFromMap {
    var str = '';
    if (type.isDartCoreList) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        str =
            '$toReferenceName = (fields[${field.index}] as List)?.cast<String>()';
      } else {
        str = '_$name = (fields[${field.index}] as List)?.cast<$st>()';
      }
    } else if (type.isDartCoreSet) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        str =
            '$toReferenceName = (fields[${field.index}] as List)?.toSet()?.cast<String>()';
      } else {
        str = '_$name = (fields[${field.index}] as List)?.toSet()?.cast<$st>()';
      }
    } else if (type.isDartCoreMap) {
      final enType1 = _isEntityParam(subTypes.first);
      final enType2 = _isEntityParam(subTypes.last);

      final t1 = enType1 ? 'String' : subTypes.first;
      final t2 = enType2 ? 'String' : subTypes.last;

      final fieldName = (enType1 || enType2) ? toReferenceName : '_$name';

      str = '$fieldName = (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
    } else if (isEntity) {
      str = '$toReferenceName = (fields[${field.index}] as String)';
    } else {
      str = '_$name = fields[${field.index}] as $type';
    }

    return 'if(fields.containsKey(${field.index})) { $str; }';
  }

  @override
  String toString() => toPublicField;
}
