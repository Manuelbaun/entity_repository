import 'package:entity_repository/entity_repository.dart';

import 'adapterIds.dart';
import 'address.dart';

part 'person.g.dart';

/// asdf asdfdas
@EntityModel(AdapterIds.person)
abstract class Person implements _$Person {
  factory Person({
    @Field(0) String id,
    @Field(1) String name,
    @Field(2) int age,
    @Field(3) Address address,
    @Field(4) List<Person> friends,
    @Field(5) Set<Person> friends5,
    @Field(6) Map<int, Address> a5sf,
    @Field(7) Map<Person, Address> p2a,
  }) = _Person;

  static Person fromMap(Map<int, dynamic> fields) => _Person.fromMap(fields);
  static Person fromJson(Map<String, dynamic> fields) =>
      _Person.fromJson(fields);
}
