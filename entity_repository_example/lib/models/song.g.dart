// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Song]
abstract class _$Song extends EntityBase<Song> {
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
  List<int> authors2;
  String copyright;
  List<Person> translator;
  List<Tag> tags;
  Song copyWith(
      {String id,
      String title,
      int bpm,
      int transpose,
      String songKey,
      int capo,
      String lyrics,
      String notes,
      String ccli,
      List<Person> authors,
      List<int> authors2,
      String copyright,
      List<Person> translator,
      List<Tag> tags});
}

class _Song extends EntityBase<Song> implements Song {
  _Song(
      {String id,
      String title,
      int bpm,
      int transpose,
      String songKey,
      int capo,
      String lyrics,
      String notes,
      String ccli,
      List<Person> authors,
      List<int> authors2,
      String copyright,
      List<Person> translator,
      List<Tag> tags})
      : _title = title,
        _bpm = bpm,
        _transpose = transpose,
        _songKey = songKey,
        _capo = capo,
        _lyrics = lyrics,
        _notes = notes,
        _ccli = ccli,
        _authors = authors,
        _authors2 = authors2,
        _copyright = copyright,
        _translator = translator,
        _tags = tags,
        super(id);

  @override
  Song copyWith(
      {String id,
      String title,
      int bpm,
      int transpose,
      String songKey,
      int capo,
      String lyrics,
      String notes,
      String ccli,
      List<Person> authors,
      List<int> authors2,
      String copyright,
      List<Person> translator,
      List<Tag> tags}) {
    return _Song(
        id: id ?? this.id,
        title: title ?? this.title,
        bpm: bpm ?? this.bpm,
        transpose: transpose ?? this.transpose,
        songKey: songKey ?? this.songKey,
        capo: capo ?? this.capo,
        lyrics: lyrics ?? this.lyrics,
        notes: notes ?? this.notes,
        ccli: ccli ?? this.ccli,
        authors: authors ?? this.authors,
        authors2: authors2 ?? this.authors2,
        copyright: copyright ?? this.copyright,
        translator: translator ?? this.translator,
        tags: tags ?? this.tags);
  }

  String _title;

  @override
  String get title => _title;

  @override
  set title(String title) {
    _title = title;
    setKeyValue(1, title);
  }

  int _bpm;

  @override
  int get bpm => _bpm;

  @override
  set bpm(int bpm) {
    _bpm = bpm;
    setKeyValue(2, bpm);
  }

  int _transpose;

  @override
  int get transpose => _transpose;

  @override
  set transpose(int transpose) {
    _transpose = transpose;
    setKeyValue(3, transpose);
  }

  String _songKey;

  @override
  String get songKey => _songKey;

  @override
  set songKey(String songKey) {
    _songKey = songKey;
    setKeyValue(4, songKey);
  }

  int _capo;

  @override
  int get capo => _capo;

  @override
  set capo(int capo) {
    _capo = capo;
    setKeyValue(5, capo);
  }

  String _lyrics;

  @override
  String get lyrics => _lyrics;

  @override
  set lyrics(String lyrics) {
    _lyrics = lyrics;
    setKeyValue(6, lyrics);
  }

  String _notes;

  @override
  String get notes => _notes;

  @override
  set notes(String notes) {
    _notes = notes;
    setKeyValue(7, notes);
  }

  String _ccli;

  @override
  String get ccli => _ccli;

  @override
  set ccli(String ccli) {
    _ccli = ccli;
    setKeyValue(8, ccli);
  }

  List<Person> _authors;

  @override
  List<Person> get authors => _authors ??= _lookUpAuthors();

  @override
  set authors(List<Person> authors) {
    _authors = authors;
    _authorsRefs = authors?.map((e) => e.id)?.toList();
    setKeyValue(9, _authorsRefs);
  }

  List<int> _authors2;

  @override
  List<int> get authors2 => _authors2;

  @override
  set authors2(List<int> authors2) {
    _authors2 = authors2;
    setKeyValue(10, authors2);
  }

  String _copyright;

  @override
  String get copyright => _copyright;

  @override
  set copyright(String copyright) {
    _copyright = copyright;
    setKeyValue(11, copyright);
  }

  List<Person> _translator;

  @override
  List<Person> get translator => _translator ??= _lookUpTranslator();

  @override
  set translator(List<Person> translator) {
    _translator = translator;
    _translatorRefs = translator?.map((e) => e.id)?.toList();
    setKeyValue(12, _translatorRefs);
  }

