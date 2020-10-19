import 'package:entity_repository/entity_repository.dart';

import 'adapterIds.dart';
import 'person.dart';

part 'car.g.dart';

@EntityModel(
  AdapterIds.car,
  index: [
    {'model', 'owner'}
  ],
)
abstract class Car extends _$Car {
  factory Car({
    @Field(0) String id,
    @Field(1) String model,
    @Field(2) String type,
    @Field(3) int buildYear,
    @Field(4) Person owner,
  }) = _Car;

  static Car fromMap(Map<int, dynamic> fields) => _Car.fromMap(fields);

  @override
  String toString() {
    return 'Hello World';
  }
}
