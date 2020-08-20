part of entity_repository_generator;

class Param {
  Field field;
  String name;
  InterfaceType type;
  Set<InterfaceType> subTypes = {};
  final Map<InterfaceType, AnnotatedClazz> _entityTypes;

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
    if (_isEntityParam(type)) {
      return '$name: \${$name?.id}';
    } else if (type.isDartCoreList || type.isDartCoreSet) {
      if (_isEntityParam(subTypes.first)) {
        return '$name: \${$name.map((e) => e.id)})';
      }
    } else if (type.isDartCoreMap) {
      final ass1 = _isEntityParam(subTypes.first) ? 'key.id' : 'key';
      final ass2 = _isEntityParam(subTypes.last) ? 'value.id' : 'value';

      return '$name: \${$name.map((key, value) => MapEntry($ass1, $ass2))}';
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
    return '@override\n $type get $name => _$name ??= $toLookUpMethodName;';
  }

  String get toSetter {
    return '@override\n set $name($type $name) => _$name = $name;';
  }

  String get toLookUpMethodName {
    final upName = name[0].toUpperCase() + name.substring(1);
    return '_lookUp$upName()';
  }

  String toLookupMethod() {
    final typeName = type.getDisplayString();

    String method;

    if (subTypes.isEmpty) {
      if (_isEntityParam(type)) {
        method = '''$type $toLookUpMethodName {
        return ${(ReferenceLookUp).$name}.findOne<$typeName>($toReferenceName);
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
          return ${(ReferenceLookUp).$name}.findMany<$enType>($toReferenceName).toList();
        }
        return [];
      }''';
    } else if (type.isDartCoreSet) {
      final enType = subTypes.first;
      method = '''
      $type $toLookUpMethodName {
        if($toReferenceName != null){
          return ${(ReferenceLookUp).$name}.findMany<$enType>($toReferenceName).toSet();
        }
        return {};
      }''';
    } else if (type.isDartCoreMap) {
      final type1 = subTypes.first;
      final type2 = subTypes.last;

      final ass1 = _isEntityParam(type1)
          ? '${(ReferenceLookUp).$name}.findOne<$type1>(entry.key)'
          : 'entry.key';

      final ass2 = _isEntityParam(type2)
          ? '${(ReferenceLookUp).$name}.findOne<$type2>(entry.value)'
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

  String get toGetSetPrivate {
    return '''\n\n$toGetter \n\n$toSetter\n\n$toPrivateField''';
  }

  String get toReferenceName {
    return '${name}Refs';
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

  /// serialize
  ///
  /// ..writeByte(...)
  /// ..write(...)
  String get toSerializeWrite {
    var str = '..writeByte(${field.index})\n..';
    if (type.isDartCoreList && _isEntityParam(subTypes.first)) {
      str += 'write(obj.$name?.map((e) => e.id)?.toList())';
    } else if (type.isDartCoreSet && _isEntityParam(subTypes.first)) {
      str += 'write(obj.$name?.map((e) => e.id)?.toSet())';
    } else if (type.isDartCoreMap) {
      final has1 = _isEntityParam(subTypes.first);
      final has2 = _isEntityParam(subTypes.last);
      final t1 = has1 ? 'key.id' : 'key';
      final t2 = has2 ? 'value.id' : 'value';

      if (has1 || has2) {
        str += 'write(obj.$name?.map((key, value) => MapEntry($t1, $t2)))';
      } else {
        str += 'write(obj.$name)';
      }
    } else if (_isEntityParam(type)) {
      str += 'write(obj.$name?.id)';
    } else {
      str += 'write(obj.$name)';
    }

    return str;
  }

  String get toSerializeRead {
    if (type.isDartCoreList) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        return '..$toReferenceName = (fields[${field.index}] as List)?.cast<String>()';
      } else {
        // .songIds = (fields[0] as List)?.cast<String>()
        return '..$name = (fields[${field.index}] as List)?.cast<$st>()';
      }
    } else if (type.isDartCoreSet) {
      final st = subTypes.first;

      if (_isEntityParam(st)) {
        return '..$toReferenceName = (fields[${field.index}] as Set)?.cast<String>()';
      } else {
        // .songIds = (fields[0] as List)?.cast<String>()
        return '..$name = (fields[${field.index}] as Set)?.cast<$st>()';
      }
    } else if (type.isDartCoreMap) {
      final enType1 = _isEntityParam(subTypes.first);
      final enType2 = _isEntityParam(subTypes.last);

      final t1 = enType1 ? 'String' : subTypes.first;
      final t2 = enType2 ? 'String' : subTypes.last;

      final fieldName = (enType1 || enType2) ? toReferenceName : name;

      return '..$fieldName = (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
    } else if (_isEntityParam(type)) {
      return '..$toReferenceName = (fields[${field.index}] as String)';
    }

    return '..$name = fields[${field.index}] as $type';
  }

  @override
  String toString() => toPublicField;
}
