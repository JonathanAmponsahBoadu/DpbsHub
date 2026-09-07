// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameTwMeta = const VerificationMeta('nameTw');
  @override
  late final GeneratedColumn<String> nameTw = GeneratedColumn<String>(
    'name_tw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _abbrEnMeta = const VerificationMeta('abbrEn');
  @override
  late final GeneratedColumn<String> abbrEn = GeneratedColumn<String>(
    'abbr_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _abbrTwMeta = const VerificationMeta('abbrTw');
  @override
  late final GeneratedColumn<String> abbrTw = GeneratedColumn<String>(
    'abbr_tw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _testamentMeta = const VerificationMeta(
    'testament',
  );
  @override
  late final GeneratedColumn<String> testament = GeneratedColumn<String>(
    'testament',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterCountMeta = const VerificationMeta(
    'chapterCount',
  );
  @override
  late final GeneratedColumn<int> chapterCount = GeneratedColumn<int>(
    'chapter_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugEnMeta = const VerificationMeta('slugEn');
  @override
  late final GeneratedColumn<String> slugEn = GeneratedColumn<String>(
    'slug_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugTwMeta = const VerificationMeta('slugTw');
  @override
  late final GeneratedColumn<String> slugTw = GeneratedColumn<String>(
    'slug_tw',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugEnVerifiedMeta = const VerificationMeta(
    'slugEnVerified',
  );
  @override
  late final GeneratedColumn<bool> slugEnVerified = GeneratedColumn<bool>(
    'slug_en_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("slug_en_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _slugTwVerifiedMeta = const VerificationMeta(
    'slugTwVerified',
  );
  @override
  late final GeneratedColumn<bool> slugTwVerified = GeneratedColumn<bool>(
    'slug_tw_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("slug_tw_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameEn,
    nameTw,
    abbrEn,
    abbrTw,
    testament,
    chapterCount,
    slugEn,
    slugTw,
    slugEnVerified,
    slugTwVerified,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_tw')) {
      context.handle(
        _nameTwMeta,
        nameTw.isAcceptableOrUnknown(data['name_tw']!, _nameTwMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTwMeta);
    }
    if (data.containsKey('abbr_en')) {
      context.handle(
        _abbrEnMeta,
        abbrEn.isAcceptableOrUnknown(data['abbr_en']!, _abbrEnMeta),
      );
    }
    if (data.containsKey('abbr_tw')) {
      context.handle(
        _abbrTwMeta,
        abbrTw.isAcceptableOrUnknown(data['abbr_tw']!, _abbrTwMeta),
      );
    }
    if (data.containsKey('testament')) {
      context.handle(
        _testamentMeta,
        testament.isAcceptableOrUnknown(data['testament']!, _testamentMeta),
      );
    } else if (isInserting) {
      context.missing(_testamentMeta);
    }
    if (data.containsKey('chapter_count')) {
      context.handle(
        _chapterCountMeta,
        chapterCount.isAcceptableOrUnknown(
          data['chapter_count']!,
          _chapterCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterCountMeta);
    }
    if (data.containsKey('slug_en')) {
      context.handle(
        _slugEnMeta,
        slugEn.isAcceptableOrUnknown(data['slug_en']!, _slugEnMeta),
      );
    } else if (isInserting) {
      context.missing(_slugEnMeta);
    }
    if (data.containsKey('slug_tw')) {
      context.handle(
        _slugTwMeta,
        slugTw.isAcceptableOrUnknown(data['slug_tw']!, _slugTwMeta),
      );
    } else if (isInserting) {
      context.missing(_slugTwMeta);
    }
    if (data.containsKey('slug_en_verified')) {
      context.handle(
        _slugEnVerifiedMeta,
        slugEnVerified.isAcceptableOrUnknown(
          data['slug_en_verified']!,
          _slugEnVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('slug_tw_verified')) {
      context.handle(
        _slugTwVerifiedMeta,
        slugTwVerified.isAcceptableOrUnknown(
          data['slug_tw_verified']!,
          _slugTwVerifiedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameTw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_tw'],
      )!,
      abbrEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbr_en'],
      )!,
      abbrTw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbr_tw'],
      )!,
      testament: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}testament'],
      )!,
      chapterCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_count'],
      )!,
      slugEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug_en'],
      )!,
      slugTw: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug_tw'],
      )!,
      slugEnVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}slug_en_verified'],
      )!,
      slugTwVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}slug_tw_verified'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final String nameEn;
  final String nameTw;
  final String abbrEn;
  final String abbrTw;
  final String testament;
  final int chapterCount;
  final String slugEn;
  final String slugTw;
  final bool slugEnVerified;
  final bool slugTwVerified;
  const Book({
    required this.id,
    required this.nameEn,
    required this.nameTw,
    required this.abbrEn,
    required this.abbrTw,
    required this.testament,
    required this.chapterCount,
    required this.slugEn,
    required this.slugTw,
    required this.slugEnVerified,
    required this.slugTwVerified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name_en'] = Variable<String>(nameEn);
    map['name_tw'] = Variable<String>(nameTw);
    map['abbr_en'] = Variable<String>(abbrEn);
    map['abbr_tw'] = Variable<String>(abbrTw);
    map['testament'] = Variable<String>(testament);
    map['chapter_count'] = Variable<int>(chapterCount);
    map['slug_en'] = Variable<String>(slugEn);
    map['slug_tw'] = Variable<String>(slugTw);
    map['slug_en_verified'] = Variable<bool>(slugEnVerified);
    map['slug_tw_verified'] = Variable<bool>(slugTwVerified);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      nameEn: Value(nameEn),
      nameTw: Value(nameTw),
      abbrEn: Value(abbrEn),
      abbrTw: Value(abbrTw),
      testament: Value(testament),
      chapterCount: Value(chapterCount),
      slugEn: Value(slugEn),
      slugTw: Value(slugTw),
      slugEnVerified: Value(slugEnVerified),
      slugTwVerified: Value(slugTwVerified),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameTw: serializer.fromJson<String>(json['nameTw']),
      abbrEn: serializer.fromJson<String>(json['abbrEn']),
      abbrTw: serializer.fromJson<String>(json['abbrTw']),
      testament: serializer.fromJson<String>(json['testament']),
      chapterCount: serializer.fromJson<int>(json['chapterCount']),
      slugEn: serializer.fromJson<String>(json['slugEn']),
      slugTw: serializer.fromJson<String>(json['slugTw']),
      slugEnVerified: serializer.fromJson<bool>(json['slugEnVerified']),
      slugTwVerified: serializer.fromJson<bool>(json['slugTwVerified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameTw': serializer.toJson<String>(nameTw),
      'abbrEn': serializer.toJson<String>(abbrEn),
      'abbrTw': serializer.toJson<String>(abbrTw),
      'testament': serializer.toJson<String>(testament),
      'chapterCount': serializer.toJson<int>(chapterCount),
      'slugEn': serializer.toJson<String>(slugEn),
      'slugTw': serializer.toJson<String>(slugTw),
      'slugEnVerified': serializer.toJson<bool>(slugEnVerified),
      'slugTwVerified': serializer.toJson<bool>(slugTwVerified),
    };
  }

  Book copyWith({
    int? id,
    String? nameEn,
    String? nameTw,
    String? abbrEn,
    String? abbrTw,
    String? testament,
    int? chapterCount,
    String? slugEn,
    String? slugTw,
    bool? slugEnVerified,
    bool? slugTwVerified,
  }) => Book(
    id: id ?? this.id,
    nameEn: nameEn ?? this.nameEn,
    nameTw: nameTw ?? this.nameTw,
    abbrEn: abbrEn ?? this.abbrEn,
    abbrTw: abbrTw ?? this.abbrTw,
    testament: testament ?? this.testament,
    chapterCount: chapterCount ?? this.chapterCount,
    slugEn: slugEn ?? this.slugEn,
    slugTw: slugTw ?? this.slugTw,
    slugEnVerified: slugEnVerified ?? this.slugEnVerified,
    slugTwVerified: slugTwVerified ?? this.slugTwVerified,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameTw: data.nameTw.present ? data.nameTw.value : this.nameTw,
      abbrEn: data.abbrEn.present ? data.abbrEn.value : this.abbrEn,
      abbrTw: data.abbrTw.present ? data.abbrTw.value : this.abbrTw,
      testament: data.testament.present ? data.testament.value : this.testament,
      chapterCount: data.chapterCount.present
          ? data.chapterCount.value
          : this.chapterCount,
      slugEn: data.slugEn.present ? data.slugEn.value : this.slugEn,
      slugTw: data.slugTw.present ? data.slugTw.value : this.slugTw,
      slugEnVerified: data.slugEnVerified.present
          ? data.slugEnVerified.value
          : this.slugEnVerified,
      slugTwVerified: data.slugTwVerified.present
          ? data.slugTwVerified.value
          : this.slugTwVerified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameTw: $nameTw, ')
          ..write('abbrEn: $abbrEn, ')
          ..write('abbrTw: $abbrTw, ')
          ..write('testament: $testament, ')
          ..write('chapterCount: $chapterCount, ')
          ..write('slugEn: $slugEn, ')
          ..write('slugTw: $slugTw, ')
          ..write('slugEnVerified: $slugEnVerified, ')
          ..write('slugTwVerified: $slugTwVerified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameEn,
    nameTw,
    abbrEn,
    abbrTw,
    testament,
    chapterCount,
    slugEn,
    slugTw,
    slugEnVerified,
    slugTwVerified,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.nameEn == this.nameEn &&
          other.nameTw == this.nameTw &&
          other.abbrEn == this.abbrEn &&
          other.abbrTw == this.abbrTw &&
          other.testament == this.testament &&
          other.chapterCount == this.chapterCount &&
          other.slugEn == this.slugEn &&
          other.slugTw == this.slugTw &&
          other.slugEnVerified == this.slugEnVerified &&
          other.slugTwVerified == this.slugTwVerified);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<String> nameEn;
  final Value<String> nameTw;
  final Value<String> abbrEn;
  final Value<String> abbrTw;
  final Value<String> testament;
  final Value<int> chapterCount;
  final Value<String> slugEn;
  final Value<String> slugTw;
  final Value<bool> slugEnVerified;
  final Value<bool> slugTwVerified;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameTw = const Value.absent(),
    this.abbrEn = const Value.absent(),
    this.abbrTw = const Value.absent(),
    this.testament = const Value.absent(),
    this.chapterCount = const Value.absent(),
    this.slugEn = const Value.absent(),
    this.slugTw = const Value.absent(),
    this.slugEnVerified = const Value.absent(),
    this.slugTwVerified = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String nameEn,
    required String nameTw,
    this.abbrEn = const Value.absent(),
    this.abbrTw = const Value.absent(),
    required String testament,
    required int chapterCount,
    required String slugEn,
    required String slugTw,
    this.slugEnVerified = const Value.absent(),
    this.slugTwVerified = const Value.absent(),
  }) : nameEn = Value(nameEn),
       nameTw = Value(nameTw),
       testament = Value(testament),
       chapterCount = Value(chapterCount),
       slugEn = Value(slugEn),
       slugTw = Value(slugTw);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<String>? nameEn,
    Expression<String>? nameTw,
    Expression<String>? abbrEn,
    Expression<String>? abbrTw,
    Expression<String>? testament,
    Expression<int>? chapterCount,
    Expression<String>? slugEn,
    Expression<String>? slugTw,
    Expression<bool>? slugEnVerified,
    Expression<bool>? slugTwVerified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameEn != null) 'name_en': nameEn,
      if (nameTw != null) 'name_tw': nameTw,
      if (abbrEn != null) 'abbr_en': abbrEn,
      if (abbrTw != null) 'abbr_tw': abbrTw,
      if (testament != null) 'testament': testament,
      if (chapterCount != null) 'chapter_count': chapterCount,
      if (slugEn != null) 'slug_en': slugEn,
      if (slugTw != null) 'slug_tw': slugTw,
      if (slugEnVerified != null) 'slug_en_verified': slugEnVerified,
      if (slugTwVerified != null) 'slug_tw_verified': slugTwVerified,
    });
  }

  BooksCompanion copyWith({
    Value<int>? id,
    Value<String>? nameEn,
    Value<String>? nameTw,
    Value<String>? abbrEn,
    Value<String>? abbrTw,
    Value<String>? testament,
    Value<int>? chapterCount,
    Value<String>? slugEn,
    Value<String>? slugTw,
    Value<bool>? slugEnVerified,
    Value<bool>? slugTwVerified,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameTw: nameTw ?? this.nameTw,
      abbrEn: abbrEn ?? this.abbrEn,
      abbrTw: abbrTw ?? this.abbrTw,
      testament: testament ?? this.testament,
      chapterCount: chapterCount ?? this.chapterCount,
      slugEn: slugEn ?? this.slugEn,
      slugTw: slugTw ?? this.slugTw,
      slugEnVerified: slugEnVerified ?? this.slugEnVerified,
      slugTwVerified: slugTwVerified ?? this.slugTwVerified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameTw.present) {
      map['name_tw'] = Variable<String>(nameTw.value);
    }
    if (abbrEn.present) {
      map['abbr_en'] = Variable<String>(abbrEn.value);
    }
    if (abbrTw.present) {
      map['abbr_tw'] = Variable<String>(abbrTw.value);
    }
    if (testament.present) {
      map['testament'] = Variable<String>(testament.value);
    }
    if (chapterCount.present) {
      map['chapter_count'] = Variable<int>(chapterCount.value);
    }
    if (slugEn.present) {
      map['slug_en'] = Variable<String>(slugEn.value);
    }
    if (slugTw.present) {
      map['slug_tw'] = Variable<String>(slugTw.value);
    }
    if (slugEnVerified.present) {
      map['slug_en_verified'] = Variable<bool>(slugEnVerified.value);
    }
    if (slugTwVerified.present) {
      map['slug_tw_verified'] = Variable<bool>(slugTwVerified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameTw: $nameTw, ')
          ..write('abbrEn: $abbrEn, ')
          ..write('abbrTw: $abbrTw, ')
          ..write('testament: $testament, ')
          ..write('chapterCount: $chapterCount, ')
          ..write('slugEn: $slugEn, ')
          ..write('slugTw: $slugTw, ')
          ..write('slugEnVerified: $slugEnVerified, ')
          ..write('slugTwVerified: $slugTwVerified')
          ..write(')'))
        .toString();
  }
}

