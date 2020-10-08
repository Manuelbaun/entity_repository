part of entity_repository;

class ChainTracker {
  final _chain = <DataModel>{};
  final _chainCounter = <String, int>{};
  var _isTracking = false;

  bool isNotSavedYet(DataModel entity) => !_chain.contains(entity);

  bool _add(DataModel entity) {
    _chainCounter[entity.id] ??= 0;
    _chainCounter[entity.id] += 1;

    return _chain.add(entity);
  }

  /// this function might be called recursivly. Therefore check must happen
  Future<void> track(DataModel entity, Future<void> Function() func) async {
    if (_isTracking) {
      if (_add(entity)) {
        await func();
      }
    } else {
      _isTracking = true;
      _add(entity);

      await func();

      _isTracking = false;

      print(_chainCounter);

      _chain.clear();
      _chainCounter.clear();
    }
  }
}
