part of entity_repository;

/// A helper class with static methods, which wraps the lookup for a
/// datamodel providing the type [T] and the String id
///
/// TODO:
/// best would be a mixin, which is only visible here in this class
///
mixin ReferenceLookUp {
  static T findOne<T extends DataModel<T>>(String refId) {
    if (refId == null) return null;
    final dao = repositoryLocator.get<T>();
    return dao.findOne(refId);
  }

  static Iterable<T> findMany<T extends DataModel<T>>(Iterable<String> refIds) {
    if (refIds == null) return null;

    final dao = repositoryLocator.get<T>();
    return dao.findMany(refIds);
  }
}