class $StudyEntriesTable extends StudyEntries
    with TableInfo<$StudyEntriesTable, StudyEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseStartMeta = const VerificationMeta(
    'verseStart',
  );
  @override
  late final GeneratedColumn<int> verseStart = GeneratedColumn<int>(
    'verse_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseEndMeta = const VerificationMeta(
    'verseEnd',
  );
  @override
  late final GeneratedColumn<int> verseEnd = GeneratedColumn<int>(
    'verse_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseTextMeta = const VerificationMeta(
    'verseText',
  );
  @override
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
    'verse_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    chapter,
    verseStart,
    verseEnd,
    language,
    verseText,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse_start')) {
      context.handle(
        _verseStartMeta,
        verseStart.isAcceptableOrUnknown(data['verse_start']!, _verseStartMeta),
      );
    } else if (isInserting) {
      context.missing(_verseStartMeta);
    }
    if (data.containsKey('verse_end')) {
      context.handle(
        _verseEndMeta,
        verseEnd.isAcceptableOrUnknown(data['verse_end']!, _verseEndMeta),
      );
    } else if (isInserting) {
      context.missing(_verseEndMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('verse_text')) {
      context.handle(
        _verseTextMeta,
        verseText.isAcceptableOrUnknown(data['verse_text']!, _verseTextMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verseStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_start'],
      )!,
      verseEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_end'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      verseText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verse_text'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StudyEntriesTable createAlias(String alias) {
    return $StudyEntriesTable(attachedDatabase, alias);
  }
}

class StudyEntry extends DataClass implements Insertable<StudyEntry> {
  final String id;
  final int bookId;
  final int chapter;
  final int verseStart;
  final int verseEnd;
  final String language;
  final String? verseText;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StudyEntry({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verseStart,
    required this.verseEnd,
    required this.language,
    this.verseText,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse_start'] = Variable<int>(verseStart);
    map['verse_end'] = Variable<int>(verseEnd);
    map['language'] = Variable<String>(language);
    if (!nullToAbsent || verseText != null) {
      map['verse_text'] = Variable<String>(verseText);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudyEntriesCompanion toCompanion(bool nullToAbsent) {
    return StudyEntriesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verseStart: Value(verseStart),
      verseEnd: Value(verseEnd),
      language: Value(language),
      verseText: verseText == null && nullToAbsent
          ? const Value.absent()
          : Value(verseText),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudyEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyEntry(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verseStart: serializer.fromJson<int>(json['verseStart']),
      verseEnd: serializer.fromJson<int>(json['verseEnd']),
      language: serializer.fromJson<String>(json['language']),
      verseText: serializer.fromJson<String?>(json['verseText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verseStart': serializer.toJson<int>(verseStart),
      'verseEnd': serializer.toJson<int>(verseEnd),
      'language': serializer.toJson<String>(language),
      'verseText': serializer.toJson<String?>(verseText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudyEntry copyWith({
    String? id,
    int? bookId,
    int? chapter,
    int? verseStart,
    int? verseEnd,
    String? language,
    Value<String?> verseText = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StudyEntry(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verseStart: verseStart ?? this.verseStart,
    verseEnd: verseEnd ?? this.verseEnd,
    language: language ?? this.language,
    verseText: verseText.present ? verseText.value : this.verseText,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StudyEntry copyWithCompanion(StudyEntriesCompanion data) {
    return StudyEntry(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verseStart: data.verseStart.present
          ? data.verseStart.value
          : this.verseStart,
      verseEnd: data.verseEnd.present ? data.verseEnd.value : this.verseEnd,
      language: data.language.present ? data.language.value : this.language,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyEntry(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseStart: $verseStart, ')
          ..write('verseEnd: $verseEnd, ')
          ..write('language: $language, ')
          ..write('verseText: $verseText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    chapter,
    verseStart,
    verseEnd,
    language,
    verseText,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyEntry &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verseStart == this.verseStart &&
          other.verseEnd == this.verseEnd &&
          other.language == this.language &&
          other.verseText == this.verseText &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StudyEntriesCompanion extends UpdateCompanion<StudyEntry> {
  final Value<String> id;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verseStart;
  final Value<int> verseEnd;
  final Value<String> language;
  final Value<String?> verseText;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StudyEntriesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verseStart = const Value.absent(),
    this.verseEnd = const Value.absent(),
    this.language = const Value.absent(),
    this.verseText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyEntriesCompanion.insert({
    required String id,
    required int bookId,
    required int chapter,
    required int verseStart,
    required int verseEnd,
    required String language,
    this.verseText = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       chapter = Value(chapter),
       verseStart = Value(verseStart),
       verseEnd = Value(verseEnd),
       language = Value(language),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StudyEntry> custom({
    Expression<String>? id,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verseStart,
    Expression<int>? verseEnd,
    Expression<String>? language,
    Expression<String>? verseText,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verseStart != null) 'verse_start': verseStart,
      if (verseEnd != null) 'verse_end': verseEnd,
      if (language != null) 'language': language,
      if (verseText != null) 'verse_text': verseText,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verseStart,
    Value<int>? verseEnd,
    Value<String>? language,
    Value<String?>? verseText,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StudyEntriesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseStart: verseStart ?? this.verseStart,
      verseEnd: verseEnd ?? this.verseEnd,
      language: language ?? this.language,
      verseText: verseText ?? this.verseText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verseStart.present) {
      map['verse_start'] = Variable<int>(verseStart.value);
    }
    if (verseEnd.present) {
      map['verse_end'] = Variable<int>(verseEnd.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (verseText.present) {
      map['verse_text'] = Variable<String>(verseText.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyEntriesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseStart: $verseStart, ')
          ..write('verseEnd: $verseEnd, ')
          ..write('language: $language, ')
          ..write('verseText: $verseText, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('FF6750A4'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, colorHex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String name;
  final String colorHex;
  const Tag({required this.id, required this.name, required this.colorHex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color_hex'] = Variable<String>(colorHex);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      name: Value(name),
      colorHex: Value(colorHex),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'colorHex': serializer.toJson<String>(colorHex),
    };
  }

  Tag copyWith({String? id, String? name, String? colorHex}) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    colorHex: colorHex ?? this.colorHex,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorHex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorHex == this.colorHex);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> colorHex;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String name,
    this.colorHex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? colorHex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorHex != null) 'color_hex': colorHex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? colorHex,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorHex: $colorHex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyNotesTable extends StudyNotes
    with TableInfo<$StudyNotesTable, StudyNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteTextMeta = const VerificationMeta(
    'noteText',
  );
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
    'note_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studyEntryIdMeta = const VerificationMeta(
    'studyEntryId',
  );
  @override
  late final GeneratedColumn<String> studyEntryId = GeneratedColumn<String>(
    'study_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_entries (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    noteText,
    source,
    studyEntryId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(
        _noteTextMeta,
        noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta),
      );
    } else if (isInserting) {
      context.missing(_noteTextMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('study_entry_id')) {
      context.handle(
        _studyEntryIdMeta,
        studyEntryId.isAcceptableOrUnknown(
          data['study_entry_id']!,
          _studyEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      noteText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_text'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      studyEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}study_entry_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StudyNotesTable createAlias(String alias) {
    return $StudyNotesTable(attachedDatabase, alias);
  }
}

class StudyNote extends DataClass implements Insertable<StudyNote> {
  final String id;
  final String noteText;
  final String source;
  final String? studyEntryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const StudyNote({
    required this.id,
    required this.noteText,
    required this.source,
    this.studyEntryId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['note_text'] = Variable<String>(noteText);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || studyEntryId != null) {
      map['study_entry_id'] = Variable<String>(studyEntryId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StudyNotesCompanion toCompanion(bool nullToAbsent) {
    return StudyNotesCompanion(
      id: Value(id),
      noteText: Value(noteText),
      source: Value(source),
      studyEntryId: studyEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(studyEntryId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudyNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyNote(
      id: serializer.fromJson<String>(json['id']),
      noteText: serializer.fromJson<String>(json['noteText']),
      source: serializer.fromJson<String>(json['source']),
      studyEntryId: serializer.fromJson<String?>(json['studyEntryId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'noteText': serializer.toJson<String>(noteText),
      'source': serializer.toJson<String>(source),
      'studyEntryId': serializer.toJson<String?>(studyEntryId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StudyNote copyWith({
    String? id,
    String? noteText,
    String? source,
    Value<String?> studyEntryId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => StudyNote(
    id: id ?? this.id,
    noteText: noteText ?? this.noteText,
    source: source ?? this.source,
    studyEntryId: studyEntryId.present ? studyEntryId.value : this.studyEntryId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StudyNote copyWithCompanion(StudyNotesCompanion data) {
    return StudyNote(
      id: data.id.present ? data.id.value : this.id,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      source: data.source.present ? data.source.value : this.source,
      studyEntryId: data.studyEntryId.present
          ? data.studyEntryId.value
          : this.studyEntryId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyNote(')
          ..write('id: $id, ')
          ..write('noteText: $noteText, ')
          ..write('source: $source, ')
          ..write('studyEntryId: $studyEntryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, noteText, source, studyEntryId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyNote &&
          other.id == this.id &&
          other.noteText == this.noteText &&
          other.source == this.source &&
          other.studyEntryId == this.studyEntryId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class StudyNotesCompanion extends UpdateCompanion<StudyNote> {
  final Value<String> id;
  final Value<String> noteText;
  final Value<String> source;
  final Value<String?> studyEntryId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StudyNotesCompanion({
    this.id = const Value.absent(),
    this.noteText = const Value.absent(),
    this.source = const Value.absent(),
    this.studyEntryId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyNotesCompanion.insert({
    required String id,
    required String noteText,
    required String source,
    this.studyEntryId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       noteText = Value(noteText),
       source = Value(source),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<StudyNote> custom({
    Expression<String>? id,
    Expression<String>? noteText,
    Expression<String>? source,
    Expression<String>? studyEntryId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (noteText != null) 'note_text': noteText,
      if (source != null) 'source': source,
      if (studyEntryId != null) 'study_entry_id': studyEntryId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? noteText,
    Value<String>? source,
    Value<String?>? studyEntryId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StudyNotesCompanion(
      id: id ?? this.id,
      noteText: noteText ?? this.noteText,
      source: source ?? this.source,
      studyEntryId: studyEntryId ?? this.studyEntryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (studyEntryId.present) {
      map['study_entry_id'] = Variable<String>(studyEntryId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyNotesCompanion(')
          ..write('id: $id, ')
          ..write('noteText: $noteText, ')
          ..write('source: $source, ')
          ..write('studyEntryId: $studyEntryId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NoteTagLinksTable extends NoteTagLinks
    with TableInfo<$NoteTagLinksTable, NoteTagLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoteTagLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES study_notes (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [noteId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'note_tag_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteTagLink> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId, tagId};
  @override
  NoteTagLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteTagLink(
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $NoteTagLinksTable createAlias(String alias) {
    return $NoteTagLinksTable(attachedDatabase, alias);
  }
}

class NoteTagLink extends DataClass implements Insertable<NoteTagLink> {
  final String noteId;
  final String tagId;
  const NoteTagLink({required this.noteId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  NoteTagLinksCompanion toCompanion(bool nullToAbsent) {
    return NoteTagLinksCompanion(noteId: Value(noteId), tagId: Value(tagId));
  }

  factory NoteTagLink.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteTagLink(
      noteId: serializer.fromJson<String>(json['noteId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  NoteTagLink copyWith({String? noteId, String? tagId}) =>
      NoteTagLink(noteId: noteId ?? this.noteId, tagId: tagId ?? this.tagId);
  NoteTagLink copyWithCompanion(NoteTagLinksCompanion data) {
    return NoteTagLink(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteTagLink(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteTagLink &&
          other.noteId == this.noteId &&
          other.tagId == this.tagId);
}

class NoteTagLinksCompanion extends UpdateCompanion<NoteTagLink> {
  final Value<String> noteId;
  final Value<String> tagId;
  final Value<int> rowid;
  const NoteTagLinksCompanion({
    this.noteId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NoteTagLinksCompanion.insert({
    required String noteId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : noteId = Value(noteId),
       tagId = Value(tagId);
  static Insertable<NoteTagLink> custom({
    Expression<String>? noteId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NoteTagLinksCompanion copyWith({
    Value<String>? noteId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return NoteTagLinksCompanion(
      noteId: noteId ?? this.noteId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoteTagLinksCompanion(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TalksTable extends Talks with TableInfo<$TalksTable, Talk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TalksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speakerMeta = const VerificationMeta(
    'speaker',
  );
  @override
  late final GeneratedColumn<String> speaker = GeneratedColumn<String>(
    'speaker',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, speaker, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'talks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Talk> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('speaker')) {
      context.handle(
        _speakerMeta,
        speaker.isAcceptableOrUnknown(data['speaker']!, _speakerMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Talk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Talk(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      speaker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}speaker'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $TalksTable createAlias(String alias) {
    return $TalksTable(attachedDatabase, alias);
  }
}

class Talk extends DataClass implements Insertable<Talk> {
  final String id;
  final String title;
  final String? speaker;
  final DateTime date;
  const Talk({
    required this.id,
    required this.title,
    this.speaker,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || speaker != null) {
      map['speaker'] = Variable<String>(speaker);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  TalksCompanion toCompanion(bool nullToAbsent) {
    return TalksCompanion(
      id: Value(id),
      title: Value(title),
      speaker: speaker == null && nullToAbsent
          ? const Value.absent()
          : Value(speaker),
      date: Value(date),
    );
  }

  factory Talk.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Talk(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      speaker: serializer.fromJson<String?>(json['speaker']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'speaker': serializer.toJson<String?>(speaker),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  Talk copyWith({
    String? id,
    String? title,
    Value<String?> speaker = const Value.absent(),
    DateTime? date,
  }) => Talk(
    id: id ?? this.id,
    title: title ?? this.title,
    speaker: speaker.present ? speaker.value : this.speaker,
    date: date ?? this.date,
  );
  Talk copyWithCompanion(TalksCompanion data) {
    return Talk(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      speaker: data.speaker.present ? data.speaker.value : this.speaker,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Talk(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('speaker: $speaker, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, speaker, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Talk &&
          other.id == this.id &&
          other.title == this.title &&
          other.speaker == this.speaker &&
          other.date == this.date);
}

class TalksCompanion extends UpdateCompanion<Talk> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> speaker;
  final Value<DateTime> date;
  final Value<int> rowid;
  const TalksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.speaker = const Value.absent(),
    this.date = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TalksCompanion.insert({
    required String id,
    required String title,
    this.speaker = const Value.absent(),
    required DateTime date,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       date = Value(date);
  static Insertable<Talk> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? speaker,
    Expression<DateTime>? date,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (speaker != null) 'speaker': speaker,
      if (date != null) 'date': date,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TalksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? speaker,
    Value<DateTime>? date,
    Value<int>? rowid,
  }) {
    return TalksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      speaker: speaker ?? this.speaker,
      date: date ?? this.date,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (speaker.present) {
      map['speaker'] = Variable<String>(speaker.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TalksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('speaker: $speaker, ')
          ..write('date: $date, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TalkPointsTable extends TalkPoints
    with TableInfo<$TalkPointsTable, TalkPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TalkPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _talkIdMeta = const VerificationMeta('talkId');
  @override
  late final GeneratedColumn<String> talkId = GeneratedColumn<String>(
    'talk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES talks (id)',
    ),
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointTextMeta = const VerificationMeta(
    'pointText',
  );
  @override
  late final GeneratedColumn<String> pointText = GeneratedColumn<String>(
    'point_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkedStudyEntryIdMeta =
      const VerificationMeta('linkedStudyEntryId');
  @override
  late final GeneratedColumn<String> linkedStudyEntryId =
      GeneratedColumn<String>(
        'linked_study_entry_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES study_entries (id)',
        ),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    talkId,
    orderIndex,
    pointText,
    linkedStudyEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'talk_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TalkPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('talk_id')) {
      context.handle(
        _talkIdMeta,
        talkId.isAcceptableOrUnknown(data['talk_id']!, _talkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_talkIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('point_text')) {
      context.handle(
        _pointTextMeta,
        pointText.isAcceptableOrUnknown(data['point_text']!, _pointTextMeta),
      );
    } else if (isInserting) {
      context.missing(_pointTextMeta);
    }
    if (data.containsKey('linked_study_entry_id')) {
      context.handle(
        _linkedStudyEntryIdMeta,
        linkedStudyEntryId.isAcceptableOrUnknown(
          data['linked_study_entry_id']!,
          _linkedStudyEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TalkPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TalkPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      talkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}talk_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      pointText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}point_text'],
      )!,
      linkedStudyEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_study_entry_id'],
      ),
    );
  }

  @override
  $TalkPointsTable createAlias(String alias) {
    return $TalkPointsTable(attachedDatabase, alias);
  }
}

class TalkPoint extends DataClass implements Insertable<TalkPoint> {
  final String id;
  final String talkId;
  final int orderIndex;
  final String pointText;
  final String? linkedStudyEntryId;
  const TalkPoint({
    required this.id,
    required this.talkId,
    required this.orderIndex,
    required this.pointText,
    this.linkedStudyEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['talk_id'] = Variable<String>(talkId);
    map['order_index'] = Variable<int>(orderIndex);
    map['point_text'] = Variable<String>(pointText);
    if (!nullToAbsent || linkedStudyEntryId != null) {
      map['linked_study_entry_id'] = Variable<String>(linkedStudyEntryId);
    }
    return map;
  }

  TalkPointsCompanion toCompanion(bool nullToAbsent) {
    return TalkPointsCompanion(
      id: Value(id),
      talkId: Value(talkId),
      orderIndex: Value(orderIndex),
      pointText: Value(pointText),
      linkedStudyEntryId: linkedStudyEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedStudyEntryId),
    );
  }

  factory TalkPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TalkPoint(
      id: serializer.fromJson<String>(json['id']),
      talkId: serializer.fromJson<String>(json['talkId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      pointText: serializer.fromJson<String>(json['pointText']),
      linkedStudyEntryId: serializer.fromJson<String?>(
        json['linkedStudyEntryId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'talkId': serializer.toJson<String>(talkId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'pointText': serializer.toJson<String>(pointText),
      'linkedStudyEntryId': serializer.toJson<String?>(linkedStudyEntryId),
    };
  }

  TalkPoint copyWith({
    String? id,
    String? talkId,
    int? orderIndex,
    String? pointText,
    Value<String?> linkedStudyEntryId = const Value.absent(),
  }) => TalkPoint(
    id: id ?? this.id,
    talkId: talkId ?? this.talkId,
    orderIndex: orderIndex ?? this.orderIndex,
    pointText: pointText ?? this.pointText,
    linkedStudyEntryId: linkedStudyEntryId.present
        ? linkedStudyEntryId.value
        : this.linkedStudyEntryId,
  );
  TalkPoint copyWithCompanion(TalkPointsCompanion data) {
    return TalkPoint(
      id: data.id.present ? data.id.value : this.id,
      talkId: data.talkId.present ? data.talkId.value : this.talkId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      pointText: data.pointText.present ? data.pointText.value : this.pointText,
      linkedStudyEntryId: data.linkedStudyEntryId.present
          ? data.linkedStudyEntryId.value
          : this.linkedStudyEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TalkPoint(')
          ..write('id: $id, ')
          ..write('talkId: $talkId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('pointText: $pointText, ')
          ..write('linkedStudyEntryId: $linkedStudyEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, talkId, orderIndex, pointText, linkedStudyEntryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TalkPoint &&
          other.id == this.id &&
          other.talkId == this.talkId &&
          other.orderIndex == this.orderIndex &&
          other.pointText == this.pointText &&
          other.linkedStudyEntryId == this.linkedStudyEntryId);
}

class TalkPointsCompanion extends UpdateCompanion<TalkPoint> {
  final Value<String> id;
  final Value<String> talkId;
  final Value<int> orderIndex;
  final Value<String> pointText;
  final Value<String?> linkedStudyEntryId;
  final Value<int> rowid;
  const TalkPointsCompanion({
    this.id = const Value.absent(),
    this.talkId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.pointText = const Value.absent(),
    this.linkedStudyEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TalkPointsCompanion.insert({
    required String id,
    required String talkId,
    required int orderIndex,
    required String pointText,
    this.linkedStudyEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       talkId = Value(talkId),
       orderIndex = Value(orderIndex),
       pointText = Value(pointText);
  static Insertable<TalkPoint> custom({
    Expression<String>? id,
    Expression<String>? talkId,
    Expression<int>? orderIndex,
    Expression<String>? pointText,
    Expression<String>? linkedStudyEntryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (talkId != null) 'talk_id': talkId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (pointText != null) 'point_text': pointText,
      if (linkedStudyEntryId != null)
        'linked_study_entry_id': linkedStudyEntryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TalkPointsCompanion copyWith({
    Value<String>? id,
    Value<String>? talkId,
    Value<int>? orderIndex,
    Value<String>? pointText,
    Value<String?>? linkedStudyEntryId,
    Value<int>? rowid,
  }) {
    return TalkPointsCompanion(
      id: id ?? this.id,
      talkId: talkId ?? this.talkId,
      orderIndex: orderIndex ?? this.orderIndex,
      pointText: pointText ?? this.pointText,
      linkedStudyEntryId: linkedStudyEntryId ?? this.linkedStudyEntryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (talkId.present) {
      map['talk_id'] = Variable<String>(talkId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (pointText.present) {
      map['point_text'] = Variable<String>(pointText.value);
    }
    if (linkedStudyEntryId.present) {
      map['linked_study_entry_id'] = Variable<String>(linkedStudyEntryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TalkPointsCompanion(')
          ..write('id: $id, ')
          ..write('talkId: $talkId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('pointText: $pointText, ')
          ..write('linkedStudyEntryId: $linkedStudyEntryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizSessionsTable extends QuizSessions
    with TableInfo<$QuizSessionsTable, QuizSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeTypeMeta = const VerificationMeta(
    'scopeType',
  );
  @override
  late final GeneratedColumn<String> scopeType = GeneratedColumn<String>(
    'scope_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeRefJsonMeta = const VerificationMeta(
    'scopeRefJson',
  );
  @override
  late final GeneratedColumn<String> scopeRefJson = GeneratedColumn<String>(
    'scope_ref_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizTypeMeta = const VerificationMeta(
    'quizType',
  );
  @override
  late final GeneratedColumn<String> quizType = GeneratedColumn<String>(
    'quiz_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    scopeType,
    scopeRefJson,
    quizType,
    startedAt,
    finishedAt,
    score,
    totalQuestions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scope_type')) {
      context.handle(
        _scopeTypeMeta,
        scopeType.isAcceptableOrUnknown(data['scope_type']!, _scopeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeTypeMeta);
    }
    if (data.containsKey('scope_ref_json')) {
      context.handle(
        _scopeRefJsonMeta,
        scopeRefJson.isAcceptableOrUnknown(
          data['scope_ref_json']!,
          _scopeRefJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scopeRefJsonMeta);
    }
    if (data.containsKey('quiz_type')) {
      context.handle(
        _quizTypeMeta,
        quizType.isAcceptableOrUnknown(data['quiz_type']!, _quizTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_quizTypeMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      scopeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_type'],
      )!,
      scopeRefJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_ref_json'],
      )!,
      quizType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_type'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
    );
  }

  @override
  $QuizSessionsTable createAlias(String alias) {
    return $QuizSessionsTable(attachedDatabase, alias);
  }
}

class QuizSession extends DataClass implements Insertable<QuizSession> {
  final String id;
  final String scopeType;
  final String scopeRefJson;
  final String quizType;
  final DateTime startedAt;
  final DateTime? finishedAt;
  final int score;
  final int totalQuestions;
  const QuizSession({
    required this.id,
    required this.scopeType,
    required this.scopeRefJson,
    required this.quizType,
    required this.startedAt,
    this.finishedAt,
    required this.score,
    required this.totalQuestions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['scope_type'] = Variable<String>(scopeType);
    map['scope_ref_json'] = Variable<String>(scopeRefJson);
    map['quiz_type'] = Variable<String>(quizType);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    map['score'] = Variable<int>(score);
    map['total_questions'] = Variable<int>(totalQuestions);
    return map;
  }

  QuizSessionsCompanion toCompanion(bool nullToAbsent) {
    return QuizSessionsCompanion(
      id: Value(id),
      scopeType: Value(scopeType),
      scopeRefJson: Value(scopeRefJson),
      quizType: Value(quizType),
      startedAt: Value(startedAt),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
      score: Value(score),
      totalQuestions: Value(totalQuestions),
    );
  }

  factory QuizSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizSession(
      id: serializer.fromJson<String>(json['id']),
      scopeType: serializer.fromJson<String>(json['scopeType']),
      scopeRefJson: serializer.fromJson<String>(json['scopeRefJson']),
      quizType: serializer.fromJson<String>(json['quizType']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
      score: serializer.fromJson<int>(json['score']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scopeType': serializer.toJson<String>(scopeType),
      'scopeRefJson': serializer.toJson<String>(scopeRefJson),
      'quizType': serializer.toJson<String>(quizType),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
      'score': serializer.toJson<int>(score),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
    };
  }

  QuizSession copyWith({
    String? id,
    String? scopeType,
    String? scopeRefJson,
    String? quizType,
    DateTime? startedAt,
    Value<DateTime?> finishedAt = const Value.absent(),
    int? score,
    int? totalQuestions,
  }) => QuizSession(
    id: id ?? this.id,
    scopeType: scopeType ?? this.scopeType,
    scopeRefJson: scopeRefJson ?? this.scopeRefJson,
    quizType: quizType ?? this.quizType,
    startedAt: startedAt ?? this.startedAt,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
    score: score ?? this.score,
    totalQuestions: totalQuestions ?? this.totalQuestions,
  );
  QuizSession copyWithCompanion(QuizSessionsCompanion data) {
    return QuizSession(
      id: data.id.present ? data.id.value : this.id,
      scopeType: data.scopeType.present ? data.scopeType.value : this.scopeType,
      scopeRefJson: data.scopeRefJson.present
          ? data.scopeRefJson.value
          : this.scopeRefJson,
      quizType: data.quizType.present ? data.quizType.value : this.quizType,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
      score: data.score.present ? data.score.value : this.score,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizSession(')
          ..write('id: $id, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeRefJson: $scopeRefJson, ')
          ..write('quizType: $quizType, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    scopeType,
    scopeRefJson,
    quizType,
    startedAt,
    finishedAt,
    score,
    totalQuestions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizSession &&
          other.id == this.id &&
          other.scopeType == this.scopeType &&
          other.scopeRefJson == this.scopeRefJson &&
          other.quizType == this.quizType &&
          other.startedAt == this.startedAt &&
          other.finishedAt == this.finishedAt &&
          other.score == this.score &&
          other.totalQuestions == this.totalQuestions);
}

class QuizSessionsCompanion extends UpdateCompanion<QuizSession> {
  final Value<String> id;
  final Value<String> scopeType;
  final Value<String> scopeRefJson;
  final Value<String> quizType;
  final Value<DateTime> startedAt;
  final Value<DateTime?> finishedAt;
  final Value<int> score;
  final Value<int> totalQuestions;
  final Value<int> rowid;
  const QuizSessionsCompanion({
    this.id = const Value.absent(),
    this.scopeType = const Value.absent(),
    this.scopeRefJson = const Value.absent(),
    this.quizType = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.finishedAt = const Value.absent(),
    this.score = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizSessionsCompanion.insert({
    required String id,
    required String scopeType,
    required String scopeRefJson,
    required String quizType,
    required DateTime startedAt,
    this.finishedAt = const Value.absent(),
    this.score = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       scopeType = Value(scopeType),
       scopeRefJson = Value(scopeRefJson),
       quizType = Value(quizType),
       startedAt = Value(startedAt);
  static Insertable<QuizSession> custom({
    Expression<String>? id,
    Expression<String>? scopeType,
    Expression<String>? scopeRefJson,
    Expression<String>? quizType,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? finishedAt,
    Expression<int>? score,
    Expression<int>? totalQuestions,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scopeType != null) 'scope_type': scopeType,
      if (scopeRefJson != null) 'scope_ref_json': scopeRefJson,
      if (quizType != null) 'quiz_type': quizType,
      if (startedAt != null) 'started_at': startedAt,
      if (finishedAt != null) 'finished_at': finishedAt,
      if (score != null) 'score': score,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? scopeType,
    Value<String>? scopeRefJson,
    Value<String>? quizType,
    Value<DateTime>? startedAt,
    Value<DateTime?>? finishedAt,
    Value<int>? score,
    Value<int>? totalQuestions,
    Value<int>? rowid,
  }) {
    return QuizSessionsCompanion(
      id: id ?? this.id,
      scopeType: scopeType ?? this.scopeType,
      scopeRefJson: scopeRefJson ?? this.scopeRefJson,
      quizType: quizType ?? this.quizType,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scopeType.present) {
      map['scope_type'] = Variable<String>(scopeType.value);
    }
    if (scopeRefJson.present) {
      map['scope_ref_json'] = Variable<String>(scopeRefJson.value);
    }
    if (quizType.present) {
      map['quiz_type'] = Variable<String>(quizType.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizSessionsCompanion(')
          ..write('id: $id, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeRefJson: $scopeRefJson, ')
          ..write('quizType: $quizType, ')
          ..write('startedAt: $startedAt, ')
          ..write('finishedAt: $finishedAt, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizAttemptsTable extends QuizAttempts
    with TableInfo<$QuizAttemptsTable, QuizAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quiz_sessions (id)',
    ),
  );
  static const VerificationMeta _promptTextMeta = const VerificationMeta(
    'promptText',
  );
  @override
  late final GeneratedColumn<String> promptText = GeneratedColumn<String>(
    'prompt_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswerMeta = const VerificationMeta(
    'correctAnswer',
  );
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
    'correct_answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userAnswerMeta = const VerificationMeta(
    'userAnswer',
  );
  @override
  late final GeneratedColumn<String> userAnswer = GeneratedColumn<String>(
    'user_answer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    promptText,
    correctAnswer,
    userAnswer,
    isCorrect,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('prompt_text')) {
      context.handle(
        _promptTextMeta,
        promptText.isAcceptableOrUnknown(data['prompt_text']!, _promptTextMeta),
      );
    } else if (isInserting) {
      context.missing(_promptTextMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
        _correctAnswerMeta,
        correctAnswer.isAcceptableOrUnknown(
          data['correct_answer']!,
          _correctAnswerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('user_answer')) {
      context.handle(
        _userAnswerMeta,
        userAnswer.isAcceptableOrUnknown(data['user_answer']!, _userAnswerMeta),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      promptText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt_text'],
      )!,
      correctAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}correct_answer'],
      )!,
      userAnswer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_answer'],
      ),
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
    );
  }

  @override
  $QuizAttemptsTable createAlias(String alias) {
    return $QuizAttemptsTable(attachedDatabase, alias);
  }
}

class QuizAttempt extends DataClass implements Insertable<QuizAttempt> {
  final String id;
  final String sessionId;
  final String promptText;
  final String correctAnswer;
  final String? userAnswer;
  final bool isCorrect;
  const QuizAttempt({
    required this.id,
    required this.sessionId,
    required this.promptText,
    required this.correctAnswer,
    this.userAnswer,
    required this.isCorrect,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['prompt_text'] = Variable<String>(promptText);
    map['correct_answer'] = Variable<String>(correctAnswer);
    if (!nullToAbsent || userAnswer != null) {
      map['user_answer'] = Variable<String>(userAnswer);
    }
    map['is_correct'] = Variable<bool>(isCorrect);
    return map;
  }

  QuizAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuizAttemptsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      promptText: Value(promptText),
      correctAnswer: Value(correctAnswer),
      userAnswer: userAnswer == null && nullToAbsent
          ? const Value.absent()
          : Value(userAnswer),
      isCorrect: Value(isCorrect),
    );
  }

  factory QuizAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizAttempt(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      promptText: serializer.fromJson<String>(json['promptText']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      userAnswer: serializer.fromJson<String?>(json['userAnswer']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'promptText': serializer.toJson<String>(promptText),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'userAnswer': serializer.toJson<String?>(userAnswer),
      'isCorrect': serializer.toJson<bool>(isCorrect),
    };
  }

  QuizAttempt copyWith({
    String? id,
    String? sessionId,
    String? promptText,
    String? correctAnswer,
    Value<String?> userAnswer = const Value.absent(),
    bool? isCorrect,
  }) => QuizAttempt(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    promptText: promptText ?? this.promptText,
    correctAnswer: correctAnswer ?? this.correctAnswer,
    userAnswer: userAnswer.present ? userAnswer.value : this.userAnswer,
    isCorrect: isCorrect ?? this.isCorrect,
  );
  QuizAttempt copyWithCompanion(QuizAttemptsCompanion data) {
    return QuizAttempt(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      promptText: data.promptText.present
          ? data.promptText.value
          : this.promptText,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      userAnswer: data.userAnswer.present
          ? data.userAnswer.value
          : this.userAnswer,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttempt(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('promptText: $promptText, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    promptText,
    correctAnswer,
    userAnswer,
    isCorrect,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizAttempt &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.promptText == this.promptText &&
          other.correctAnswer == this.correctAnswer &&
          other.userAnswer == this.userAnswer &&
          other.isCorrect == this.isCorrect);
}

class QuizAttemptsCompanion extends UpdateCompanion<QuizAttempt> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> promptText;
  final Value<String> correctAnswer;
  final Value<String?> userAnswer;
  final Value<bool> isCorrect;
  final Value<int> rowid;
  const QuizAttemptsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.promptText = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.userAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizAttemptsCompanion.insert({
    required String id,
    required String sessionId,
    required String promptText,
    required String correctAnswer,
    this.userAnswer = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       promptText = Value(promptText),
       correctAnswer = Value(correctAnswer);
  static Insertable<QuizAttempt> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? promptText,
    Expression<String>? correctAnswer,
    Expression<String>? userAnswer,
    Expression<bool>? isCorrect,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (promptText != null) 'prompt_text': promptText,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (userAnswer != null) 'user_answer': userAnswer,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizAttemptsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? promptText,
    Value<String>? correctAnswer,
    Value<String?>? userAnswer,
    Value<bool>? isCorrect,
    Value<int>? rowid,
  }) {
    return QuizAttemptsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      promptText: promptText ?? this.promptText,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      userAnswer: userAnswer ?? this.userAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (promptText.present) {
      map['prompt_text'] = Variable<String>(promptText.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (userAnswer.present) {
      map['user_answer'] = Variable<String>(userAnswer.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('promptText: $promptText, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('userAnswer: $userAnswer, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderSettingsTable extends ReminderSettings
    with TableInfo<$ReminderSettingsTable, ReminderSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(18),
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [weekday, enabled, hour, minute];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weekday};
  @override
  ReminderSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderSetting(
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
    );
  }

  @override
  $ReminderSettingsTable createAlias(String alias) {
    return $ReminderSettingsTable(attachedDatabase, alias);
  }
}

class ReminderSetting extends DataClass implements Insertable<ReminderSetting> {
  final int weekday;
  final bool enabled;
  final int hour;
  final int minute;
  const ReminderSetting({
    required this.weekday,
    required this.enabled,
    required this.hour,
    required this.minute,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['weekday'] = Variable<int>(weekday);
    map['enabled'] = Variable<bool>(enabled);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    return map;
  }

  ReminderSettingsCompanion toCompanion(bool nullToAbsent) {
    return ReminderSettingsCompanion(
      weekday: Value(weekday),
      enabled: Value(enabled),
      hour: Value(hour),
      minute: Value(minute),
    );
  }

  factory ReminderSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderSetting(
      weekday: serializer.fromJson<int>(json['weekday']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weekday': serializer.toJson<int>(weekday),
      'enabled': serializer.toJson<bool>(enabled),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
    };
  }

  ReminderSetting copyWith({
    int? weekday,
    bool? enabled,
    int? hour,
    int? minute,
  }) => ReminderSetting(
    weekday: weekday ?? this.weekday,
    enabled: enabled ?? this.enabled,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
  );
  ReminderSetting copyWithCompanion(ReminderSettingsCompanion data) {
    return ReminderSetting(
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSetting(')
          ..write('weekday: $weekday, ')
          ..write('enabled: $enabled, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(weekday, enabled, hour, minute);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderSetting &&
          other.weekday == this.weekday &&
          other.enabled == this.enabled &&
          other.hour == this.hour &&
          other.minute == this.minute);
}

class ReminderSettingsCompanion extends UpdateCompanion<ReminderSetting> {
  final Value<int> weekday;
  final Value<bool> enabled;
  final Value<int> hour;
  final Value<int> minute;
  const ReminderSettingsCompanion({
    this.weekday = const Value.absent(),
    this.enabled = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
  });
  ReminderSettingsCompanion.insert({
    this.weekday = const Value.absent(),
    this.enabled = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
  });
  static Insertable<ReminderSetting> custom({
    Expression<int>? weekday,
    Expression<bool>? enabled,
    Expression<int>? hour,
    Expression<int>? minute,
  }) {
    return RawValuesInsertable({
      if (weekday != null) 'weekday': weekday,
      if (enabled != null) 'enabled': enabled,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
    });
  }

  ReminderSettingsCompanion copyWith({
    Value<int>? weekday,
    Value<bool>? enabled,
    Value<int>? hour,
    Value<int>? minute,
  }) {
    return ReminderSettingsCompanion(
      weekday: weekday ?? this.weekday,
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsCompanion(')
          ..write('weekday: $weekday, ')
          ..write('enabled: $enabled, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTable books = $BooksTable(this);
  late final $StudyEntriesTable studyEntries = $StudyEntriesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $StudyNotesTable studyNotes = $StudyNotesTable(this);
  late final $NoteTagLinksTable noteTagLinks = $NoteTagLinksTable(this);
  late final $TalksTable talks = $TalksTable(this);
  late final $TalkPointsTable talkPoints = $TalkPointsTable(this);
  late final $QuizSessionsTable quizSessions = $QuizSessionsTable(this);
  late final $QuizAttemptsTable quizAttempts = $QuizAttemptsTable(this);
  late final $ReminderSettingsTable reminderSettings = $ReminderSettingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    books,
    studyEntries,
    tags,
    studyNotes,
    noteTagLinks,
    talks,
    talkPoints,
    quizSessions,
    quizAttempts,
    reminderSettings,
  ];
}

typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      required String nameEn,
      required String nameTw,
      Value<String> abbrEn,
      Value<String> abbrTw,
      required String testament,
      required int chapterCount,
      required String slugEn,
      required String slugTw,
      Value<bool> slugEnVerified,
      Value<bool> slugTwVerified,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      Value<String> nameEn,
      Value<String> nameTw,
      Value<String> abbrEn,
      Value<String> abbrTw,
      Value<String> testament,
      Value<int> chapterCount,
      Value<String> slugEn,
      Value<String> slugTw,
      Value<bool> slugEnVerified,
      Value<bool> slugTwVerified,
    });

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, Book> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StudyEntriesTable, List<StudyEntry>>
  _studyEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyEntries,
    aliasName: 'books__id__study_entries__book_id',
  );

  $$StudyEntriesTableProcessedTableManager get studyEntriesRefs {
    final manager = $$StudyEntriesTableTableManager(
      $_db,
      $_db.studyEntries,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTw => $composableBuilder(
    column: $table.nameTw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abbrEn => $composableBuilder(
    column: $table.abbrEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get abbrTw => $composableBuilder(
    column: $table.abbrTw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testament => $composableBuilder(
    column: $table.testament,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slugEn => $composableBuilder(
    column: $table.slugEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slugTw => $composableBuilder(
    column: $table.slugTw,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get slugEnVerified => $composableBuilder(
    column: $table.slugEnVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get slugTwVerified => $composableBuilder(
    column: $table.slugTwVerified,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> studyEntriesRefs(
    Expression<bool> Function($$StudyEntriesTableFilterComposer f) f,
  ) {
    final $$StudyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTw => $composableBuilder(
    column: $table.nameTw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abbrEn => $composableBuilder(
    column: $table.abbrEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get abbrTw => $composableBuilder(
    column: $table.abbrTw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testament => $composableBuilder(
    column: $table.testament,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slugEn => $composableBuilder(
    column: $table.slugEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slugTw => $composableBuilder(
    column: $table.slugTw,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get slugEnVerified => $composableBuilder(
    column: $table.slugEnVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get slugTwVerified => $composableBuilder(
    column: $table.slugTwVerified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameTw =>
      $composableBuilder(column: $table.nameTw, builder: (column) => column);

  GeneratedColumn<String> get abbrEn =>
      $composableBuilder(column: $table.abbrEn, builder: (column) => column);

  GeneratedColumn<String> get abbrTw =>
      $composableBuilder(column: $table.abbrTw, builder: (column) => column);

  GeneratedColumn<String> get testament =>
      $composableBuilder(column: $table.testament, builder: (column) => column);

  GeneratedColumn<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slugEn =>
      $composableBuilder(column: $table.slugEn, builder: (column) => column);

  GeneratedColumn<String> get slugTw =>
      $composableBuilder(column: $table.slugTw, builder: (column) => column);

  GeneratedColumn<bool> get slugEnVerified => $composableBuilder(
    column: $table.slugEnVerified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get slugTwVerified => $composableBuilder(
    column: $table.slugTwVerified,
    builder: (column) => column,
  );

  Expression<T> studyEntriesRefs<T extends Object>(
    Expression<T> Function($$StudyEntriesTableAnnotationComposer a) f,
  ) {
    final $$StudyEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, $$BooksTableReferences),
          Book,
          PrefetchHooks Function({bool studyEntriesRefs})
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameTw = const Value.absent(),
                Value<String> abbrEn = const Value.absent(),
                Value<String> abbrTw = const Value.absent(),
                Value<String> testament = const Value.absent(),
                Value<int> chapterCount = const Value.absent(),
                Value<String> slugEn = const Value.absent(),
                Value<String> slugTw = const Value.absent(),
                Value<bool> slugEnVerified = const Value.absent(),
                Value<bool> slugTwVerified = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                nameEn: nameEn,
                nameTw: nameTw,
                abbrEn: abbrEn,
                abbrTw: abbrTw,
                testament: testament,
                chapterCount: chapterCount,
                slugEn: slugEn,
                slugTw: slugTw,
                slugEnVerified: slugEnVerified,
                slugTwVerified: slugTwVerified,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nameEn,
                required String nameTw,
                Value<String> abbrEn = const Value.absent(),
                Value<String> abbrTw = const Value.absent(),
                required String testament,
                required int chapterCount,
                required String slugEn,
                required String slugTw,
                Value<bool> slugEnVerified = const Value.absent(),
                Value<bool> slugTwVerified = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                nameEn: nameEn,
                nameTw: nameTw,
                abbrEn: abbrEn,
                abbrTw: abbrTw,
                testament: testament,
                chapterCount: chapterCount,
                slugEn: slugEn,
                slugTw: slugTw,
                slugEnVerified: slugEnVerified,
                slugTwVerified: slugTwVerified,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BooksTable, Book>(table),
                  $$BooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({studyEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (studyEntriesRefs) db.studyEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (studyEntriesRefs)
                    await $_getPrefetchedData<Book, $BooksTable, StudyEntry>(
                      currentTable: table,
                      referencedTable: $$BooksTableReferences
                          ._studyEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$BooksTableReferences(
                        db,
                        table,
                        p0,
                      ).studyEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.bookId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, $$BooksTableReferences),
      Book,
      PrefetchHooks Function({bool studyEntriesRefs})
    >;
typedef $$StudyEntriesTableCreateCompanionBuilder =
    StudyEntriesCompanion Function({
      required String id,
      required int bookId,
      required int chapter,
      required int verseStart,
      required int verseEnd,
      required String language,
      Value<String?> verseText,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StudyEntriesTableUpdateCompanionBuilder =
    StudyEntriesCompanion Function({
      Value<String> id,
      Value<int> bookId,
      Value<int> chapter,
      Value<int> verseStart,
      Value<int> verseEnd,
      Value<String> language,
      Value<String?> verseText,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$StudyEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $StudyEntriesTable, StudyEntry> {
  $$StudyEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('study_entries__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StudyNotesTable, List<StudyNote>>
  _studyNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.studyNotes,
    aliasName: 'study_entries__id__study_notes__study_entry_id',
  );

  $$StudyNotesTableProcessedTableManager get studyNotesRefs {
    final manager = $$StudyNotesTableTableManager(
      $_db,
      $_db.studyNotes,
    ).filter((f) => f.studyEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_studyNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TalkPointsTable, List<TalkPoint>>
  _talkPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.talkPoints,
    aliasName: 'study_entries__id__talk_points__linked_study_entry_id',
  );

  $$TalkPointsTableProcessedTableManager get talkPointsRefs {
    final manager = $$TalkPointsTableTableManager($_db, $_db.talkPoints).filter(
      (f) => f.linkedStudyEntryId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_talkPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudyEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $StudyEntriesTable> {
  $$StudyEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseStart => $composableBuilder(
    column: $table.verseStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseEnd => $composableBuilder(
    column: $table.verseEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> studyNotesRefs(
    Expression<bool> Function($$StudyNotesTableFilterComposer f) f,
  ) {
    final $$StudyNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyNotes,
      getReferencedColumn: (t) => t.studyEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyNotesTableFilterComposer(
            $db: $db,
            $table: $db.studyNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> talkPointsRefs(
    Expression<bool> Function($$TalkPointsTableFilterComposer f) f,
  ) {
    final $$TalkPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talkPoints,
      getReferencedColumn: (t) => t.linkedStudyEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalkPointsTableFilterComposer(
            $db: $db,
            $table: $db.talkPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyEntriesTable> {
  $$StudyEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseStart => $composableBuilder(
    column: $table.verseStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseEnd => $composableBuilder(
    column: $table.verseEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verseText => $composableBuilder(
    column: $table.verseText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyEntriesTable> {
  $$StudyEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verseStart => $composableBuilder(
    column: $table.verseStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get verseEnd =>
      $composableBuilder(column: $table.verseEnd, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> studyNotesRefs<T extends Object>(
    Expression<T> Function($$StudyNotesTableAnnotationComposer a) f,
  ) {
    final $$StudyNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.studyNotes,
      getReferencedColumn: (t) => t.studyEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.studyNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> talkPointsRefs<T extends Object>(
    Expression<T> Function($$TalkPointsTableAnnotationComposer a) f,
  ) {
    final $$TalkPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talkPoints,
      getReferencedColumn: (t) => t.linkedStudyEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalkPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.talkPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyEntriesTable,
          StudyEntry,
          $$StudyEntriesTableFilterComposer,
          $$StudyEntriesTableOrderingComposer,
          $$StudyEntriesTableAnnotationComposer,
          $$StudyEntriesTableCreateCompanionBuilder,
          $$StudyEntriesTableUpdateCompanionBuilder,
          (StudyEntry, $$StudyEntriesTableReferences),
          StudyEntry,
          PrefetchHooks Function({
            bool bookId,
            bool studyNotesRefs,
            bool talkPointsRefs,
          })
        > {
  $$StudyEntriesTableTableManager(_$AppDatabase db, $StudyEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verseStart = const Value.absent(),
                Value<int> verseEnd = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String?> verseText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyEntriesCompanion(
                id: id,
                bookId: bookId,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd,
                language: language,
                verseText: verseText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int bookId,
                required int chapter,
                required int verseStart,
                required int verseEnd,
                required String language,
                Value<String?> verseText = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyEntriesCompanion.insert(
                id: id,
                bookId: bookId,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd,
                language: language,
                verseText: verseText,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudyEntriesTable, StudyEntry>(table),
                  $$StudyEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                bookId = false,
                studyNotesRefs = false,
                talkPointsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (studyNotesRefs) db.studyNotes,
                    if (talkPointsRefs) db.talkPoints,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable:
                                        $$StudyEntriesTableReferences
                                            ._bookIdTable(db),
                                    referencedColumn:
                                        $$StudyEntriesTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (studyNotesRefs)
                        await $_getPrefetchedData<
                          StudyEntry,
                          $StudyEntriesTable,
                          StudyNote
                        >(
                          currentTable: table,
                          referencedTable: $$StudyEntriesTableReferences
                              ._studyNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).studyNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.studyEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (talkPointsRefs)
                        await $_getPrefetchedData<
                          StudyEntry,
                          $StudyEntriesTable,
                          TalkPoint
                        >(
                          currentTable: table,
                          referencedTable: $$StudyEntriesTableReferences
                              ._talkPointsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).talkPointsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedStudyEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudyEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyEntriesTable,
      StudyEntry,
      $$StudyEntriesTableFilterComposer,
      $$StudyEntriesTableOrderingComposer,
      $$StudyEntriesTableAnnotationComposer,
      $$StudyEntriesTableCreateCompanionBuilder,
      $$StudyEntriesTableUpdateCompanionBuilder,
      (StudyEntry, $$StudyEntriesTableReferences),
      StudyEntry,
      PrefetchHooks Function({
        bool bookId,
        bool studyNotesRefs,
        bool talkPointsRefs,
      })
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String name,
      Value<String> colorHex,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> colorHex,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NoteTagLinksTable, List<NoteTagLink>>
  _noteTagLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.noteTagLinks,
    aliasName: 'tags__id__note_tag_links__tag_id',
  );

  $$NoteTagLinksTableProcessedTableManager get noteTagLinksRefs {
    final manager = $$NoteTagLinksTableTableManager(
      $_db,
      $_db.noteTagLinks,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteTagLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> noteTagLinksRefs(
    Expression<bool> Function($$NoteTagLinksTableFilterComposer f) f,
  ) {
    final $$NoteTagLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTagLinks,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagLinksTableFilterComposer(
            $db: $db,
            $table: $db.noteTagLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  Expression<T> noteTagLinksRefs<T extends Object>(
    Expression<T> Function($$NoteTagLinksTableAnnotationComposer a) f,
  ) {
    final $$NoteTagLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTagLinks,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.noteTagLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool noteTagLinksRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                name: name,
                colorHex: colorHex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> colorHex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                name: name,
                colorHex: colorHex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, Tag>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteTagLinksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (noteTagLinksRefs) db.noteTagLinks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (noteTagLinksRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, NoteTagLink>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences
                          ._noteTagLinksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).noteTagLinksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool noteTagLinksRefs})
    >;
typedef $$StudyNotesTableCreateCompanionBuilder =
    StudyNotesCompanion Function({
      required String id,
      required String noteText,
      required String source,
      Value<String?> studyEntryId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StudyNotesTableUpdateCompanionBuilder =
    StudyNotesCompanion Function({
      Value<String> id,
      Value<String> noteText,
      Value<String> source,
      Value<String?> studyEntryId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$StudyNotesTableReferences
    extends BaseReferences<_$AppDatabase, $StudyNotesTable, StudyNote> {
  $$StudyNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudyEntriesTable _studyEntryIdTable(_$AppDatabase db) => db
      .studyEntries
      .createAlias('study_notes__study_entry_id__study_entries__id');

  $$StudyEntriesTableProcessedTableManager? get studyEntryId {
    final $_column = $_itemColumn<String>('study_entry_id');
    if ($_column == null) return null;
    final manager = $$StudyEntriesTableTableManager(
      $_db,
      $_db.studyEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_studyEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$NoteTagLinksTable, List<NoteTagLink>>
  _noteTagLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.noteTagLinks,
    aliasName: 'study_notes__id__note_tag_links__note_id',
  );

  $$NoteTagLinksTableProcessedTableManager get noteTagLinksRefs {
    final manager = $$NoteTagLinksTableTableManager(
      $_db,
      $_db.noteTagLinks,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_noteTagLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StudyNotesTableFilterComposer
    extends Composer<_$AppDatabase, $StudyNotesTable> {
  $$StudyNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StudyEntriesTableFilterComposer get studyEntryId {
    final $$StudyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studyEntryId,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> noteTagLinksRefs(
    Expression<bool> Function($$NoteTagLinksTableFilterComposer f) f,
  ) {
    final $$NoteTagLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTagLinks,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagLinksTableFilterComposer(
            $db: $db,
            $table: $db.noteTagLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyNotesTable> {
  $$StudyNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StudyEntriesTableOrderingComposer get studyEntryId {
    final $$StudyEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studyEntryId,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StudyNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyNotesTable> {
  $$StudyNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$StudyEntriesTableAnnotationComposer get studyEntryId {
    final $$StudyEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.studyEntryId,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> noteTagLinksRefs<T extends Object>(
    Expression<T> Function($$NoteTagLinksTableAnnotationComposer a) f,
  ) {
    final $$NoteTagLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.noteTagLinks,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NoteTagLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.noteTagLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StudyNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyNotesTable,
          StudyNote,
          $$StudyNotesTableFilterComposer,
          $$StudyNotesTableOrderingComposer,
          $$StudyNotesTableAnnotationComposer,
          $$StudyNotesTableCreateCompanionBuilder,
          $$StudyNotesTableUpdateCompanionBuilder,
          (StudyNote, $$StudyNotesTableReferences),
          StudyNote,
          PrefetchHooks Function({bool studyEntryId, bool noteTagLinksRefs})
        > {
  $$StudyNotesTableTableManager(_$AppDatabase db, $StudyNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> noteText = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> studyEntryId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyNotesCompanion(
                id: id,
                noteText: noteText,
                source: source,
                studyEntryId: studyEntryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String noteText,
                required String source,
                Value<String?> studyEntryId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudyNotesCompanion.insert(
                id: id,
                noteText: noteText,
                source: source,
                studyEntryId: studyEntryId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudyNotesTable, StudyNote>(table),
                  $$StudyNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({studyEntryId = false, noteTagLinksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (noteTagLinksRefs) db.noteTagLinks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (studyEntryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.studyEntryId,
                                    referencedTable: $$StudyNotesTableReferences
                                        ._studyEntryIdTable(db),
                                    referencedColumn:
                                        $$StudyNotesTableReferences
                                            ._studyEntryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (noteTagLinksRefs)
                        await $_getPrefetchedData<
                          StudyNote,
                          $StudyNotesTable,
                          NoteTagLink
                        >(
                          currentTable: table,
                          referencedTable: $$StudyNotesTableReferences
                              ._noteTagLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StudyNotesTableReferences(
                                db,
                                table,
                                p0,
                              ).noteTagLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StudyNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyNotesTable,
      StudyNote,
      $$StudyNotesTableFilterComposer,
      $$StudyNotesTableOrderingComposer,
      $$StudyNotesTableAnnotationComposer,
      $$StudyNotesTableCreateCompanionBuilder,
      $$StudyNotesTableUpdateCompanionBuilder,
      (StudyNote, $$StudyNotesTableReferences),
      StudyNote,
      PrefetchHooks Function({bool studyEntryId, bool noteTagLinksRefs})
    >;
typedef $$NoteTagLinksTableCreateCompanionBuilder =
    NoteTagLinksCompanion Function({
      required String noteId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$NoteTagLinksTableUpdateCompanionBuilder =
    NoteTagLinksCompanion Function({
      Value<String> noteId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$NoteTagLinksTableReferences
    extends BaseReferences<_$AppDatabase, $NoteTagLinksTable, NoteTagLink> {
  $$NoteTagLinksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StudyNotesTable _noteIdTable(_$AppDatabase db) =>
      db.studyNotes.createAlias('note_tag_links__note_id__study_notes__id');

  $$StudyNotesTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$StudyNotesTableTableManager(
      $_db,
      $_db.studyNotes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias('note_tag_links__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NoteTagLinksTableFilterComposer
    extends Composer<_$AppDatabase, $NoteTagLinksTable> {
  $$NoteTagLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudyNotesTableFilterComposer get noteId {
    final $$StudyNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.studyNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyNotesTableFilterComposer(
            $db: $db,
            $table: $db.studyNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteTagLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $NoteTagLinksTable> {
  $$NoteTagLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudyNotesTableOrderingComposer get noteId {
    final $$StudyNotesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.studyNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyNotesTableOrderingComposer(
            $db: $db,
            $table: $db.studyNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteTagLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $NoteTagLinksTable> {
  $$NoteTagLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$StudyNotesTableAnnotationComposer get noteId {
    final $$StudyNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.studyNotes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.studyNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NoteTagLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NoteTagLinksTable,
          NoteTagLink,
          $$NoteTagLinksTableFilterComposer,
          $$NoteTagLinksTableOrderingComposer,
          $$NoteTagLinksTableAnnotationComposer,
          $$NoteTagLinksTableCreateCompanionBuilder,
          $$NoteTagLinksTableUpdateCompanionBuilder,
          (NoteTagLink, $$NoteTagLinksTableReferences),
          NoteTagLink,
          PrefetchHooks Function({bool noteId, bool tagId})
        > {
  $$NoteTagLinksTableTableManager(_$AppDatabase db, $NoteTagLinksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NoteTagLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NoteTagLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NoteTagLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> noteId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NoteTagLinksCompanion(
                noteId: noteId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String noteId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => NoteTagLinksCompanion.insert(
                noteId: noteId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NoteTagLinksTable, NoteTagLink>(table),
                  $$NoteTagLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable: $$NoteTagLinksTableReferences
                                    ._noteIdTable(db),
                                referencedColumn: $$NoteTagLinksTableReferences
                                    ._noteIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$NoteTagLinksTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$NoteTagLinksTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NoteTagLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NoteTagLinksTable,
      NoteTagLink,
      $$NoteTagLinksTableFilterComposer,
      $$NoteTagLinksTableOrderingComposer,
      $$NoteTagLinksTableAnnotationComposer,
      $$NoteTagLinksTableCreateCompanionBuilder,
      $$NoteTagLinksTableUpdateCompanionBuilder,
      (NoteTagLink, $$NoteTagLinksTableReferences),
      NoteTagLink,
      PrefetchHooks Function({bool noteId, bool tagId})
    >;
typedef $$TalksTableCreateCompanionBuilder =
    TalksCompanion Function({
      required String id,
      required String title,
      Value<String?> speaker,
      required DateTime date,
      Value<int> rowid,
    });
typedef $$TalksTableUpdateCompanionBuilder =
    TalksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> speaker,
      Value<DateTime> date,
      Value<int> rowid,
    });

final class $$TalksTableReferences
    extends BaseReferences<_$AppDatabase, $TalksTable, Talk> {
  $$TalksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TalkPointsTable, List<TalkPoint>>
  _talkPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.talkPoints,
    aliasName: 'talks__id__talk_points__talk_id',
  );

  $$TalkPointsTableProcessedTableManager get talkPointsRefs {
    final manager = $$TalkPointsTableTableManager(
      $_db,
      $_db.talkPoints,
    ).filter((f) => f.talkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_talkPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TalksTableFilterComposer extends Composer<_$AppDatabase, $TalksTable> {
  $$TalksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> talkPointsRefs(
    Expression<bool> Function($$TalkPointsTableFilterComposer f) f,
  ) {
    final $$TalkPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talkPoints,
      getReferencedColumn: (t) => t.talkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalkPointsTableFilterComposer(
            $db: $db,
            $table: $db.talkPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TalksTableOrderingComposer
    extends Composer<_$AppDatabase, $TalksTable> {
  $$TalksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get speaker => $composableBuilder(
    column: $table.speaker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TalksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TalksTable> {
  $$TalksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get speaker =>
      $composableBuilder(column: $table.speaker, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  Expression<T> talkPointsRefs<T extends Object>(
    Expression<T> Function($$TalkPointsTableAnnotationComposer a) f,
  ) {
    final $$TalkPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.talkPoints,
      getReferencedColumn: (t) => t.talkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalkPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.talkPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TalksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TalksTable,
          Talk,
          $$TalksTableFilterComposer,
          $$TalksTableOrderingComposer,
          $$TalksTableAnnotationComposer,
          $$TalksTableCreateCompanionBuilder,
          $$TalksTableUpdateCompanionBuilder,
          (Talk, $$TalksTableReferences),
          Talk,
          PrefetchHooks Function({bool talkPointsRefs})
        > {
  $$TalksTableTableManager(_$AppDatabase db, $TalksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TalksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TalksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TalksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> speaker = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TalksCompanion(
                id: id,
                title: title,
                speaker: speaker,
                date: date,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> speaker = const Value.absent(),
                required DateTime date,
                Value<int> rowid = const Value.absent(),
              }) => TalksCompanion.insert(
                id: id,
                title: title,
                speaker: speaker,
                date: date,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TalksTable, Talk>(table),
                  $$TalksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({talkPointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (talkPointsRefs) db.talkPoints],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (talkPointsRefs)
                    await $_getPrefetchedData<Talk, $TalksTable, TalkPoint>(
                      currentTable: table,
                      referencedTable: $$TalksTableReferences
                          ._talkPointsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TalksTableReferences(db, table, p0).talkPointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.talkId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TalksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TalksTable,
      Talk,
      $$TalksTableFilterComposer,
      $$TalksTableOrderingComposer,
      $$TalksTableAnnotationComposer,
      $$TalksTableCreateCompanionBuilder,
      $$TalksTableUpdateCompanionBuilder,
      (Talk, $$TalksTableReferences),
      Talk,
      PrefetchHooks Function({bool talkPointsRefs})
    >;
typedef $$TalkPointsTableCreateCompanionBuilder =
    TalkPointsCompanion Function({
      required String id,
      required String talkId,
      required int orderIndex,
      required String pointText,
      Value<String?> linkedStudyEntryId,
      Value<int> rowid,
    });
typedef $$TalkPointsTableUpdateCompanionBuilder =
    TalkPointsCompanion Function({
      Value<String> id,
      Value<String> talkId,
      Value<int> orderIndex,
      Value<String> pointText,
      Value<String?> linkedStudyEntryId,
      Value<int> rowid,
    });

final class $$TalkPointsTableReferences
    extends BaseReferences<_$AppDatabase, $TalkPointsTable, TalkPoint> {
  $$TalkPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TalksTable _talkIdTable(_$AppDatabase db) =>
      db.talks.createAlias('talk_points__talk_id__talks__id');

  $$TalksTableProcessedTableManager get talkId {
    final $_column = $_itemColumn<String>('talk_id')!;

    final manager = $$TalksTableTableManager(
      $_db,
      $_db.talks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_talkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $StudyEntriesTable _linkedStudyEntryIdTable(_$AppDatabase db) => db
      .studyEntries
      .createAlias('talk_points__linked_study_entry_id__study_entries__id');

  $$StudyEntriesTableProcessedTableManager? get linkedStudyEntryId {
    final $_column = $_itemColumn<String>('linked_study_entry_id');
    if ($_column == null) return null;
    final manager = $$StudyEntriesTableTableManager(
      $_db,
      $_db.studyEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedStudyEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TalkPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TalkPointsTable> {
  $$TalkPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pointText => $composableBuilder(
    column: $table.pointText,
    builder: (column) => ColumnFilters(column),
  );

  $$TalksTableFilterComposer get talkId {
    final $$TalksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.talkId,
      referencedTable: $db.talks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalksTableFilterComposer(
            $db: $db,
            $table: $db.talks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudyEntriesTableFilterComposer get linkedStudyEntryId {
    final $$StudyEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedStudyEntryId,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableFilterComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TalkPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TalkPointsTable> {
  $$TalkPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pointText => $composableBuilder(
    column: $table.pointText,
    builder: (column) => ColumnOrderings(column),
  );

  $$TalksTableOrderingComposer get talkId {
    final $$TalksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.talkId,
      referencedTable: $db.talks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalksTableOrderingComposer(
            $db: $db,
            $table: $db.talks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudyEntriesTableOrderingComposer get linkedStudyEntryId {
    final $$StudyEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedStudyEntryId,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TalkPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TalkPointsTable> {
  $$TalkPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pointText =>
      $composableBuilder(column: $table.pointText, builder: (column) => column);

  $$TalksTableAnnotationComposer get talkId {
    final $$TalksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.talkId,
      referencedTable: $db.talks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TalksTableAnnotationComposer(
            $db: $db,
            $table: $db.talks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$StudyEntriesTableAnnotationComposer get linkedStudyEntryId {
    final $$StudyEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedStudyEntryId,
      referencedTable: $db.studyEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StudyEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.studyEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TalkPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TalkPointsTable,
          TalkPoint,
          $$TalkPointsTableFilterComposer,
          $$TalkPointsTableOrderingComposer,
          $$TalkPointsTableAnnotationComposer,
          $$TalkPointsTableCreateCompanionBuilder,
          $$TalkPointsTableUpdateCompanionBuilder,
          (TalkPoint, $$TalkPointsTableReferences),
          TalkPoint,
          PrefetchHooks Function({bool talkId, bool linkedStudyEntryId})
        > {
  $$TalkPointsTableTableManager(_$AppDatabase db, $TalkPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TalkPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TalkPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TalkPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> talkId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> pointText = const Value.absent(),
                Value<String?> linkedStudyEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TalkPointsCompanion(
                id: id,
                talkId: talkId,
                orderIndex: orderIndex,
                pointText: pointText,
                linkedStudyEntryId: linkedStudyEntryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String talkId,
                required int orderIndex,
                required String pointText,
                Value<String?> linkedStudyEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TalkPointsCompanion.insert(
                id: id,
                talkId: talkId,
                orderIndex: orderIndex,
                pointText: pointText,
                linkedStudyEntryId: linkedStudyEntryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TalkPointsTable, TalkPoint>(table),
                  $$TalkPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({talkId = false, linkedStudyEntryId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (talkId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.talkId,
                                    referencedTable: $$TalkPointsTableReferences
                                        ._talkIdTable(db),
                                    referencedColumn:
                                        $$TalkPointsTableReferences
                                            ._talkIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (linkedStudyEntryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.linkedStudyEntryId,
                                    referencedTable: $$TalkPointsTableReferences
                                        ._linkedStudyEntryIdTable(db),
                                    referencedColumn:
                                        $$TalkPointsTableReferences
                                            ._linkedStudyEntryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TalkPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TalkPointsTable,
      TalkPoint,
      $$TalkPointsTableFilterComposer,
      $$TalkPointsTableOrderingComposer,
      $$TalkPointsTableAnnotationComposer,
      $$TalkPointsTableCreateCompanionBuilder,
      $$TalkPointsTableUpdateCompanionBuilder,
      (TalkPoint, $$TalkPointsTableReferences),
      TalkPoint,
      PrefetchHooks Function({bool talkId, bool linkedStudyEntryId})
    >;
typedef $$QuizSessionsTableCreateCompanionBuilder =
    QuizSessionsCompanion Function({
      required String id,
      required String scopeType,
      required String scopeRefJson,
      required String quizType,
      required DateTime startedAt,
      Value<DateTime?> finishedAt,
      Value<int> score,
      Value<int> totalQuestions,
      Value<int> rowid,
    });
typedef $$QuizSessionsTableUpdateCompanionBuilder =
    QuizSessionsCompanion Function({
      Value<String> id,
      Value<String> scopeType,
      Value<String> scopeRefJson,
      Value<String> quizType,
      Value<DateTime> startedAt,
      Value<DateTime?> finishedAt,
      Value<int> score,
      Value<int> totalQuestions,
      Value<int> rowid,
    });

final class $$QuizSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizSessionsTable, QuizSession> {
  $$QuizSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuizAttemptsTable, List<QuizAttempt>>
  _quizAttemptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizAttempts,
    aliasName: 'quiz_sessions__id__quiz_attempts__session_id',
  );

  $$QuizAttemptsTableProcessedTableManager get quizAttemptsRefs {
    final manager = $$QuizAttemptsTableTableManager(
      $_db,
      $_db.quizAttempts,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizAttemptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizSessionsTable> {
  $$QuizSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeRefJson => $composableBuilder(
    column: $table.scopeRefJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quizType => $composableBuilder(
    column: $table.quizType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> quizAttemptsRefs(
    Expression<bool> Function($$QuizAttemptsTableFilterComposer f) f,
  ) {
    final $$QuizAttemptsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableFilterComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizSessionsTable> {
  $$QuizSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeRefJson => $composableBuilder(
    column: $table.scopeRefJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quizType => $composableBuilder(
    column: $table.quizType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizSessionsTable> {
  $$QuizSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scopeType =>
      $composableBuilder(column: $table.scopeType, builder: (column) => column);

  GeneratedColumn<String> get scopeRefJson => $composableBuilder(
    column: $table.scopeRefJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quizType =>
      $composableBuilder(column: $table.quizType, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  Expression<T> quizAttemptsRefs<T extends Object>(
    Expression<T> Function($$QuizAttemptsTableAnnotationComposer a) f,
  ) {
    final $$QuizAttemptsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizAttempts,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizAttemptsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizAttempts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizSessionsTable,
          QuizSession,
          $$QuizSessionsTableFilterComposer,
          $$QuizSessionsTableOrderingComposer,
          $$QuizSessionsTableAnnotationComposer,
          $$QuizSessionsTableCreateCompanionBuilder,
          $$QuizSessionsTableUpdateCompanionBuilder,
          (QuizSession, $$QuizSessionsTableReferences),
          QuizSession,
          PrefetchHooks Function({bool quizAttemptsRefs})
        > {
  $$QuizSessionsTableTableManager(_$AppDatabase db, $QuizSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> scopeType = const Value.absent(),
                Value<String> scopeRefJson = const Value.absent(),
                Value<String> quizType = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizSessionsCompanion(
                id: id,
                scopeType: scopeType,
                scopeRefJson: scopeRefJson,
                quizType: quizType,
                startedAt: startedAt,
                finishedAt: finishedAt,
                score: score,
                totalQuestions: totalQuestions,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String scopeType,
                required String scopeRefJson,
                required String quizType,
                required DateTime startedAt,
                Value<DateTime?> finishedAt = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizSessionsCompanion.insert(
                id: id,
                scopeType: scopeType,
                scopeRefJson: scopeRefJson,
                quizType: quizType,
                startedAt: startedAt,
                finishedAt: finishedAt,
                score: score,
                totalQuestions: totalQuestions,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuizSessionsTable, QuizSession>(table),
                  $$QuizSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quizAttemptsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (quizAttemptsRefs) db.quizAttempts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (quizAttemptsRefs)
                    await $_getPrefetchedData<
                      QuizSession,
                      $QuizSessionsTable,
                      QuizAttempt
                    >(
                      currentTable: table,
                      referencedTable: $$QuizSessionsTableReferences
                          ._quizAttemptsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$QuizSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).quizAttemptsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuizSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizSessionsTable,
      QuizSession,
      $$QuizSessionsTableFilterComposer,
      $$QuizSessionsTableOrderingComposer,
      $$QuizSessionsTableAnnotationComposer,
      $$QuizSessionsTableCreateCompanionBuilder,
      $$QuizSessionsTableUpdateCompanionBuilder,
      (QuizSession, $$QuizSessionsTableReferences),
      QuizSession,
      PrefetchHooks Function({bool quizAttemptsRefs})
    >;
typedef $$QuizAttemptsTableCreateCompanionBuilder =
    QuizAttemptsCompanion Function({
      required String id,
      required String sessionId,
      required String promptText,
      required String correctAnswer,
      Value<String?> userAnswer,
      Value<bool> isCorrect,
      Value<int> rowid,
    });
typedef $$QuizAttemptsTableUpdateCompanionBuilder =
    QuizAttemptsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> promptText,
      Value<String> correctAnswer,
      Value<String?> userAnswer,
      Value<bool> isCorrect,
      Value<int> rowid,
    });

final class $$QuizAttemptsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizAttemptsTable, QuizAttempt> {
  $$QuizAttemptsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuizSessionsTable _sessionIdTable(_$AppDatabase db) => db.quizSessions
      .createAlias('quiz_attempts__session_id__quiz_sessions__id');

  $$QuizSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$QuizSessionsTableTableManager(
      $_db,
      $_db.quizSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptText => $composableBuilder(
    column: $table.promptText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizSessionsTableFilterComposer get sessionId {
    final $$QuizSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.quizSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizSessionsTableFilterComposer(
            $db: $db,
            $table: $db.quizSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptText => $composableBuilder(
    column: $table.promptText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizSessionsTableOrderingComposer get sessionId {
    final $$QuizSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.quizSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.quizSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizAttemptsTable> {
  $$QuizAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get promptText => $composableBuilder(
    column: $table.promptText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get correctAnswer => $composableBuilder(
    column: $table.correctAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userAnswer => $composableBuilder(
    column: $table.userAnswer,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  $$QuizSessionsTableAnnotationComposer get sessionId {
    final $$QuizSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.quizSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizAttemptsTable,
          QuizAttempt,
          $$QuizAttemptsTableFilterComposer,
          $$QuizAttemptsTableOrderingComposer,
          $$QuizAttemptsTableAnnotationComposer,
          $$QuizAttemptsTableCreateCompanionBuilder,
          $$QuizAttemptsTableUpdateCompanionBuilder,
          (QuizAttempt, $$QuizAttemptsTableReferences),
          QuizAttempt,
          PrefetchHooks Function({bool sessionId})
        > {
  $$QuizAttemptsTableTableManager(_$AppDatabase db, $QuizAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> promptText = const Value.absent(),
                Value<String> correctAnswer = const Value.absent(),
                Value<String?> userAnswer = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion(
                id: id,
                sessionId: sessionId,
                promptText: promptText,
                correctAnswer: correctAnswer,
                userAnswer: userAnswer,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String promptText,
                required String correctAnswer,
                Value<String?> userAnswer = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizAttemptsCompanion.insert(
                id: id,
                sessionId: sessionId,
                promptText: promptText,
                correctAnswer: correctAnswer,
                userAnswer: userAnswer,
                isCorrect: isCorrect,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$QuizAttemptsTable, QuizAttempt>(table),
                  $$QuizAttemptsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$QuizAttemptsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$QuizAttemptsTableReferences
                                    ._sessionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizAttemptsTable,
      QuizAttempt,
      $$QuizAttemptsTableFilterComposer,
      $$QuizAttemptsTableOrderingComposer,
      $$QuizAttemptsTableAnnotationComposer,
      $$QuizAttemptsTableCreateCompanionBuilder,
      $$QuizAttemptsTableUpdateCompanionBuilder,
      (QuizAttempt, $$QuizAttemptsTableReferences),
      QuizAttempt,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$ReminderSettingsTableCreateCompanionBuilder =
    ReminderSettingsCompanion Function({
      Value<int> weekday,
      Value<bool> enabled,
      Value<int> hour,
      Value<int> minute,
    });
typedef $$ReminderSettingsTableUpdateCompanionBuilder =
    ReminderSettingsCompanion Function({
      Value<int> weekday,
      Value<bool> enabled,
      Value<int> hour,
      Value<int> minute,
    });

class $$ReminderSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);
}

class $$ReminderSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderSettingsTable,
          ReminderSetting,
          $$ReminderSettingsTableFilterComposer,
          $$ReminderSettingsTableOrderingComposer,
          $$ReminderSettingsTableAnnotationComposer,
          $$ReminderSettingsTableCreateCompanionBuilder,
          $$ReminderSettingsTableUpdateCompanionBuilder,
          (
            ReminderSetting,
            BaseReferences<
              _$AppDatabase,
              $ReminderSettingsTable,
              ReminderSetting
            >,
          ),
          ReminderSetting,
          PrefetchHooks Function()
        > {
  $$ReminderSettingsTableTableManager(
    _$AppDatabase db,
    $ReminderSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> weekday = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
              }) => ReminderSettingsCompanion(
                weekday: weekday,
                enabled: enabled,
                hour: hour,
                minute: minute,
              ),
          createCompanionCallback:
              ({
                Value<int> weekday = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
              }) => ReminderSettingsCompanion.insert(
                weekday: weekday,
                enabled: enabled,
                hour: hour,
                minute: minute,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReminderSettingsTable, ReminderSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ReminderSettingsTable,
                    ReminderSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderSettingsTable,
      ReminderSetting,
      $$ReminderSettingsTableFilterComposer,
      $$ReminderSettingsTableOrderingComposer,
      $$ReminderSettingsTableAnnotationComposer,
      $$ReminderSettingsTableCreateCompanionBuilder,
      $$ReminderSettingsTableUpdateCompanionBuilder,
      (
        ReminderSetting,
        BaseReferences<_$AppDatabase, $ReminderSettingsTable, ReminderSetting>,
      ),
      ReminderSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$StudyEntriesTableTableManager get studyEntries =>
      $$StudyEntriesTableTableManager(_db, _db.studyEntries);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$StudyNotesTableTableManager get studyNotes =>
      $$StudyNotesTableTableManager(_db, _db.studyNotes);
  $$NoteTagLinksTableTableManager get noteTagLinks =>
      $$NoteTagLinksTableTableManager(_db, _db.noteTagLinks);
  $$TalksTableTableManager get talks =>
      $$TalksTableTableManager(_db, _db.talks);
  $$TalkPointsTableTableManager get talkPoints =>
      $$TalkPointsTableTableManager(_db, _db.talkPoints);
  $$QuizSessionsTableTableManager get quizSessions =>
      $$QuizSessionsTableTableManager(_db, _db.quizSessions);
  $$QuizAttemptsTableTableManager get quizAttempts =>
      $$QuizAttemptsTableTableManager(_db, _db.quizAttempts);
  $$ReminderSettingsTableTableManager get reminderSettings =>
      $$ReminderSettingsTableTableManager(_db, _db.reminderSettings);
}
