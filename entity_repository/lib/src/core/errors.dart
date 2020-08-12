part of entity_repository;

class EntityRepositoryError extends Error {
  final String message;
  EntityRepositoryError(this.message);

  @override
  String toString() => 'EntityRepoError(message: $message)';
}

class EntityRepositoryException implements Exception {
  final String message;
  EntityRepositoryException(this.message);

  @override
  String toString() => 'EntityRepositoryError(message: $message)';
}
