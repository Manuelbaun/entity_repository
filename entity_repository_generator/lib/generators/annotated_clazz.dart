part of entity_repository_generator;

class AnnotatedClazz {
  final InterfaceType type;
  final ClassElement element;
  final EntityModel model;
  AnnotatedClazz({
    this.type,
    this.element,
    this.model,
  });
}
