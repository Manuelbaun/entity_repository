part of entity_repository;

/// Todo: add types
/// * causal entry
/// * etc....
class _ExtendetEncoder implements ExtEncoder {
  @override
  int extTypeForObject(dynamic o) {
    if (o is Atom) return 1;

    return null;
  }

  @override
  Uint8List encodeObject(dynamic o) {
    if (o is Atom) {
      return serialize([
        o.ms,
        o.id,
        o.typeModel,
        o.action?.index,
        o.data,
      ]);
    }

    return null;
  }
}

class _ExtendetDecoder implements ExtDecoder {
  @override
  dynamic decodeObject(int extType, Uint8List data) {
    if (extType == 1) {
      final v = msgpackDecode(data);

      return Atom(
        ms: v[0] as int,
        id: v[1] as String,
        typeModel: v[2] as String,
        action: v[3] != null ? Action.values[v[3] as int] : null,
        data: v[4] != null ? (v[4] as Map).cast<int, dynamic>() : null,
      );
    }

    return null;
  }
}
