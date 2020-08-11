import 'package:entity_repository/entity_repository.dart';

import 'adapterIds.dart';

part 'address.g.dart';

// sdfdsfd
@EntityModel(AdapterIds.address)
abstract class Address implements _$Address {
  factory Address({
    @Field(0) String id,
    @Field(1) String street,
    @Field(2) int houseNumber,
  }) = _Address;
}
