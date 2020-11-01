part of entity_repository_generator;

class EntityRepositorGeneratorError extends Error {
  final String message;
  EntityRepositorGeneratorError(this.message) : super();

  @override
  String toString() => 'EntityRepositorGeneratorError(message: $message)';
}
