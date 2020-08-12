part of entity_repository;

class DataHelper<TKey> {
  static String generateIDString() => newSemiCuid();
  static String checkOrGenerateID(String id) {
    if (id == null || id.isEmpty) {
      return generateIDString();
    }
    return id;
  }
}