  List<Tag> _tags;

  @override
  List<Tag> get tags => _tags ??= _lookUpTags();

  @override
  set tags(List<Tag> tags) {
    _tags = tags;
    _tagsRefs = tags?.map((e) => e.id)?.toList();
    setKeyValue(13, _tagsRefs);
  }

  factory _Song.fromMap(Map<int, dynamic> fields) {
    return _Song(
        id: fields[0] as String,
        title: (fields[1] as String),
        bpm: (fields[2] as int),
        transpose: (fields[3] as int),
        songKey: (fields[4] as String),
        capo: (fields[5] as int),
        lyrics: (fields[6] as String),
        notes: (fields[7] as String),
        ccli: (fields[8] as String),
        authors2: (fields[10] as List)?.cast<int>(),
        copyright: (fields[11] as String))
      .._authorsRefs = (fields[9] as List)?.cast<String>()
      .._translatorRefs = (fields[12] as List)?.cast<String>()
      .._tagsRefs = (fields[13] as List)?.cast<String>();
  }

  factory _Song.fromJson(Map<String, dynamic> fields) {
    return _Song(
        id: fields['id'] as String,
        title: (fields['title'] as String),
        bpm: (fields['bpm'] as int),
        transpose: (fields['transpose'] as int),
        songKey: (fields['songKey'] as String),
        capo: (fields['capo'] as int),
        lyrics: (fields['lyrics'] as String),
        notes: (fields['notes'] as String),
        ccli: (fields['ccli'] as String),
        authors2: (fields['authors2'] as List)?.cast<int>(),
        copyright: (fields['copyright'] as String))
      .._authorsRefs = (fields['authors'] as List)?.cast<String>()
      .._translatorRefs = (fields['translator'] as List)?.cast<String>()
      .._tagsRefs = (fields['tags'] as List)?.cast<String>();
  }

  @override
  Set<EntityBase> getAllRefObjects() {
    final obj = <EntityBase>{};

    if (authors != null && authors.isNotEmpty) {
      obj.addAll(authors);
    }

    if (translator != null && translator.isNotEmpty) {
      obj.addAll(translator);
    }
    if (tags != null && tags.isNotEmpty) {
      obj.addAll(tags);
    }
    return obj;
  }

  @override
  Map<int, dynamic> toMap() {
    final map = <int, dynamic>{};

    /// store the id as field 0
    map[0] = id;
    if (title != null) {
      map[1] = title;
    }
    if (bpm != null) {
      map[2] = bpm;
    }
    if (transpose != null) {
      map[3] = transpose;
    }
    if (songKey != null) {
      map[4] = songKey;
    }
    if (capo != null) {
      map[5] = capo;
    }
    if (lyrics != null) {
      map[6] = lyrics;
    }
    if (notes != null) {
      map[7] = notes;
    }
    if (ccli != null) {
      map[8] = ccli;
    }
    if (authorsRefs != null && authorsRefs.isNotEmpty) {
      map[9] = authorsRefs;
    }
    if (authors2 != null && authors2.isNotEmpty) {
      map[10] = authors2;
    }
    if (copyright != null) {
      map[11] = copyright;
    }
    if (translatorRefs != null && translatorRefs.isNotEmpty) {
      map[12] = translatorRefs;
    }
    if (tagsRefs != null && tagsRefs.isNotEmpty) {
      map[13] = tagsRefs;
    }
    return map;
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    /// store the id as field 0
    map['id'] = id;
    if (title != null) {
      map['title'] = title;
    }
    if (bpm != null) {
      map['bpm'] = bpm;
    }
    if (transpose != null) {
      map['transpose'] = transpose;
    }
    if (songKey != null) {
      map['songKey'] = songKey;
    }
    if (capo != null) {
      map['capo'] = capo;
    }
    if (lyrics != null) {
      map['lyrics'] = lyrics;
    }
    if (notes != null) {
      map['notes'] = notes;
    }
    if (ccli != null) {
      map['ccli'] = ccli;
    }
    if (authorsRefs != null && authorsRefs.isNotEmpty) {
      map['authors'] = authorsRefs;
    }
    if (authors2 != null && authors2.isNotEmpty) {
      map['authors2'] = authors2;
    }
    if (copyright != null) {
      map['copyright'] = copyright;
    }
    if (translatorRefs != null && translatorRefs.isNotEmpty) {
      map['translator'] = translatorRefs;
    }
    if (tagsRefs != null && tagsRefs.isNotEmpty) {
      map['tags'] = tagsRefs;
    }
    return map;
  }

