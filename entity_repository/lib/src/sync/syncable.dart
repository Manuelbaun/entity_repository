part of entity_repository;

/// This abstract class will record all changes happen to a data structur
/// it is manly used together with a map
abstract class Syncable {
  final _updateMap = HashMap<dynamic, dynamic>();

  /// This method will store the key and value in an map as updates.
  /// Once the update() method gets called, this updateMap will be stored as an
  /// update atom. After that, the map will be cleared
  @pragma('vm:prefer-inline')
  void setKeyValue(dynamic key, dynamic value) => _updateMap[key] = value;

  @pragma('vm:prefer-inline')
  bool get hasUpdates => _updateMap.isNotEmpty;
  void clearUpdates() => _updateMap.clear();

  Map<dynamic, dynamic> getUpdates() =>
      HashMap<dynamic, dynamic>.from(_updateMap);
}
