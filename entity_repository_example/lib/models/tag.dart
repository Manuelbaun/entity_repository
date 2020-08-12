import 'package:entity_repository/entity_repository.dart';

import 'adapterIds.dart';

part 'tag.g.dart';

@EntityModel(AdapterIds.tag)
abstract class Tag extends _$Tag {
  /// Id can be used as the tag name asdfsdf
  factory Tag({@Field(0) String id}) = _Tag;
}
