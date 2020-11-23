// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// EntityRepositoryGenerator
// **************************************************************************

/// Interface to/off the class [Notes]
abstract class _$Notes extends EntityBase<Notes> {
  _$Notes(String id) : super(id);
  String title;
  String content;
  DateTime created;
  DateTime edited;
  Person creator;
  Person lastEditor;
  Notes copyWith(
      {String id,
      String title,
      String content,
      DateTime created,
      DateTime edited,
      Person creator,
      Person lastEditor});
}

class _Notes extends EntityBase<Notes> implements Notes {
  _Notes(
      {String id,
      String title,
      String content,
      DateTime created,
      DateTime edited,
      Person creator,
      Person lastEditor})
      : _title = title,
        _content = content,
        _created = created,
        _edited = edited,
        _creator = creator,
        _lastEditor = lastEditor,
        super(id);

  @override
  Notes copyWith(
      {String id,
      String title,
      String content,
      DateTime created,
      DateTime edited,
      Person creator,
      Person lastEditor}) {
    return _Notes(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        created: created ?? this.created,
        edited: edited ?? this.edited,
        creator: creator ?? this.creator,
        lastEditor: lastEditor ?? this.lastEditor);
  }

  String _title;

  @override
  String get title => _title;

  @override
  set title(String title) {
    _title = title;
    setKeyValue(1, title);
  }

  String _content;

  @override
  String get content => _content;

  @override
  set content(String content) {
    _content = content;
    setKeyValue(2, content);
  }

  DateTime _created;

  @override
  DateTime get created => _created;

  @override
  set created(DateTime created) {
    _created = created;
    setKeyValue(3, created);
  }

  DateTime _edited;

  @override
  DateTime get edited => _edited;

  @override
  set edited(DateTime edited) {
    _edited = edited;
    setKeyValue(4, edited);
  }

  Person _creator;

  @override
  Person get creator => _creator ??= _lookUpCreator();

  @override
  set creator(Person creator) {
    _creator = creator;
    _creatorRefs = creator?.id;
    setKeyValue(5, _creatorRefs);
  }

  Person _lastEditor;

  @override
  Person get lastEditor => _lastEditor ??= _lookUpLastEditor();

  @override
  set lastEditor(Person lastEditor) {
    _lastEditor = lastEditor;
    _lastEditorRefs = lastEditor?.id;
    setKeyValue(6, _lastEditorRefs);
  }

  factory _Notes.fromMap(Map<int, dynamic> fields) {
    return _Notes(
        id: fields[0] as String,
        title: (fields[1] as String),
        content: (fields[2] as String),
        created: (fields[3] as DateTime),
        edited: (fields[4] as DateTime))
      .._creatorRefs = (fields[5] as String)
      .._lastEditorRefs = (fields[6] as String);
  }

  factory _Notes.fromJson(Map<String, dynamic> fields) {
    return _Notes(
        id: fields['id'] as String,
        title: (fields['title'] as String),
        content: (fields['content'] as String),
        created: (fields['created'] as DateTime),
        edited: (fields['edited'] as DateTime))
      .._creatorRefs = (fields['creator'] as String)
      .._lastEditorRefs = (fields['lastEditor'] as String);
  }

  @override
  Set<EntityBase> getAllRefObjects() {
    final obj = <EntityBase>{};

    if (creator != null) obj.add(creator);
    if (lastEditor != null) obj.add(lastEditor);
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
    if (content != null) {
      map[2] = content;
    }
    if (created != null) {
      map[3] = created;
    }
    if (edited != null) {
      map[4] = edited;
    }
    if (creatorRefs != null) {
      map[5] = creatorRefs;
    }
    if (lastEditorRefs != null) {
      map[6] = lastEditorRefs;
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
    if (content != null) {
      map['content'] = content;
    }
    if (created != null) {
      map['created'] = created;
    }
    if (edited != null) {
      map['edited'] = edited;
    }
    if (creatorRefs != null) {
      map['creator'] = creatorRefs;
    }
    if (lastEditorRefs != null) {
      map['lastEditor'] = lastEditorRefs;
    }
    return map;
  }

  @override
  void applyUpdates(Map<int, dynamic> fields) {
    if (fields.containsKey(1)) {
      _title = fields[1] as String;
    }
    if (fields.containsKey(2)) {
      _content = fields[2] as String;
    }
    if (fields.containsKey(3)) {
      _created = fields[3] as DateTime;
    }
    if (fields.containsKey(4)) {
      _edited = fields[4] as DateTime;
    }
    if (fields.containsKey(5)) {
      _creatorRefs = (fields[5] as String);
    }
    if (fields.containsKey(6)) {
      _lastEditorRefs = (fields[6] as String);
    }
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is _Notes &&
        o.id == id &&
        o.title == title &&
        o.content == content &&
        o.created == created &&
        o.edited == edited &&
        o.creatorRefs == creatorRefs &&
        o.lastEditorRefs == lastEditorRefs;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        created.hashCode ^
        edited.hashCode ^
        creator.hashCode ^
        lastEditor.hashCode;
  }

  @override
  String toString() =>
      'Notes(id: $id, title: $title, content: $content, created: $created, edited: $edited, creator: ${creatorRefs}, lastEditor: ${lastEditorRefs})';

  ///
  /// Generate the reference look up
  ///
  String _creatorRefs;

  String _lastEditorRefs;
  String get creatorRefs => _creatorRefs ??= creator?.id;

  String get lastEditorRefs => _lastEditorRefs ??= lastEditor?.id;
  Person _lookUpCreator() {
    return locator.get<Person>().findOne(_creatorRefs);
  }

  Person _lookUpLastEditor() {
    return locator.get<Person>().findOne(_lastEditorRefs);
  }
}

/// The serialize adapter of type [_Notes]
class $NotesAdapter implements Serializer<_Notes> {
  $NotesAdapter(this.repo);
  final RepositoryBase<Notes> repo;
  @override
  final int typeId = 15;

  @override
  _Notes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return _Notes.fromMap(fields)..repo = repo;
  }

  @override
  void write(BinaryWriter writer, _Notes obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.created)
      ..writeByte(4)
      ..write(obj.edited)
      ..writeByte(5)
      ..write(obj.creatorRefs)
      ..writeByte(6)
      ..write(obj.lastEditorRefs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $NotesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
