// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Song]
abstract class _$Song extends DataModel<Song> {
  _$Song(String id) : super(id);
  String title;
  int bpm;
  int transpose;
  String songKey;
  int capo;
  String lyrics;
  String notes;
  String ccli;
  List<Person> authors;
  String copyright;
  List<Person> translator;
  List<Tag> tags;
}

mixin _SongReferenceLookUp {
  List<String> authorsRefs;
  List<String> translatorRefs;
  List<String> tagsRefs;
  List<Person> _lookUpAuthors() {
    if (authorsRefs != null) {
      return ReferenceLookUp.findMany<Person>(authorsRefs).toList();
    }
    return [];
  }

  List<Person> _lookUpTranslator() {
    if (translatorRefs != null) {
      return ReferenceLookUp.findMany<Person>(translatorRefs).toList();
    }
    return [];
  }

  List<Tag> _lookUpTags() {
    if (tagsRefs != null) {
      return ReferenceLookUp.findMany<Tag>(tagsRefs).toList();
    }
    return [];
  }
}

class _Song extends DataModel<Song> with _SongReferenceLookUp implements Song {
  _Song(
      {String id,
      List<Person> authors,
      List<Person> translator,
      List<Tag> tags,
      this.title,
      this.bpm,
      this.transpose,
      this.songKey,
      this.capo,
      this.lyrics,
      this.notes,
      this.ccli,
      this.copyright})
      : _authors = authors,
        _translator = translator,
        _tags = tags,
        super(id);

  @override
  String title;
  @override
  int bpm;
  @override
  int transpose;
  @override
  String songKey;
  @override
  int capo;
  @override
  String lyrics;
  @override
  String notes;
  @override
  String ccli;
  @override
  String copyright;

  @override
  List<Person> get authors => _authors ??= _lookUpAuthors();

  @override
  set authors(List<Person> authors) => _authors = authors;

  List<Person> _authors;

  @override
  List<Person> get translator => _translator ??= _lookUpTranslator();

  @override
  set translator(List<Person> translator) => _translator = translator;

  List<Person> _translator;

  @override
  List<Tag> get tags => _tags ??= _lookUpTags();

  @override
  set tags(List<Tag> tags) => _tags = tags;

  List<Tag> _tags;
  @override
  String toString() =>
      '''Song(id: $id, title: $title, bpm: $bpm, transpose: $transpose, songKey: $songKey, capo: $capo, lyrics: $lyrics, notes: $notes, ccli: $ccli, authors: ${authors.map((e) => e.id)}), copyright: $copyright, translator: ${translator.map((e) => e.id)}), tags: ${tags.map((e) => e.id)}))''';
}

/// The serialize adapter of type [_Song]
class $SongAdapter implements Serializer<_Song> {
  @override
  final int typeId = 14;

  @override
  _Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Song(id: fields[0] as String)
      ..title = fields[1] as String
      ..bpm = fields[2] as int
      ..transpose = fields[3] as int
      ..songKey = fields[4] as String
      ..capo = fields[5] as int
      ..lyrics = fields[6] as String
      ..notes = fields[7] as String
      ..ccli = fields[8] as String
      ..authorsRefs = (fields[9] as List)?.cast<String>()
      ..copyright = fields[10] as String
      ..translatorRefs = (fields[11] as List)?.cast<String>()
      ..tagsRefs = (fields[12] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, _Song obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.bpm)
      ..writeByte(3)
      ..write(obj.transpose)
      ..writeByte(4)
      ..write(obj.songKey)
      ..writeByte(5)
      ..write(obj.capo)
      ..writeByte(6)
      ..write(obj.lyrics)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.ccli)
      ..writeByte(9)
      ..write(obj.authors?.map((e) => e.id)?.toList())
      ..writeByte(10)
      ..write(obj.copyright)
      ..writeByte(11)
      ..write(obj.translator?.map((e) => e.id)?.toList())
      ..writeByte(12)
      ..write(obj.tags?.map((e) => e.id)?.toList());
  }
}

/// The [$SongRepo] class of type [Song]
class $SongRepo extends RepositoryHive<Song> {}
