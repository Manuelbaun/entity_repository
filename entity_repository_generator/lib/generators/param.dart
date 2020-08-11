part of entity_repo_generator;

class Param {
  Field field;
  String name;
  InterfaceType type;
  Set<InterfaceType> subTypes = {};
  final Map<String, ClassElement> _entitiesTypes;

  bool _contains(InterfaceType type) =>
      _entitiesTypes.containsKey(type.getDisplayString());

  Param({
    this.name,
    this.field,
    this.type,
    Map<String, ClassElement> entitiesTypes,
  }) : _entitiesTypes = entitiesTypes {
    if (type.isDartCoreList || type.isDartCoreSet || type.isDartCoreMap) {
      subTypes = getAllTypes(type).toSet();
    }
  }

  bool get hasSubType => subTypes.isNotEmpty;

  String get stringfy {
    if (_contains(type)) {
      return '$name: \${$name?.id}';
    } else if (type.isDartCoreList || type.isDartCoreSet) {
      if (_contains(subTypes.first)) {
        return '$name: \${$name.map((e) => e.id)})';
      }
    } else if (type.isDartCoreMap) {
      final ass1 = _contains(subTypes.first) ? 'key.id' : 'key';
      final ass2 = _contains(subTypes.last) ? 'value.id' : 'value';

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
      if (_contains(type)) {
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

      final ass1 = _contains(type1)
          ? '${(ReferenceLookUp).$name}.findOne<$type1>(entry.key)'
          : 'entry.key';

      final ass2 = _contains(type2)
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
      if (_contains(subTypes.first)) {
        tt = 'List<String>';
      } else {
        tt = 'List<${subTypes.first}>';
      }
    } else if (type.isDartCoreMap) {
      final t1 = _contains(subTypes.first) ? 'String' : subTypes.first;

      final t2 = _contains(subTypes.last) ? 'String' : subTypes.last;

      tt = 'Map<$t1, $t2>';
    } else if (type.isDartCoreSet) {
      if (_contains(subTypes.first)) {
        tt = 'Set<String>';
      } else {
        tt = 'Set<${subTypes.first}>';
      }
    }

    return '$tt $toReferenceName;';
  }

  /// to serialize
  ///
  String get toSerializeWrite {
    var wrr = '..writeByte(${field.index})\n..';
    if (type.isDartCoreList) {
      if (_contains(subTypes.first)) {
        wrr += 'write(obj.$name?.map((e) => e.id)?.toList())';
      }
    } else if (type.isDartCoreSet) {
      if (_contains(subTypes.first)) {
        wrr += 'write(obj.$name?.map((e) => e.id)?.toSet())';
      }
    } else if (type.isDartCoreMap) {
      final t1 = _contains(subTypes.first) ? 'key.id' : 'key';
      final t2 = _contains(subTypes.last) ? 'value.id' : 'value';

      wrr += 'write(obj.$name?.map((key, value) => MapEntry($t1, $t2)))';
    } else if (_contains(type)) {
      wrr += 'write(obj.$name?.id)';
    } else {
      wrr += 'write(obj.$name)';
    }

    return wrr;
  }

  String get toSerializeRead {
    if (type.isDartCoreList) {
      final st = subTypes.first;

      if (_contains(st)) {
        return '..$toReferenceName = (fields[${field.index}] as List)?.cast<String>()';
      } else {
        // .songIds = (fields[0] as List)?.cast<String>()
        return '..$name = (fields[${field.index}] as List)?.cast<$st>()';
      }
    } else if (type.isDartCoreSet) {
      final st = subTypes.first;

      if (_contains(st)) {
        return '..$toReferenceName = (fields[${field.index}] as Set)?.cast<String>()';
      } else {
        // .songIds = (fields[0] as List)?.cast<String>()
        return '..$name = (fields[${field.index}] as Set)?.cast<$st>()';
      }
    } else if (type.isDartCoreMap) {
      final enType1 = _contains(subTypes.first);
      final enType2 = _contains(subTypes.last);

      final t1 = enType1 ? 'String' : subTypes.first;
      final t2 = enType2 ? 'String' : subTypes.last;

      final fieldName = (enType1 || enType2) ? toReferenceName : name;

      return '..$fieldName = (fields[${field.index}] as Map)?.cast<$t1, $t2>()';
    } else if (_contains(type)) {
      return '..$toReferenceName = (fields[${field.index}] as String)';
    }

    return '..$name = fields[${field.index}] as $type';
  }

  @override
  String toString() => toPublicField;
}
