part of entity_repository_generator;

class SerializerAdapter {
  static StringBuffer generate(ModelVisitor visitor) {
    final buff = StringBuffer();

    const readerField = '''
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };''';

    buff
      ..writeln('/// The serialize adapter of type [${visitor.redirectName}]')
      ..write('class ${visitor.adapterName} implements ')
      ..write('${(Serializer).$name}<${visitor.redirectName}> {')
      ..write('${visitor.adapterName}(this.repo);')
      ..writeln('final RepositoryBase<${visitor.entityName}> repo;')
      ..writeln('@override\n final int typeId = ${visitor.model.typeId};\n')

      /// read bin
      ..writeln('@override')
      ..writeln('${visitor.redirectName} read(BinaryReader reader) {')
      ..writeln(readerField)
      ..write('\n\n')
      ..writeln('return ${visitor.redirectName}.fromMap(fields)..repo = repo')
      ..writeln(';}')

      ///Write bin
      ..writeln('\n\n@override')
      ..writeln(
          'void write(BinaryWriter writer, ${visitor.redirectName} obj) {')
      ..writeln('writer')
      ..writeln('..writeByte(${visitor.params.length + 1})')
      ..writeln('..writeByte(0)')
      ..writeln('..write(obj.id)')
      ..writeAll(visitor.params.map((e) => _toSerializeWrite(e)), '\n')
      ..writeln(';}')
      ..write(_generateSerializerAdapterEquality(visitor))
      ..write('}');

    return buff;
  }

  static String _toSerializeWrite(ParamBase p) {
    var fieldString = p.isOrHasEntities ? p.toRefNameGetter : p.paramName;

    if (p is ParamSet) {
      fieldString += '?.toList()';
    }

    final buff = StringBuffer()
      ..writeln('..writeByte(${p.field.index})\n')
      ..writeln('..write(obj.$fieldString)\n');

    return buff.toString();
  }

  static StringBuffer _generateSerializerAdapterEquality(ModelVisitor visitor) {
    final buff = StringBuffer()..write('''@override
    int get hashCode => typeId.hashCode;

    @override
    bool operator ==(Object other) =>
        identical(this, other) ||
        other is ${visitor.adapterName} &&
            runtimeType == other.runtimeType &&
            typeId == other.typeId;
            ''');

    return buff;
  }
}
