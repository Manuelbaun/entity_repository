import 'package:entity_repository/entity_repository.dart';

import 'adapterIds.dart';
import 'person.dart';
import 'tag.dart';

part 'song.g.dart';

@EntityModel(AdapterIds.song)
abstract class Song extends _$Song {
  factory Song({
    @Field(0) String id,
    @Field(1) String title,
    @Field(2) int bpm,
    @Field(3) int transpose,
    @Field(4) String songKey,
    @Field(5) int capo,
    @Field(6) String lyrics,
    @Field(7) String notes,
    @Field(8) String ccli,
    @Field(9) List<Person> authors,
    @Field(10) List<int> authors2,
    @Field(11) String copyright,
    @Field(12) List<Person> translator,
    @Field(13) List<Tag> tags,
  }) = _Song;

  static Song fromMap(Map<int, dynamic> fields) => _Song.fromMap(fields);
  static Song fromJson(Map<String, dynamic> fields) => _Song.fromJson(fields);
}
