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
  static RepositoryBase<Song> repo;

  static Song fromMap(Map<int, dynamic> fields) => _Song.fromMap(fields);
}

void test() {
  final s = Song();
}
//sdf adsfsdfsd asdf ads ads asdf asdf

// @EntityModel(30)
// abstract class Song2 extends _$Song2 {

//   // Map<String, dynamic> toMap() {
//   //   return {
//   //     'id': id,
//   //     'title': title,
//   //     'bpm': bpm,
//   //     'transpose': transpose,
//   //     'songKey': songKey,
//   //     'capo': capo,
//   //     'lyrics': lyrics,
//   //     'notes': notes,
//   //     'ccli': ccli,
//   //     'authors': authors,
//   //     'copyright': copyright,
//   //     'translator': translator,
//   //     'tags': tags,
//   //   };
//   // }

//   // factory Song2.fromMapKuzzle(Map<String, dynamic> map) {
//   //   if (map == null) return null;

//   //   return Song2(
//   //     id: map['id'] as String,
//   //     title: map['title'] as String,
//   //     bpm: map['bpm'] as int ?? 120,
//   //     transpose: map['transpose'] as int,
//   //     songKey: map['key'] as String,
//   //     capo: map['capo'] as int,
//   //     lyrics: map['lyrics'] as String,
//   //     notes: map['notes'] as String,
//   //     ccli: map['ccli'] as String,
//   //     authors: List<String>.from(map['authors'] as List),
//   //     copyright: map['copyright'] as String,
//   //     tags: List<String>.from(map['tags'] as List),
//   //   );
//   // }

//   // @override
//   // int compareTo(Song2 other) => (title?.compareTo(other.title ?? "")) ?? 0;

// }
