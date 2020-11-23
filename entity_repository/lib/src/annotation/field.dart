part of entity_repository;

class Field {
  final int index;
  final Converter converter;
  const Field(this.index, {this.converter});
}

abstract class Converter<From, To> {
  To from(From field);
  From to(To field);
}
