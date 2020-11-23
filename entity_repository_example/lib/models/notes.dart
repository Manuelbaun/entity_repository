import 'package:entity_repository/entity_repository.dart';

import 'adapterIds.dart';
import 'person.dart';

part 'notes.g.dart';

// comments

class DateTimeConv implements Converter<DateTime, int> {
  const DateTimeConv();
  @override
  int from(DateTime d) => d.millisecondsSinceEpoch;

  @override
  DateTime to(int ms) => DateTime.fromMillisecondsSinceEpoch(ms);
}

const conv = DateTimeConv();

@EntityModel(
  AdapterIds.notes,
  index: [
    {'model', 'owner'}
  ],
)
abstract class Notes extends _$Notes {
  factory Notes({
    @Field(0) String id,
    @Field(1) String title,
    @Field(2) String content,
    @Field(3, converter: conv) DateTime created,
    @Field(4, converter: conv) DateTime edited,
    @Field(5) Person creator,
    @Field(6) Person lastEditor,
  }) = _Notes;

  static Notes fromMap(Map<int, dynamic> fields) => _Notes.fromMap(fields);
  static Notes fromJson(Map<String, dynamic> fields) => _Notes.fromJson(fields);

  @override
  String toString() {
    return 'Hello World';
  }
}
