part of entity_repository;

class EntityRepoError extends Error {
  final String message;
  EntityRepoError(
    this.message,
  );

  @override
  String toString() => 'EntityRepoError(message: $message)';
}