  @override
  void applyUpdates(Map<int, dynamic> fields) {
    if (fields.containsKey(1)) {
      _title = fields[1] as String;
    }
    if (fields.containsKey(2)) {
      _bpm = fields[2] as int;
    }
    if (fields.containsKey(3)) {
      _transpose = fields[3] as int;
    }
    if (fields.containsKey(4)) {
      _songKey = fields[4] as String;
    }
    if (fields.containsKey(5)) {
      _capo = fields[5] as int;
    }
    if (fields.containsKey(6)) {
      _lyrics = fields[6] as String;
    }
    if (fields.containsKey(7)) {
      _notes = fields[7] as String;
    }
    if (fields.containsKey(8)) {
      _ccli = fields[8] as String;
    }
    if (fields.containsKey(9)) {
      _authorsRefs = (fields[9] as List)?.cast<String>();
    }
    if (fields.containsKey(10)) {
      _authors2 = (fields[10] as List)?.cast<int>();
    }
    if (fields.containsKey(11)) {
      _copyright = fields[11] as String;
    }
    if (fields.containsKey(12)) {
      _translatorRefs = (fields[12] as List)?.cast<String>();
    }
    if (fields.containsKey(13)) {
      _tagsRefs = (fields[13] as List)?.cast<String>();
    }
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is _Song &&
        o.id == id &&
        o.title == title &&
        o.bpm == bpm &&
        o.transpose == transpose &&
        o.songKey == songKey &&
        o.capo == capo &&
        o.lyrics == lyrics &&
        o.notes == notes &&
        o.ccli == ccli &&
        listEquality(o.authorsRefs, authorsRefs) &&
        listEquality(o.authors2, authors2) &&
        o.copyright == copyright &&
        listEquality(o.translatorRefs, translatorRefs) &&
        listEquality(o.tagsRefs, tagsRefs);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        bpm.hashCode ^
        transpose.hashCode ^
        songKey.hashCode ^
        capo.hashCode ^
        lyrics.hashCode ^
        notes.hashCode ^
        ccli.hashCode ^
        authors.hashCode ^
        authors2.hashCode ^
        copyright.hashCode ^
        translator.hashCode ^
        tags.hashCode;
  }

  @override
  String toString() =>
      'Song(id: $id, title: $title, bpm: $bpm, transpose: $transpose, songKey: $songKey, capo: $capo, lyrics: $lyrics, notes: $notes, ccli: $ccli, authors: ${authorsRefs}, authors2: $authors2, copyright: $copyright, translator: ${translatorRefs}, tags: ${tagsRefs})';

  ///
  /// Generate the reference look up
  ///
  List<String> _authorsRefs;

  List<String> _translatorRefs;

  List<String> _tagsRefs;
  List<String> get authorsRefs =>
      _authorsRefs ??= authors?.map((e) => e.id)?.toList();

  List<String> get translatorRefs =>
      _translatorRefs ??= translator?.map((e) => e.id)?.toList();

  List<String> get tagsRefs => _tagsRefs ??= tags?.map((e) => e.id)?.toList();
  List<Person> _lookUpAuthors() {
    if (_authorsRefs != null) {
      return locator.get<Person>().findMany(_authorsRefs).toList();
    }
    return [];
  }

  List<Person> _lookUpTranslator() {
    if (_translatorRefs != null) {
      return locator.get<Person>().findMany(_translatorRefs).toList();
    }
    return [];
  }

  List<Tag> _lookUpTags() {
    if (_tagsRefs != null) {
      return locator.get<Tag>().findMany(_tagsRefs).toList();
    }
    return [];
  }
}

/// The serialize adapter of type [_Song]
class $SongAdapter implements Serializer<_Song> {
  $SongAdapter(this.repo);
  final RepositoryBase<Song> repo;
  @override
  final int typeId = 14;

  @override
  _Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Song.fromMap(fields)..repo = repo;
  }

  @override
  void write(BinaryWriter writer, _Song obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.authorsRefs)
      ..writeByte(10)
      ..write(obj.authors2)
      ..writeByte(11)
      ..write(obj.copyright)
      ..writeByte(12)
      ..write(obj.translatorRefs)
      ..writeByte(13)
      ..write(obj.tagsRefs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
