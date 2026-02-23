// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _singletonIdMeta = const VerificationMeta(
    'singletonId',
  );
  @override
  late final GeneratedColumn<int> singletonId = GeneratedColumn<int>(
    'singleton_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateEpochMsMeta = const VerificationMeta(
    'birthDateEpochMs',
  );
  @override
  late final GeneratedColumn<int> birthDateEpochMs = GeneratedColumn<int>(
    'birth_date_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifespanYearsMeta = const VerificationMeta(
    'lifespanYears',
  );
  @override
  late final GeneratedColumn<int> lifespanYears = GeneratedColumn<int>(
    'lifespan_years',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearDotRowsMeta = const VerificationMeta(
    'yearDotRows',
  );
  @override
  late final GeneratedColumn<int> yearDotRows = GeneratedColumn<int>(
    'year_dot_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _notebookAiAccessEnabledMeta =
      const VerificationMeta('notebookAiAccessEnabled');
  @override
  late final GeneratedColumn<bool> notebookAiAccessEnabled =
      GeneratedColumn<bool>(
        'notebook_ai_access_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notebook_ai_access_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    singletonId,
    birthDateEpochMs,
    lifespanYears,
    yearDotRows,
    notebookAiAccessEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('singleton_id')) {
      context.handle(
        _singletonIdMeta,
        singletonId.isAcceptableOrUnknown(
          data['singleton_id']!,
          _singletonIdMeta,
        ),
      );
    }
    if (data.containsKey('birth_date_epoch_ms')) {
      context.handle(
        _birthDateEpochMsMeta,
        birthDateEpochMs.isAcceptableOrUnknown(
          data['birth_date_epoch_ms']!,
          _birthDateEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_birthDateEpochMsMeta);
    }
    if (data.containsKey('lifespan_years')) {
      context.handle(
        _lifespanYearsMeta,
        lifespanYears.isAcceptableOrUnknown(
          data['lifespan_years']!,
          _lifespanYearsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lifespanYearsMeta);
    }
    if (data.containsKey('year_dot_rows')) {
      context.handle(
        _yearDotRowsMeta,
        yearDotRows.isAcceptableOrUnknown(
          data['year_dot_rows']!,
          _yearDotRowsMeta,
        ),
      );
    }
    if (data.containsKey('notebook_ai_access_enabled')) {
      context.handle(
        _notebookAiAccessEnabledMeta,
        notebookAiAccessEnabled.isAcceptableOrUnknown(
          data['notebook_ai_access_enabled']!,
          _notebookAiAccessEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singletonId};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      singletonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton_id'],
      )!,
      birthDateEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_date_epoch_ms'],
      )!,
      lifespanYears: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lifespan_years'],
      )!,
      yearDotRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_dot_rows'],
      )!,
      notebookAiAccessEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notebook_ai_access_enabled'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final int singletonId;
  final int birthDateEpochMs;
  final int lifespanYears;
  final int yearDotRows;
  final bool notebookAiAccessEnabled;
  const SettingsTableData({
    required this.singletonId,
    required this.birthDateEpochMs,
    required this.lifespanYears,
    required this.yearDotRows,
    required this.notebookAiAccessEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton_id'] = Variable<int>(singletonId);
    map['birth_date_epoch_ms'] = Variable<int>(birthDateEpochMs);
    map['lifespan_years'] = Variable<int>(lifespanYears);
    map['year_dot_rows'] = Variable<int>(yearDotRows);
    map['notebook_ai_access_enabled'] = Variable<bool>(notebookAiAccessEnabled);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      singletonId: Value(singletonId),
      birthDateEpochMs: Value(birthDateEpochMs),
      lifespanYears: Value(lifespanYears),
      yearDotRows: Value(yearDotRows),
      notebookAiAccessEnabled: Value(notebookAiAccessEnabled),
    );
  }

  factory SettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      singletonId: serializer.fromJson<int>(json['singletonId']),
      birthDateEpochMs: serializer.fromJson<int>(json['birthDateEpochMs']),
      lifespanYears: serializer.fromJson<int>(json['lifespanYears']),
      yearDotRows: serializer.fromJson<int>(json['yearDotRows']),
      notebookAiAccessEnabled: serializer.fromJson<bool>(
        json['notebookAiAccessEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singletonId': serializer.toJson<int>(singletonId),
      'birthDateEpochMs': serializer.toJson<int>(birthDateEpochMs),
      'lifespanYears': serializer.toJson<int>(lifespanYears),
      'yearDotRows': serializer.toJson<int>(yearDotRows),
      'notebookAiAccessEnabled': serializer.toJson<bool>(
        notebookAiAccessEnabled,
      ),
    };
  }

  SettingsTableData copyWith({
    int? singletonId,
    int? birthDateEpochMs,
    int? lifespanYears,
    int? yearDotRows,
    bool? notebookAiAccessEnabled,
  }) => SettingsTableData(
    singletonId: singletonId ?? this.singletonId,
    birthDateEpochMs: birthDateEpochMs ?? this.birthDateEpochMs,
    lifespanYears: lifespanYears ?? this.lifespanYears,
    yearDotRows: yearDotRows ?? this.yearDotRows,
    notebookAiAccessEnabled:
        notebookAiAccessEnabled ?? this.notebookAiAccessEnabled,
  );
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      singletonId: data.singletonId.present
          ? data.singletonId.value
          : this.singletonId,
      birthDateEpochMs: data.birthDateEpochMs.present
          ? data.birthDateEpochMs.value
          : this.birthDateEpochMs,
      lifespanYears: data.lifespanYears.present
          ? data.lifespanYears.value
          : this.lifespanYears,
      yearDotRows: data.yearDotRows.present
          ? data.yearDotRows.value
          : this.yearDotRows,
      notebookAiAccessEnabled: data.notebookAiAccessEnabled.present
          ? data.notebookAiAccessEnabled.value
          : this.notebookAiAccessEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('singletonId: $singletonId, ')
          ..write('birthDateEpochMs: $birthDateEpochMs, ')
          ..write('lifespanYears: $lifespanYears, ')
          ..write('yearDotRows: $yearDotRows, ')
          ..write('notebookAiAccessEnabled: $notebookAiAccessEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    singletonId,
    birthDateEpochMs,
    lifespanYears,
    yearDotRows,
    notebookAiAccessEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.singletonId == this.singletonId &&
          other.birthDateEpochMs == this.birthDateEpochMs &&
          other.lifespanYears == this.lifespanYears &&
          other.yearDotRows == this.yearDotRows &&
          other.notebookAiAccessEnabled == this.notebookAiAccessEnabled);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<int> singletonId;
  final Value<int> birthDateEpochMs;
  final Value<int> lifespanYears;
  final Value<int> yearDotRows;
  final Value<bool> notebookAiAccessEnabled;
  const SettingsTableCompanion({
    this.singletonId = const Value.absent(),
    this.birthDateEpochMs = const Value.absent(),
    this.lifespanYears = const Value.absent(),
    this.yearDotRows = const Value.absent(),
    this.notebookAiAccessEnabled = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.singletonId = const Value.absent(),
    required int birthDateEpochMs,
    required int lifespanYears,
    this.yearDotRows = const Value.absent(),
    this.notebookAiAccessEnabled = const Value.absent(),
  }) : birthDateEpochMs = Value(birthDateEpochMs),
       lifespanYears = Value(lifespanYears);
  static Insertable<SettingsTableData> custom({
    Expression<int>? singletonId,
    Expression<int>? birthDateEpochMs,
    Expression<int>? lifespanYears,
    Expression<int>? yearDotRows,
    Expression<bool>? notebookAiAccessEnabled,
  }) {
    return RawValuesInsertable({
      if (singletonId != null) 'singleton_id': singletonId,
      if (birthDateEpochMs != null) 'birth_date_epoch_ms': birthDateEpochMs,
      if (lifespanYears != null) 'lifespan_years': lifespanYears,
      if (yearDotRows != null) 'year_dot_rows': yearDotRows,
      if (notebookAiAccessEnabled != null)
        'notebook_ai_access_enabled': notebookAiAccessEnabled,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? singletonId,
    Value<int>? birthDateEpochMs,
    Value<int>? lifespanYears,
    Value<int>? yearDotRows,
    Value<bool>? notebookAiAccessEnabled,
  }) {
    return SettingsTableCompanion(
      singletonId: singletonId ?? this.singletonId,
      birthDateEpochMs: birthDateEpochMs ?? this.birthDateEpochMs,
      lifespanYears: lifespanYears ?? this.lifespanYears,
      yearDotRows: yearDotRows ?? this.yearDotRows,
      notebookAiAccessEnabled:
          notebookAiAccessEnabled ?? this.notebookAiAccessEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singletonId.present) {
      map['singleton_id'] = Variable<int>(singletonId.value);
    }
    if (birthDateEpochMs.present) {
      map['birth_date_epoch_ms'] = Variable<int>(birthDateEpochMs.value);
    }
    if (lifespanYears.present) {
      map['lifespan_years'] = Variable<int>(lifespanYears.value);
    }
    if (yearDotRows.present) {
      map['year_dot_rows'] = Variable<int>(yearDotRows.value);
    }
    if (notebookAiAccessEnabled.present) {
      map['notebook_ai_access_enabled'] = Variable<bool>(
        notebookAiAccessEnabled.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('singletonId: $singletonId, ')
          ..write('birthDateEpochMs: $birthDateEpochMs, ')
          ..write('lifespanYears: $lifespanYears, ')
          ..write('yearDotRows: $yearDotRows, ')
          ..write('notebookAiAccessEnabled: $notebookAiAccessEnabled')
          ..write(')'))
        .toString();
  }
}

class $NotebooksTableTable extends NotebooksTable
    with TableInfo<$NotebooksTableTable, NotebooksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotebooksTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, subtitle, createdAtEpochMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notebooks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotebooksTableData> instance, {
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
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotebooksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotebooksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
    );
  }

  @override
  $NotebooksTableTable createAlias(String alias) {
    return $NotebooksTableTable(attachedDatabase, alias);
  }
}

class NotebooksTableData extends DataClass
    implements Insertable<NotebooksTableData> {
  final String id;
  final String title;
  final String? subtitle;
  final int createdAtEpochMs;
  const NotebooksTableData({
    required this.id,
    required this.title,
    this.subtitle,
    required this.createdAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    return map;
  }

  NotebooksTableCompanion toCompanion(bool nullToAbsent) {
    return NotebooksTableCompanion(
      id: Value(id),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      createdAtEpochMs: Value(createdAtEpochMs),
    );
  }

  factory NotebooksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotebooksTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
    };
  }

  NotebooksTableData copyWith({
    String? id,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    int? createdAtEpochMs,
  }) => NotebooksTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
  );
  NotebooksTableData copyWithCompanion(NotebooksTableCompanion data) {
    return NotebooksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotebooksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('createdAtEpochMs: $createdAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, subtitle, createdAtEpochMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotebooksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.createdAtEpochMs == this.createdAtEpochMs);
}

class NotebooksTableCompanion extends UpdateCompanion<NotebooksTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<int> createdAtEpochMs;
  final Value<int> rowid;
  const NotebooksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotebooksTableCompanion.insert({
    required String id,
    required String title,
    this.subtitle = const Value.absent(),
    required int createdAtEpochMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAtEpochMs = Value(createdAtEpochMs);
  static Insertable<NotebooksTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<int>? createdAtEpochMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotebooksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<int>? createdAtEpochMs,
    Value<int>? rowid,
  }) {
    return NotebooksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
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
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotebooksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotebookPagesTableTable extends NotebookPagesTable
    with TableInfo<$NotebookPagesTableTable, NotebookPagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotebookPagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notebookIdMeta = const VerificationMeta(
    'notebookId',
  );
  @override
  late final GeneratedColumn<String> notebookId = GeneratedColumn<String>(
    'notebook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notebooks_table (id) ON DELETE CASCADE',
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
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fontPresetMeta = const VerificationMeta(
    'fontPreset',
  );
  @override
  late final GeneratedColumn<String> fontPreset = GeneratedColumn<String>(
    'font_preset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('classic'),
  );
  static const VerificationMeta _fontSizeMeta = const VerificationMeta(
    'fontSize',
  );
  @override
  late final GeneratedColumn<double> fontSize = GeneratedColumn<double>(
    'font_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(16.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notebookId,
    orderIndex,
    content,
    fontPreset,
    fontSize,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notebook_pages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotebookPagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('notebook_id')) {
      context.handle(
        _notebookIdMeta,
        notebookId.isAcceptableOrUnknown(data['notebook_id']!, _notebookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_notebookIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('font_preset')) {
      context.handle(
        _fontPresetMeta,
        fontPreset.isAcceptableOrUnknown(data['font_preset']!, _fontPresetMeta),
      );
    }
    if (data.containsKey('font_size')) {
      context.handle(
        _fontSizeMeta,
        fontSize.isAcceptableOrUnknown(data['font_size']!, _fontSizeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotebookPagesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotebookPagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      notebookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notebook_id'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      fontPreset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_preset'],
      )!,
      fontSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_size'],
      )!,
    );
  }

  @override
  $NotebookPagesTableTable createAlias(String alias) {
    return $NotebookPagesTableTable(attachedDatabase, alias);
  }
}

class NotebookPagesTableData extends DataClass
    implements Insertable<NotebookPagesTableData> {
  final String id;
  final String notebookId;
  final int orderIndex;
  final String content;
  final String fontPreset;
  final double fontSize;
  const NotebookPagesTableData({
    required this.id,
    required this.notebookId,
    required this.orderIndex,
    required this.content,
    required this.fontPreset,
    required this.fontSize,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['notebook_id'] = Variable<String>(notebookId);
    map['order_index'] = Variable<int>(orderIndex);
    map['content'] = Variable<String>(content);
    map['font_preset'] = Variable<String>(fontPreset);
    map['font_size'] = Variable<double>(fontSize);
    return map;
  }

  NotebookPagesTableCompanion toCompanion(bool nullToAbsent) {
    return NotebookPagesTableCompanion(
      id: Value(id),
      notebookId: Value(notebookId),
      orderIndex: Value(orderIndex),
      content: Value(content),
      fontPreset: Value(fontPreset),
      fontSize: Value(fontSize),
    );
  }

  factory NotebookPagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotebookPagesTableData(
      id: serializer.fromJson<String>(json['id']),
      notebookId: serializer.fromJson<String>(json['notebookId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      content: serializer.fromJson<String>(json['content']),
      fontPreset: serializer.fromJson<String>(json['fontPreset']),
      fontSize: serializer.fromJson<double>(json['fontSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'notebookId': serializer.toJson<String>(notebookId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'content': serializer.toJson<String>(content),
      'fontPreset': serializer.toJson<String>(fontPreset),
      'fontSize': serializer.toJson<double>(fontSize),
    };
  }

  NotebookPagesTableData copyWith({
    String? id,
    String? notebookId,
    int? orderIndex,
    String? content,
    String? fontPreset,
    double? fontSize,
  }) => NotebookPagesTableData(
    id: id ?? this.id,
    notebookId: notebookId ?? this.notebookId,
    orderIndex: orderIndex ?? this.orderIndex,
    content: content ?? this.content,
    fontPreset: fontPreset ?? this.fontPreset,
    fontSize: fontSize ?? this.fontSize,
  );
  NotebookPagesTableData copyWithCompanion(NotebookPagesTableCompanion data) {
    return NotebookPagesTableData(
      id: data.id.present ? data.id.value : this.id,
      notebookId: data.notebookId.present
          ? data.notebookId.value
          : this.notebookId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      content: data.content.present ? data.content.value : this.content,
      fontPreset: data.fontPreset.present
          ? data.fontPreset.value
          : this.fontPreset,
      fontSize: data.fontSize.present ? data.fontSize.value : this.fontSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotebookPagesTableData(')
          ..write('id: $id, ')
          ..write('notebookId: $notebookId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('content: $content, ')
          ..write('fontPreset: $fontPreset, ')
          ..write('fontSize: $fontSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, notebookId, orderIndex, content, fontPreset, fontSize);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotebookPagesTableData &&
          other.id == this.id &&
          other.notebookId == this.notebookId &&
          other.orderIndex == this.orderIndex &&
          other.content == this.content &&
          other.fontPreset == this.fontPreset &&
          other.fontSize == this.fontSize);
}

class NotebookPagesTableCompanion
    extends UpdateCompanion<NotebookPagesTableData> {
  final Value<String> id;
  final Value<String> notebookId;
  final Value<int> orderIndex;
  final Value<String> content;
  final Value<String> fontPreset;
  final Value<double> fontSize;
  final Value<int> rowid;
  const NotebookPagesTableCompanion({
    this.id = const Value.absent(),
    this.notebookId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.content = const Value.absent(),
    this.fontPreset = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotebookPagesTableCompanion.insert({
    required String id,
    required String notebookId,
    required int orderIndex,
    this.content = const Value.absent(),
    this.fontPreset = const Value.absent(),
    this.fontSize = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       notebookId = Value(notebookId),
       orderIndex = Value(orderIndex);
  static Insertable<NotebookPagesTableData> custom({
    Expression<String>? id,
    Expression<String>? notebookId,
    Expression<int>? orderIndex,
    Expression<String>? content,
    Expression<String>? fontPreset,
    Expression<double>? fontSize,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notebookId != null) 'notebook_id': notebookId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (content != null) 'content': content,
      if (fontPreset != null) 'font_preset': fontPreset,
      if (fontSize != null) 'font_size': fontSize,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotebookPagesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? notebookId,
    Value<int>? orderIndex,
    Value<String>? content,
    Value<String>? fontPreset,
    Value<double>? fontSize,
    Value<int>? rowid,
  }) {
    return NotebookPagesTableCompanion(
      id: id ?? this.id,
      notebookId: notebookId ?? this.notebookId,
      orderIndex: orderIndex ?? this.orderIndex,
      content: content ?? this.content,
      fontPreset: fontPreset ?? this.fontPreset,
      fontSize: fontSize ?? this.fontSize,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (notebookId.present) {
      map['notebook_id'] = Variable<String>(notebookId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (fontPreset.present) {
      map['font_preset'] = Variable<String>(fontPreset.value);
    }
    if (fontSize.present) {
      map['font_size'] = Variable<double>(fontSize.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotebookPagesTableCompanion(')
          ..write('id: $id, ')
          ..write('notebookId: $notebookId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('content: $content, ')
          ..write('fontPreset: $fontPreset, ')
          ..write('fontSize: $fontSize, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisionItemsTableTable extends VisionItemsTable
    with TableInfo<$VisionItemsTableTable, VisionItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisionItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<double> x = GeneratedColumn<double>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<double> y = GeneratedColumn<double>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<double> width = GeneratedColumn<double>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteTextMeta = const VerificationMeta(
    'noteText',
  );
  @override
  late final GeneratedColumn<String> noteText = GeneratedColumn<String>(
    'note_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    x,
    y,
    width,
    height,
    noteText,
    imagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vision_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisionItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('note_text')) {
      context.handle(
        _noteTextMeta,
        noteText.isAcceptableOrUnknown(data['note_text']!, _noteTextMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisionItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisionItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}y'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      noteText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_text'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
    );
  }

  @override
  $VisionItemsTableTable createAlias(String alias) {
    return $VisionItemsTableTable(attachedDatabase, alias);
  }
}

class VisionItemsTableData extends DataClass
    implements Insertable<VisionItemsTableData> {
  final String id;
  final String type;
  final double x;
  final double y;
  final double width;
  final double height;
  final String? noteText;
  final String? imagePath;
  const VisionItemsTableData({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.noteText,
    this.imagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['x'] = Variable<double>(x);
    map['y'] = Variable<double>(y);
    map['width'] = Variable<double>(width);
    map['height'] = Variable<double>(height);
    if (!nullToAbsent || noteText != null) {
      map['note_text'] = Variable<String>(noteText);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  VisionItemsTableCompanion toCompanion(bool nullToAbsent) {
    return VisionItemsTableCompanion(
      id: Value(id),
      type: Value(type),
      x: Value(x),
      y: Value(y),
      width: Value(width),
      height: Value(height),
      noteText: noteText == null && nullToAbsent
          ? const Value.absent()
          : Value(noteText),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory VisionItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisionItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      x: serializer.fromJson<double>(json['x']),
      y: serializer.fromJson<double>(json['y']),
      width: serializer.fromJson<double>(json['width']),
      height: serializer.fromJson<double>(json['height']),
      noteText: serializer.fromJson<String?>(json['noteText']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'x': serializer.toJson<double>(x),
      'y': serializer.toJson<double>(y),
      'width': serializer.toJson<double>(width),
      'height': serializer.toJson<double>(height),
      'noteText': serializer.toJson<String?>(noteText),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  VisionItemsTableData copyWith({
    String? id,
    String? type,
    double? x,
    double? y,
    double? width,
    double? height,
    Value<String?> noteText = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
  }) => VisionItemsTableData(
    id: id ?? this.id,
    type: type ?? this.type,
    x: x ?? this.x,
    y: y ?? this.y,
    width: width ?? this.width,
    height: height ?? this.height,
    noteText: noteText.present ? noteText.value : this.noteText,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
  );
  VisionItemsTableData copyWithCompanion(VisionItemsTableCompanion data) {
    return VisionItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
      noteText: data.noteText.present ? data.noteText.value : this.noteText,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisionItemsTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('noteText: $noteText, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, x, y, width, height, noteText, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisionItemsTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.x == this.x &&
          other.y == this.y &&
          other.width == this.width &&
          other.height == this.height &&
          other.noteText == this.noteText &&
          other.imagePath == this.imagePath);
}

class VisionItemsTableCompanion extends UpdateCompanion<VisionItemsTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<double> x;
  final Value<double> y;
  final Value<double> width;
  final Value<double> height;
  final Value<String?> noteText;
  final Value<String?> imagePath;
  final Value<int> rowid;
  const VisionItemsTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.noteText = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisionItemsTableCompanion.insert({
    required String id,
    required String type,
    required double x,
    required double y,
    required double width,
    required double height,
    this.noteText = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       x = Value(x),
       y = Value(y),
       width = Value(width),
       height = Value(height);
  static Insertable<VisionItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<double>? x,
    Expression<double>? y,
    Expression<double>? width,
    Expression<double>? height,
    Expression<String>? noteText,
    Expression<String>? imagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (noteText != null) 'note_text': noteText,
      if (imagePath != null) 'image_path': imagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisionItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<double>? x,
    Value<double>? y,
    Value<double>? width,
    Value<double>? height,
    Value<String?>? noteText,
    Value<String?>? imagePath,
    Value<int>? rowid,
  }) {
    return VisionItemsTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      noteText: noteText ?? this.noteText,
      imagePath: imagePath ?? this.imagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (x.present) {
      map['x'] = Variable<double>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<double>(y.value);
    }
    if (width.present) {
      map['width'] = Variable<double>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (noteText.present) {
      map['note_text'] = Variable<String>(noteText.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisionItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('noteText: $noteText, ')
          ..write('imagePath: $imagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTableTable extends GoalsTable
    with TableInfo<$GoalsTableTable, GoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _targetDateEpochMsMeta = const VerificationMeta(
    'targetDateEpochMs',
  );
  @override
  late final GeneratedColumn<int> targetDateEpochMs = GeneratedColumn<int>(
    'target_date_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    targetDateEpochMs,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalsTableData> instance, {
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('target_date_epoch_ms')) {
      context.handle(
        _targetDateEpochMsMeta,
        targetDateEpochMs.isAcceptableOrUnknown(
          data['target_date_epoch_ms']!,
          _targetDateEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      targetDateEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_date_epoch_ms'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $GoalsTableTable createAlias(String alias) {
    return $GoalsTableTable(attachedDatabase, alias);
  }
}

class GoalsTableData extends DataClass implements Insertable<GoalsTableData> {
  final String id;
  final String title;
  final String description;
  final int? targetDateEpochMs;
  final String status;
  const GoalsTableData({
    required this.id,
    required this.title,
    required this.description,
    this.targetDateEpochMs,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || targetDateEpochMs != null) {
      map['target_date_epoch_ms'] = Variable<int>(targetDateEpochMs);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  GoalsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      targetDateEpochMs: targetDateEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDateEpochMs),
      status: Value(status),
    );
  }

  factory GoalsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      targetDateEpochMs: serializer.fromJson<int?>(json['targetDateEpochMs']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'targetDateEpochMs': serializer.toJson<int?>(targetDateEpochMs),
      'status': serializer.toJson<String>(status),
    };
  }

  GoalsTableData copyWith({
    String? id,
    String? title,
    String? description,
    Value<int?> targetDateEpochMs = const Value.absent(),
    String? status,
  }) => GoalsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    targetDateEpochMs: targetDateEpochMs.present
        ? targetDateEpochMs.value
        : this.targetDateEpochMs,
    status: status ?? this.status,
  );
  GoalsTableData copyWithCompanion(GoalsTableCompanion data) {
    return GoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      targetDateEpochMs: data.targetDateEpochMs.present
          ? data.targetDateEpochMs.value
          : this.targetDateEpochMs,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('targetDateEpochMs: $targetDateEpochMs, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, targetDateEpochMs, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.targetDateEpochMs == this.targetDateEpochMs &&
          other.status == this.status);
}

class GoalsTableCompanion extends UpdateCompanion<GoalsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<int?> targetDateEpochMs;
  final Value<String> status;
  final Value<int> rowid;
  const GoalsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.targetDateEpochMs = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.targetDateEpochMs = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       status = Value(status);
  static Insertable<GoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? targetDateEpochMs,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (targetDateEpochMs != null) 'target_date_epoch_ms': targetDateEpochMs,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<int?>? targetDateEpochMs,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return GoalsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetDateEpochMs: targetDateEpochMs ?? this.targetDateEpochMs,
      status: status ?? this.status,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (targetDateEpochMs.present) {
      map['target_date_epoch_ms'] = Variable<int>(targetDateEpochMs.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('targetDateEpochMs: $targetDateEpochMs, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTableTable extends TasksTable
    with TableInfo<$TasksTableTable, TasksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES goals_table (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _dueDateEpochMsMeta = const VerificationMeta(
    'dueDateEpochMs',
  );
  @override
  late final GeneratedColumn<int> dueDateEpochMs = GeneratedColumn<int>(
    'due_date_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    title,
    dueDateEpochMs,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TasksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_date_epoch_ms')) {
      context.handle(
        _dueDateEpochMsMeta,
        dueDateEpochMs.isAcceptableOrUnknown(
          data['due_date_epoch_ms']!,
          _dueDateEpochMsMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TasksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TasksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueDateEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date_epoch_ms'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $TasksTableTable createAlias(String alias) {
    return $TasksTableTable(attachedDatabase, alias);
  }
}

class TasksTableData extends DataClass implements Insertable<TasksTableData> {
  final String id;
  final String goalId;
  final String title;
  final int? dueDateEpochMs;
  final String status;
  const TasksTableData({
    required this.id,
    required this.goalId,
    required this.title,
    this.dueDateEpochMs,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || dueDateEpochMs != null) {
      map['due_date_epoch_ms'] = Variable<int>(dueDateEpochMs);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  TasksTableCompanion toCompanion(bool nullToAbsent) {
    return TasksTableCompanion(
      id: Value(id),
      goalId: Value(goalId),
      title: Value(title),
      dueDateEpochMs: dueDateEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDateEpochMs),
      status: Value(status),
    );
  }

  factory TasksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TasksTableData(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      title: serializer.fromJson<String>(json['title']),
      dueDateEpochMs: serializer.fromJson<int?>(json['dueDateEpochMs']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'title': serializer.toJson<String>(title),
      'dueDateEpochMs': serializer.toJson<int?>(dueDateEpochMs),
      'status': serializer.toJson<String>(status),
    };
  }

  TasksTableData copyWith({
    String? id,
    String? goalId,
    String? title,
    Value<int?> dueDateEpochMs = const Value.absent(),
    String? status,
  }) => TasksTableData(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    title: title ?? this.title,
    dueDateEpochMs: dueDateEpochMs.present
        ? dueDateEpochMs.value
        : this.dueDateEpochMs,
    status: status ?? this.status,
  );
  TasksTableData copyWithCompanion(TasksTableCompanion data) {
    return TasksTableData(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      title: data.title.present ? data.title.value : this.title,
      dueDateEpochMs: data.dueDateEpochMs.present
          ? data.dueDateEpochMs.value
          : this.dueDateEpochMs,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableData(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('dueDateEpochMs: $dueDateEpochMs, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, title, dueDateEpochMs, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TasksTableData &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.title == this.title &&
          other.dueDateEpochMs == this.dueDateEpochMs &&
          other.status == this.status);
}

class TasksTableCompanion extends UpdateCompanion<TasksTableData> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> title;
  final Value<int?> dueDateEpochMs;
  final Value<String> status;
  final Value<int> rowid;
  const TasksTableCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueDateEpochMs = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksTableCompanion.insert({
    required String id,
    required String goalId,
    required String title,
    this.dueDateEpochMs = const Value.absent(),
    required String status,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       title = Value(title),
       status = Value(status);
  static Insertable<TasksTableData> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? title,
    Expression<int>? dueDateEpochMs,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (title != null) 'title': title,
      if (dueDateEpochMs != null) 'due_date_epoch_ms': dueDateEpochMs,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<String>? title,
    Value<int?>? dueDateEpochMs,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return TasksTableCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      dueDateEpochMs: dueDateEpochMs ?? this.dueDateEpochMs,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueDateEpochMs.present) {
      map['due_date_epoch_ms'] = Variable<int>(dueDateEpochMs.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksTableCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('title: $title, ')
          ..write('dueDateEpochMs: $dueDateEpochMs, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiChatSessionsTableTable extends AiChatSessionsTable
    with TableInfo<$AiChatSessionsTableTable, AiChatSessionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiChatSessionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  @override
  List<GeneratedColumn> get $columns => [id, createdAtEpochMs, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_chat_sessions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiChatSessionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiChatSessionsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiChatSessionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $AiChatSessionsTableTable createAlias(String alias) {
    return $AiChatSessionsTableTable(attachedDatabase, alias);
  }
}

class AiChatSessionsTableData extends DataClass
    implements Insertable<AiChatSessionsTableData> {
  final String id;
  final int createdAtEpochMs;
  final String title;
  const AiChatSessionsTableData({
    required this.id,
    required this.createdAtEpochMs,
    required this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    map['title'] = Variable<String>(title);
    return map;
  }

  AiChatSessionsTableCompanion toCompanion(bool nullToAbsent) {
    return AiChatSessionsTableCompanion(
      id: Value(id),
      createdAtEpochMs: Value(createdAtEpochMs),
      title: Value(title),
    );
  }

  factory AiChatSessionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiChatSessionsTableData(
      id: serializer.fromJson<String>(json['id']),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
      'title': serializer.toJson<String>(title),
    };
  }

  AiChatSessionsTableData copyWith({
    String? id,
    int? createdAtEpochMs,
    String? title,
  }) => AiChatSessionsTableData(
    id: id ?? this.id,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
    title: title ?? this.title,
  );
  AiChatSessionsTableData copyWithCompanion(AiChatSessionsTableCompanion data) {
    return AiChatSessionsTableData(
      id: data.id.present ? data.id.value : this.id,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiChatSessionsTableData(')
          ..write('id: $id, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAtEpochMs, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiChatSessionsTableData &&
          other.id == this.id &&
          other.createdAtEpochMs == this.createdAtEpochMs &&
          other.title == this.title);
}

class AiChatSessionsTableCompanion
    extends UpdateCompanion<AiChatSessionsTableData> {
  final Value<String> id;
  final Value<int> createdAtEpochMs;
  final Value<String> title;
  final Value<int> rowid;
  const AiChatSessionsTableCompanion({
    this.id = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
    this.title = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiChatSessionsTableCompanion.insert({
    required String id,
    required int createdAtEpochMs,
    required String title,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtEpochMs = Value(createdAtEpochMs),
       title = Value(title);
  static Insertable<AiChatSessionsTableData> custom({
    Expression<String>? id,
    Expression<int>? createdAtEpochMs,
    Expression<String>? title,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
      if (title != null) 'title': title,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiChatSessionsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAtEpochMs,
    Value<String>? title,
    Value<int>? rowid,
  }) {
    return AiChatSessionsTableCompanion(
      id: id ?? this.id,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
      title: title ?? this.title,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiChatSessionsTableCompanion(')
          ..write('id: $id, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('title: $title, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiChatMessagesTableTable extends AiChatMessagesTable
    with TableInfo<$AiChatMessagesTableTable, AiChatMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiChatMessagesTableTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES ai_chat_sessions_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtEpochMsMeta = const VerificationMeta(
    'createdAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> createdAtEpochMs = GeneratedColumn<int>(
    'created_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    role,
    content,
    createdAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_chat_messages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiChatMessagesTableData> instance, {
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
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at_epoch_ms')) {
      context.handle(
        _createdAtEpochMsMeta,
        createdAtEpochMs.isAcceptableOrUnknown(
          data['created_at_epoch_ms']!,
          _createdAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtEpochMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiChatMessagesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiChatMessagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_epoch_ms'],
      )!,
    );
  }

  @override
  $AiChatMessagesTableTable createAlias(String alias) {
    return $AiChatMessagesTableTable(attachedDatabase, alias);
  }
}

class AiChatMessagesTableData extends DataClass
    implements Insertable<AiChatMessagesTableData> {
  final String id;
  final String sessionId;
  final String role;
  final String content;
  final int createdAtEpochMs;
  const AiChatMessagesTableData({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs);
    return map;
  }

  AiChatMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return AiChatMessagesTableCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      role: Value(role),
      content: Value(content),
      createdAtEpochMs: Value(createdAtEpochMs),
    );
  }

  factory AiChatMessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiChatMessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAtEpochMs: serializer.fromJson<int>(json['createdAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAtEpochMs': serializer.toJson<int>(createdAtEpochMs),
    };
  }

  AiChatMessagesTableData copyWith({
    String? id,
    String? sessionId,
    String? role,
    String? content,
    int? createdAtEpochMs,
  }) => AiChatMessagesTableData(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    role: role ?? this.role,
    content: content ?? this.content,
    createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
  );
  AiChatMessagesTableData copyWithCompanion(AiChatMessagesTableCompanion data) {
    return AiChatMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAtEpochMs: data.createdAtEpochMs.present
          ? data.createdAtEpochMs.value
          : this.createdAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiChatMessagesTableData(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAtEpochMs: $createdAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, role, content, createdAtEpochMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiChatMessagesTableData &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAtEpochMs == this.createdAtEpochMs);
}

class AiChatMessagesTableCompanion
    extends UpdateCompanion<AiChatMessagesTableData> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> role;
  final Value<String> content;
  final Value<int> createdAtEpochMs;
  final Value<int> rowid;
  const AiChatMessagesTableCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAtEpochMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiChatMessagesTableCompanion.insert({
    required String id,
    required String sessionId,
    required String role,
    required String content,
    required int createdAtEpochMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       role = Value(role),
       content = Value(content),
       createdAtEpochMs = Value(createdAtEpochMs);
  static Insertable<AiChatMessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<int>? createdAtEpochMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAtEpochMs != null) 'created_at_epoch_ms': createdAtEpochMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiChatMessagesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? role,
    Value<String>? content,
    Value<int>? createdAtEpochMs,
    Value<int>? rowid,
  }) {
    return AiChatMessagesTableCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAtEpochMs: createdAtEpochMs ?? this.createdAtEpochMs,
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
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAtEpochMs.present) {
      map['created_at_epoch_ms'] = Variable<int>(createdAtEpochMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiChatMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAtEpochMs: $createdAtEpochMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiSettingsTableTable extends AiSettingsTable
    with TableInfo<$AiSettingsTableTable, AiSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _singletonIdMeta = const VerificationMeta(
    'singletonId',
  );
  @override
  late final GeneratedColumn<int> singletonId = GeneratedColumn<int>(
    'singleton_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedModelMeta = const VerificationMeta(
    'selectedModel',
  );
  @override
  late final GeneratedColumn<String> selectedModel = GeneratedColumn<String>(
    'selected_model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('gpt-4.1-mini'),
  );
  static const VerificationMeta _notebookContextEnabledMeta =
      const VerificationMeta('notebookContextEnabled');
  @override
  late final GeneratedColumn<bool> notebookContextEnabled =
      GeneratedColumn<bool>(
        'notebook_context_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notebook_context_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _enableAssistantActionsMeta =
      const VerificationMeta('enableAssistantActions');
  @override
  late final GeneratedColumn<bool> enableAssistantActions =
      GeneratedColumn<bool>(
        'enable_assistant_actions',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_assistant_actions" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  @override
  List<GeneratedColumn> get $columns => [
    singletonId,
    selectedModel,
    notebookContextEnabled,
    enableAssistantActions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('singleton_id')) {
      context.handle(
        _singletonIdMeta,
        singletonId.isAcceptableOrUnknown(
          data['singleton_id']!,
          _singletonIdMeta,
        ),
      );
    }
    if (data.containsKey('selected_model')) {
      context.handle(
        _selectedModelMeta,
        selectedModel.isAcceptableOrUnknown(
          data['selected_model']!,
          _selectedModelMeta,
        ),
      );
    }
    if (data.containsKey('notebook_context_enabled')) {
      context.handle(
        _notebookContextEnabledMeta,
        notebookContextEnabled.isAcceptableOrUnknown(
          data['notebook_context_enabled']!,
          _notebookContextEnabledMeta,
        ),
      );
    }
    if (data.containsKey('enable_assistant_actions')) {
      context.handle(
        _enableAssistantActionsMeta,
        enableAssistantActions.isAcceptableOrUnknown(
          data['enable_assistant_actions']!,
          _enableAssistantActionsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {singletonId};
  @override
  AiSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiSettingsTableData(
      singletonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}singleton_id'],
      )!,
      selectedModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_model'],
      )!,
      notebookContextEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notebook_context_enabled'],
      )!,
      enableAssistantActions: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enable_assistant_actions'],
      )!,
    );
  }

  @override
  $AiSettingsTableTable createAlias(String alias) {
    return $AiSettingsTableTable(attachedDatabase, alias);
  }
}

class AiSettingsTableData extends DataClass
    implements Insertable<AiSettingsTableData> {
  final int singletonId;
  final String selectedModel;
  final bool notebookContextEnabled;
  final bool enableAssistantActions;
  const AiSettingsTableData({
    required this.singletonId,
    required this.selectedModel,
    required this.notebookContextEnabled,
    required this.enableAssistantActions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['singleton_id'] = Variable<int>(singletonId);
    map['selected_model'] = Variable<String>(selectedModel);
    map['notebook_context_enabled'] = Variable<bool>(notebookContextEnabled);
    map['enable_assistant_actions'] = Variable<bool>(enableAssistantActions);
    return map;
  }

  AiSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AiSettingsTableCompanion(
      singletonId: Value(singletonId),
      selectedModel: Value(selectedModel),
      notebookContextEnabled: Value(notebookContextEnabled),
      enableAssistantActions: Value(enableAssistantActions),
    );
  }

  factory AiSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiSettingsTableData(
      singletonId: serializer.fromJson<int>(json['singletonId']),
      selectedModel: serializer.fromJson<String>(json['selectedModel']),
      notebookContextEnabled: serializer.fromJson<bool>(
        json['notebookContextEnabled'],
      ),
      enableAssistantActions: serializer.fromJson<bool>(
        json['enableAssistantActions'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'singletonId': serializer.toJson<int>(singletonId),
      'selectedModel': serializer.toJson<String>(selectedModel),
      'notebookContextEnabled': serializer.toJson<bool>(notebookContextEnabled),
      'enableAssistantActions': serializer.toJson<bool>(enableAssistantActions),
    };
  }

  AiSettingsTableData copyWith({
    int? singletonId,
    String? selectedModel,
    bool? notebookContextEnabled,
    bool? enableAssistantActions,
  }) => AiSettingsTableData(
    singletonId: singletonId ?? this.singletonId,
    selectedModel: selectedModel ?? this.selectedModel,
    notebookContextEnabled:
        notebookContextEnabled ?? this.notebookContextEnabled,
    enableAssistantActions:
        enableAssistantActions ?? this.enableAssistantActions,
  );
  AiSettingsTableData copyWithCompanion(AiSettingsTableCompanion data) {
    return AiSettingsTableData(
      singletonId: data.singletonId.present
          ? data.singletonId.value
          : this.singletonId,
      selectedModel: data.selectedModel.present
          ? data.selectedModel.value
          : this.selectedModel,
      notebookContextEnabled: data.notebookContextEnabled.present
          ? data.notebookContextEnabled.value
          : this.notebookContextEnabled,
      enableAssistantActions: data.enableAssistantActions.present
          ? data.enableAssistantActions.value
          : this.enableAssistantActions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiSettingsTableData(')
          ..write('singletonId: $singletonId, ')
          ..write('selectedModel: $selectedModel, ')
          ..write('notebookContextEnabled: $notebookContextEnabled, ')
          ..write('enableAssistantActions: $enableAssistantActions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    singletonId,
    selectedModel,
    notebookContextEnabled,
    enableAssistantActions,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiSettingsTableData &&
          other.singletonId == this.singletonId &&
          other.selectedModel == this.selectedModel &&
          other.notebookContextEnabled == this.notebookContextEnabled &&
          other.enableAssistantActions == this.enableAssistantActions);
}

class AiSettingsTableCompanion extends UpdateCompanion<AiSettingsTableData> {
  final Value<int> singletonId;
  final Value<String> selectedModel;
  final Value<bool> notebookContextEnabled;
  final Value<bool> enableAssistantActions;
  const AiSettingsTableCompanion({
    this.singletonId = const Value.absent(),
    this.selectedModel = const Value.absent(),
    this.notebookContextEnabled = const Value.absent(),
    this.enableAssistantActions = const Value.absent(),
  });
  AiSettingsTableCompanion.insert({
    this.singletonId = const Value.absent(),
    this.selectedModel = const Value.absent(),
    this.notebookContextEnabled = const Value.absent(),
    this.enableAssistantActions = const Value.absent(),
  });
  static Insertable<AiSettingsTableData> custom({
    Expression<int>? singletonId,
    Expression<String>? selectedModel,
    Expression<bool>? notebookContextEnabled,
    Expression<bool>? enableAssistantActions,
  }) {
    return RawValuesInsertable({
      if (singletonId != null) 'singleton_id': singletonId,
      if (selectedModel != null) 'selected_model': selectedModel,
      if (notebookContextEnabled != null)
        'notebook_context_enabled': notebookContextEnabled,
      if (enableAssistantActions != null)
        'enable_assistant_actions': enableAssistantActions,
    });
  }

  AiSettingsTableCompanion copyWith({
    Value<int>? singletonId,
    Value<String>? selectedModel,
    Value<bool>? notebookContextEnabled,
    Value<bool>? enableAssistantActions,
  }) {
    return AiSettingsTableCompanion(
      singletonId: singletonId ?? this.singletonId,
      selectedModel: selectedModel ?? this.selectedModel,
      notebookContextEnabled:
          notebookContextEnabled ?? this.notebookContextEnabled,
      enableAssistantActions:
          enableAssistantActions ?? this.enableAssistantActions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (singletonId.present) {
      map['singleton_id'] = Variable<int>(singletonId.value);
    }
    if (selectedModel.present) {
      map['selected_model'] = Variable<String>(selectedModel.value);
    }
    if (notebookContextEnabled.present) {
      map['notebook_context_enabled'] = Variable<bool>(
        notebookContextEnabled.value,
      );
    }
    if (enableAssistantActions.present) {
      map['enable_assistant_actions'] = Variable<bool>(
        enableAssistantActions.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiSettingsTableCompanion(')
          ..write('singletonId: $singletonId, ')
          ..write('selectedModel: $selectedModel, ')
          ..write('notebookContextEnabled: $notebookContextEnabled, ')
          ..write('enableAssistantActions: $enableAssistantActions')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $NotebooksTableTable notebooksTable = $NotebooksTableTable(this);
  late final $NotebookPagesTableTable notebookPagesTable =
      $NotebookPagesTableTable(this);
  late final $VisionItemsTableTable visionItemsTable = $VisionItemsTableTable(
    this,
  );
  late final $GoalsTableTable goalsTable = $GoalsTableTable(this);
  late final $TasksTableTable tasksTable = $TasksTableTable(this);
  late final $AiChatSessionsTableTable aiChatSessionsTable =
      $AiChatSessionsTableTable(this);
  late final $AiChatMessagesTableTable aiChatMessagesTable =
      $AiChatMessagesTableTable(this);
  late final $AiSettingsTableTable aiSettingsTable = $AiSettingsTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settingsTable,
    notebooksTable,
    notebookPagesTable,
    visionItemsTable,
    goalsTable,
    tasksTable,
    aiChatSessionsTable,
    aiChatMessagesTable,
    aiSettingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'notebooks_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notebook_pages_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'goals_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tasks_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'ai_chat_sessions_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ai_chat_messages_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> singletonId,
      required int birthDateEpochMs,
      required int lifespanYears,
      Value<int> yearDotRows,
      Value<bool> notebookAiAccessEnabled,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> singletonId,
      Value<int> birthDateEpochMs,
      Value<int> lifespanYears,
      Value<int> yearDotRows,
      Value<bool> notebookAiAccessEnabled,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthDateEpochMs => $composableBuilder(
    column: $table.birthDateEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifespanYears => $composableBuilder(
    column: $table.lifespanYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearDotRows => $composableBuilder(
    column: $table.yearDotRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notebookAiAccessEnabled => $composableBuilder(
    column: $table.notebookAiAccessEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthDateEpochMs => $composableBuilder(
    column: $table.birthDateEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifespanYears => $composableBuilder(
    column: $table.lifespanYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearDotRows => $composableBuilder(
    column: $table.yearDotRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notebookAiAccessEnabled => $composableBuilder(
    column: $table.notebookAiAccessEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get birthDateEpochMs => $composableBuilder(
    column: $table.birthDateEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lifespanYears => $composableBuilder(
    column: $table.lifespanYears,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearDotRows => $composableBuilder(
    column: $table.yearDotRows,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notebookAiAccessEnabled => $composableBuilder(
    column: $table.notebookAiAccessEnabled,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsTableData,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $SettingsTableTable,
              SettingsTableData
            >,
          ),
          SettingsTableData,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                Value<int> birthDateEpochMs = const Value.absent(),
                Value<int> lifespanYears = const Value.absent(),
                Value<int> yearDotRows = const Value.absent(),
                Value<bool> notebookAiAccessEnabled = const Value.absent(),
              }) => SettingsTableCompanion(
                singletonId: singletonId,
                birthDateEpochMs: birthDateEpochMs,
                lifespanYears: lifespanYears,
                yearDotRows: yearDotRows,
                notebookAiAccessEnabled: notebookAiAccessEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                required int birthDateEpochMs,
                required int lifespanYears,
                Value<int> yearDotRows = const Value.absent(),
                Value<bool> notebookAiAccessEnabled = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                singletonId: singletonId,
                birthDateEpochMs: birthDateEpochMs,
                lifespanYears: lifespanYears,
                yearDotRows: yearDotRows,
                notebookAiAccessEnabled: notebookAiAccessEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsTableData,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsTableData,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>,
      ),
      SettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$NotebooksTableTableCreateCompanionBuilder =
    NotebooksTableCompanion Function({
      required String id,
      required String title,
      Value<String?> subtitle,
      required int createdAtEpochMs,
      Value<int> rowid,
    });
typedef $$NotebooksTableTableUpdateCompanionBuilder =
    NotebooksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> subtitle,
      Value<int> createdAtEpochMs,
      Value<int> rowid,
    });

final class $$NotebooksTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $NotebooksTableTable,
          NotebooksTableData
        > {
  $$NotebooksTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $NotebookPagesTableTable,
    List<NotebookPagesTableData>
  >
  _notebookPagesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.notebookPagesTable,
        aliasName: $_aliasNameGenerator(
          db.notebooksTable.id,
          db.notebookPagesTable.notebookId,
        ),
      );

  $$NotebookPagesTableTableProcessedTableManager get notebookPagesTableRefs {
    final manager = $$NotebookPagesTableTableTableManager(
      $_db,
      $_db.notebookPagesTable,
    ).filter((f) => f.notebookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _notebookPagesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NotebooksTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotebooksTableTable> {
  $$NotebooksTableTableFilterComposer({
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

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> notebookPagesTableRefs(
    Expression<bool> Function($$NotebookPagesTableTableFilterComposer f) f,
  ) {
    final $$NotebookPagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notebookPagesTable,
      getReferencedColumn: (t) => t.notebookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebookPagesTableTableFilterComposer(
            $db: $db,
            $table: $db.notebookPagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotebooksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotebooksTableTable> {
  $$NotebooksTableTableOrderingComposer({
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

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotebooksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotebooksTableTable> {
  $$NotebooksTableTableAnnotationComposer({
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

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  Expression<T> notebookPagesTableRefs<T extends Object>(
    Expression<T> Function($$NotebookPagesTableTableAnnotationComposer a) f,
  ) {
    final $$NotebookPagesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.notebookPagesTable,
          getReferencedColumn: (t) => t.notebookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$NotebookPagesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.notebookPagesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$NotebooksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotebooksTableTable,
          NotebooksTableData,
          $$NotebooksTableTableFilterComposer,
          $$NotebooksTableTableOrderingComposer,
          $$NotebooksTableTableAnnotationComposer,
          $$NotebooksTableTableCreateCompanionBuilder,
          $$NotebooksTableTableUpdateCompanionBuilder,
          (NotebooksTableData, $$NotebooksTableTableReferences),
          NotebooksTableData,
          PrefetchHooks Function({bool notebookPagesTableRefs})
        > {
  $$NotebooksTableTableTableManager(
    _$AppDatabase db,
    $NotebooksTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotebooksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotebooksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotebooksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotebooksTableCompanion(
                id: id,
                title: title,
                subtitle: subtitle,
                createdAtEpochMs: createdAtEpochMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> subtitle = const Value.absent(),
                required int createdAtEpochMs,
                Value<int> rowid = const Value.absent(),
              }) => NotebooksTableCompanion.insert(
                id: id,
                title: title,
                subtitle: subtitle,
                createdAtEpochMs: createdAtEpochMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NotebooksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({notebookPagesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (notebookPagesTableRefs) db.notebookPagesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (notebookPagesTableRefs)
                    await $_getPrefetchedData<
                      NotebooksTableData,
                      $NotebooksTableTable,
                      NotebookPagesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$NotebooksTableTableReferences
                          ._notebookPagesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NotebooksTableTableReferences(
                            db,
                            table,
                            p0,
                          ).notebookPagesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.notebookId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NotebooksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotebooksTableTable,
      NotebooksTableData,
      $$NotebooksTableTableFilterComposer,
      $$NotebooksTableTableOrderingComposer,
      $$NotebooksTableTableAnnotationComposer,
      $$NotebooksTableTableCreateCompanionBuilder,
      $$NotebooksTableTableUpdateCompanionBuilder,
      (NotebooksTableData, $$NotebooksTableTableReferences),
      NotebooksTableData,
      PrefetchHooks Function({bool notebookPagesTableRefs})
    >;
typedef $$NotebookPagesTableTableCreateCompanionBuilder =
    NotebookPagesTableCompanion Function({
      required String id,
      required String notebookId,
      required int orderIndex,
      Value<String> content,
      Value<String> fontPreset,
      Value<double> fontSize,
      Value<int> rowid,
    });
typedef $$NotebookPagesTableTableUpdateCompanionBuilder =
    NotebookPagesTableCompanion Function({
      Value<String> id,
      Value<String> notebookId,
      Value<int> orderIndex,
      Value<String> content,
      Value<String> fontPreset,
      Value<double> fontSize,
      Value<int> rowid,
    });

final class $$NotebookPagesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $NotebookPagesTableTable,
          NotebookPagesTableData
        > {
  $$NotebookPagesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NotebooksTableTable _notebookIdTable(_$AppDatabase db) =>
      db.notebooksTable.createAlias(
        $_aliasNameGenerator(
          db.notebookPagesTable.notebookId,
          db.notebooksTable.id,
        ),
      );

  $$NotebooksTableTableProcessedTableManager get notebookId {
    final $_column = $_itemColumn<String>('notebook_id')!;

    final manager = $$NotebooksTableTableTableManager(
      $_db,
      $_db.notebooksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_notebookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotebookPagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotebookPagesTableTable> {
  $$NotebookPagesTableTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fontPreset => $composableBuilder(
    column: $table.fontPreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnFilters(column),
  );

  $$NotebooksTableTableFilterComposer get notebookId {
    final $$NotebooksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notebookId,
      referencedTable: $db.notebooksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebooksTableTableFilterComposer(
            $db: $db,
            $table: $db.notebooksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotebookPagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotebookPagesTableTable> {
  $$NotebookPagesTableTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontPreset => $composableBuilder(
    column: $table.fontPreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontSize => $composableBuilder(
    column: $table.fontSize,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotebooksTableTableOrderingComposer get notebookId {
    final $$NotebooksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notebookId,
      referencedTable: $db.notebooksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebooksTableTableOrderingComposer(
            $db: $db,
            $table: $db.notebooksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotebookPagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotebookPagesTableTable> {
  $$NotebookPagesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get fontPreset => $composableBuilder(
    column: $table.fontPreset,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fontSize =>
      $composableBuilder(column: $table.fontSize, builder: (column) => column);

  $$NotebooksTableTableAnnotationComposer get notebookId {
    final $$NotebooksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notebookId,
      referencedTable: $db.notebooksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebooksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.notebooksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotebookPagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotebookPagesTableTable,
          NotebookPagesTableData,
          $$NotebookPagesTableTableFilterComposer,
          $$NotebookPagesTableTableOrderingComposer,
          $$NotebookPagesTableTableAnnotationComposer,
          $$NotebookPagesTableTableCreateCompanionBuilder,
          $$NotebookPagesTableTableUpdateCompanionBuilder,
          (NotebookPagesTableData, $$NotebookPagesTableTableReferences),
          NotebookPagesTableData,
          PrefetchHooks Function({bool notebookId})
        > {
  $$NotebookPagesTableTableTableManager(
    _$AppDatabase db,
    $NotebookPagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotebookPagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotebookPagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotebookPagesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> notebookId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> fontPreset = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotebookPagesTableCompanion(
                id: id,
                notebookId: notebookId,
                orderIndex: orderIndex,
                content: content,
                fontPreset: fontPreset,
                fontSize: fontSize,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String notebookId,
                required int orderIndex,
                Value<String> content = const Value.absent(),
                Value<String> fontPreset = const Value.absent(),
                Value<double> fontSize = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotebookPagesTableCompanion.insert(
                id: id,
                notebookId: notebookId,
                orderIndex: orderIndex,
                content: content,
                fontPreset: fontPreset,
                fontSize: fontSize,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NotebookPagesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({notebookId = false}) {
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
                    if (notebookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.notebookId,
                                referencedTable:
                                    $$NotebookPagesTableTableReferences
                                        ._notebookIdTable(db),
                                referencedColumn:
                                    $$NotebookPagesTableTableReferences
                                        ._notebookIdTable(db)
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

typedef $$NotebookPagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotebookPagesTableTable,
      NotebookPagesTableData,
      $$NotebookPagesTableTableFilterComposer,
      $$NotebookPagesTableTableOrderingComposer,
      $$NotebookPagesTableTableAnnotationComposer,
      $$NotebookPagesTableTableCreateCompanionBuilder,
      $$NotebookPagesTableTableUpdateCompanionBuilder,
      (NotebookPagesTableData, $$NotebookPagesTableTableReferences),
      NotebookPagesTableData,
      PrefetchHooks Function({bool notebookId})
    >;
typedef $$VisionItemsTableTableCreateCompanionBuilder =
    VisionItemsTableCompanion Function({
      required String id,
      required String type,
      required double x,
      required double y,
      required double width,
      required double height,
      Value<String?> noteText,
      Value<String?> imagePath,
      Value<int> rowid,
    });
typedef $$VisionItemsTableTableUpdateCompanionBuilder =
    VisionItemsTableCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<double> x,
      Value<double> y,
      Value<double> width,
      Value<double> height,
      Value<String?> noteText,
      Value<String?> imagePath,
      Value<int> rowid,
    });

class $$VisionItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $VisionItemsTableTable> {
  $$VisionItemsTableTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VisionItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VisionItemsTableTable> {
  $$VisionItemsTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteText => $composableBuilder(
    column: $table.noteText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisionItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisionItemsTableTable> {
  $$VisionItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<double> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<double> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<String> get noteText =>
      $composableBuilder(column: $table.noteText, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);
}

class $$VisionItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisionItemsTableTable,
          VisionItemsTableData,
          $$VisionItemsTableTableFilterComposer,
          $$VisionItemsTableTableOrderingComposer,
          $$VisionItemsTableTableAnnotationComposer,
          $$VisionItemsTableTableCreateCompanionBuilder,
          $$VisionItemsTableTableUpdateCompanionBuilder,
          (
            VisionItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $VisionItemsTableTable,
              VisionItemsTableData
            >,
          ),
          VisionItemsTableData,
          PrefetchHooks Function()
        > {
  $$VisionItemsTableTableTableManager(
    _$AppDatabase db,
    $VisionItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisionItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisionItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisionItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> x = const Value.absent(),
                Value<double> y = const Value.absent(),
                Value<double> width = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<String?> noteText = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionItemsTableCompanion(
                id: id,
                type: type,
                x: x,
                y: y,
                width: width,
                height: height,
                noteText: noteText,
                imagePath: imagePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required double x,
                required double y,
                required double width,
                required double height,
                Value<String?> noteText = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionItemsTableCompanion.insert(
                id: id,
                type: type,
                x: x,
                y: y,
                width: width,
                height: height,
                noteText: noteText,
                imagePath: imagePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisionItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisionItemsTableTable,
      VisionItemsTableData,
      $$VisionItemsTableTableFilterComposer,
      $$VisionItemsTableTableOrderingComposer,
      $$VisionItemsTableTableAnnotationComposer,
      $$VisionItemsTableTableCreateCompanionBuilder,
      $$VisionItemsTableTableUpdateCompanionBuilder,
      (
        VisionItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $VisionItemsTableTable,
          VisionItemsTableData
        >,
      ),
      VisionItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableTableCreateCompanionBuilder =
    GoalsTableCompanion Function({
      required String id,
      required String title,
      Value<String> description,
      Value<int?> targetDateEpochMs,
      required String status,
      Value<int> rowid,
    });
typedef $$GoalsTableTableUpdateCompanionBuilder =
    GoalsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<int?> targetDateEpochMs,
      Value<String> status,
      Value<int> rowid,
    });

final class $$GoalsTableTableReferences
    extends BaseReferences<_$AppDatabase, $GoalsTableTable, GoalsTableData> {
  $$GoalsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TasksTableTable, List<TasksTableData>>
  _tasksTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tasksTable,
    aliasName: $_aliasNameGenerator(db.goalsTable.id, db.tasksTable.goalId),
  );

  $$TasksTableTableProcessedTableManager get tasksTableRefs {
    final manager = $$TasksTableTableTableManager(
      $_db,
      $_db.tasksTable,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDateEpochMs => $composableBuilder(
    column: $table.targetDateEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tasksTableRefs(
    Expression<bool> Function($$TasksTableTableFilterComposer f) f,
  ) {
    final $$TasksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableFilterComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDateEpochMs => $composableBuilder(
    column: $table.targetDateEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTableTable> {
  $$GoalsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDateEpochMs => $composableBuilder(
    column: $table.targetDateEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  Expression<T> tasksTableRefs<T extends Object>(
    Expression<T> Function($$TasksTableTableAnnotationComposer a) f,
  ) {
    final $$TasksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasksTable,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tasksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTableTable,
          GoalsTableData,
          $$GoalsTableTableFilterComposer,
          $$GoalsTableTableOrderingComposer,
          $$GoalsTableTableAnnotationComposer,
          $$GoalsTableTableCreateCompanionBuilder,
          $$GoalsTableTableUpdateCompanionBuilder,
          (GoalsTableData, $$GoalsTableTableReferences),
          GoalsTableData,
          PrefetchHooks Function({bool tasksTableRefs})
        > {
  $$GoalsTableTableTableManager(_$AppDatabase db, $GoalsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> targetDateEpochMs = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion(
                id: id,
                title: title,
                description: description,
                targetDateEpochMs: targetDateEpochMs,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> description = const Value.absent(),
                Value<int?> targetDateEpochMs = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => GoalsTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                targetDateEpochMs: targetDateEpochMs,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tasksTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksTableRefs) db.tasksTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksTableRefs)
                    await $_getPrefetchedData<
                      GoalsTableData,
                      $GoalsTableTable,
                      TasksTableData
                    >(
                      currentTable: table,
                      referencedTable: $$GoalsTableTableReferences
                          ._tasksTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GoalsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).tasksTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.goalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$GoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTableTable,
      GoalsTableData,
      $$GoalsTableTableFilterComposer,
      $$GoalsTableTableOrderingComposer,
      $$GoalsTableTableAnnotationComposer,
      $$GoalsTableTableCreateCompanionBuilder,
      $$GoalsTableTableUpdateCompanionBuilder,
      (GoalsTableData, $$GoalsTableTableReferences),
      GoalsTableData,
      PrefetchHooks Function({bool tasksTableRefs})
    >;
typedef $$TasksTableTableCreateCompanionBuilder =
    TasksTableCompanion Function({
      required String id,
      required String goalId,
      required String title,
      Value<int?> dueDateEpochMs,
      required String status,
      Value<int> rowid,
    });
typedef $$TasksTableTableUpdateCompanionBuilder =
    TasksTableCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<String> title,
      Value<int?> dueDateEpochMs,
      Value<String> status,
      Value<int> rowid,
    });

final class $$TasksTableTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTableTable, TasksTableData> {
  $$TasksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GoalsTableTable _goalIdTable(_$AppDatabase db) =>
      db.goalsTable.createAlias(
        $_aliasNameGenerator(db.tasksTable.goalId, db.goalsTable.id),
      );

  $$GoalsTableTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$GoalsTableTableTableManager(
      $_db,
      $_db.goalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TasksTableTableFilterComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableFilterComposer({
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

  ColumnFilters<int> get dueDateEpochMs => $composableBuilder(
    column: $table.dueDateEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  $$GoalsTableTableFilterComposer get goalId {
    final $$GoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableOrderingComposer({
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

  ColumnOrderings<int> get dueDateEpochMs => $composableBuilder(
    column: $table.dueDateEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  $$GoalsTableTableOrderingComposer get goalId {
    final $$GoalsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableOrderingComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTableTable> {
  $$TasksTableTableAnnotationComposer({
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

  GeneratedColumn<int> get dueDateEpochMs => $composableBuilder(
    column: $table.dueDateEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  $$GoalsTableTableAnnotationComposer get goalId {
    final $$GoalsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.goalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.goalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTableTable,
          TasksTableData,
          $$TasksTableTableFilterComposer,
          $$TasksTableTableOrderingComposer,
          $$TasksTableTableAnnotationComposer,
          $$TasksTableTableCreateCompanionBuilder,
          $$TasksTableTableUpdateCompanionBuilder,
          (TasksTableData, $$TasksTableTableReferences),
          TasksTableData,
          PrefetchHooks Function({bool goalId})
        > {
  $$TasksTableTableTableManager(_$AppDatabase db, $TasksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> dueDateEpochMs = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion(
                id: id,
                goalId: goalId,
                title: title,
                dueDateEpochMs: dueDateEpochMs,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required String title,
                Value<int?> dueDateEpochMs = const Value.absent(),
                required String status,
                Value<int> rowid = const Value.absent(),
              }) => TasksTableCompanion.insert(
                id: id,
                goalId: goalId,
                title: title,
                dueDateEpochMs: dueDateEpochMs,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TasksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
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
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable: $$TasksTableTableReferences
                                    ._goalIdTable(db),
                                referencedColumn: $$TasksTableTableReferences
                                    ._goalIdTable(db)
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

typedef $$TasksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTableTable,
      TasksTableData,
      $$TasksTableTableFilterComposer,
      $$TasksTableTableOrderingComposer,
      $$TasksTableTableAnnotationComposer,
      $$TasksTableTableCreateCompanionBuilder,
      $$TasksTableTableUpdateCompanionBuilder,
      (TasksTableData, $$TasksTableTableReferences),
      TasksTableData,
      PrefetchHooks Function({bool goalId})
    >;
typedef $$AiChatSessionsTableTableCreateCompanionBuilder =
    AiChatSessionsTableCompanion Function({
      required String id,
      required int createdAtEpochMs,
      required String title,
      Value<int> rowid,
    });
typedef $$AiChatSessionsTableTableUpdateCompanionBuilder =
    AiChatSessionsTableCompanion Function({
      Value<String> id,
      Value<int> createdAtEpochMs,
      Value<String> title,
      Value<int> rowid,
    });

final class $$AiChatSessionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AiChatSessionsTableTable,
          AiChatSessionsTableData
        > {
  $$AiChatSessionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $AiChatMessagesTableTable,
    List<AiChatMessagesTableData>
  >
  _aiChatMessagesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.aiChatMessagesTable,
        aliasName: $_aliasNameGenerator(
          db.aiChatSessionsTable.id,
          db.aiChatMessagesTable.sessionId,
        ),
      );

  $$AiChatMessagesTableTableProcessedTableManager get aiChatMessagesTableRefs {
    final manager = $$AiChatMessagesTableTableTableManager(
      $_db,
      $_db.aiChatMessagesTable,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _aiChatMessagesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AiChatSessionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AiChatSessionsTableTable> {
  $$AiChatSessionsTableTableFilterComposer({
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

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> aiChatMessagesTableRefs(
    Expression<bool> Function($$AiChatMessagesTableTableFilterComposer f) f,
  ) {
    final $$AiChatMessagesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiChatMessagesTable,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiChatMessagesTableTableFilterComposer(
            $db: $db,
            $table: $db.aiChatMessagesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AiChatSessionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AiChatSessionsTableTable> {
  $$AiChatSessionsTableTableOrderingComposer({
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

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiChatSessionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiChatSessionsTableTable> {
  $$AiChatSessionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> aiChatMessagesTableRefs<T extends Object>(
    Expression<T> Function($$AiChatMessagesTableTableAnnotationComposer a) f,
  ) {
    final $$AiChatMessagesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.aiChatMessagesTable,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AiChatMessagesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.aiChatMessagesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AiChatSessionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiChatSessionsTableTable,
          AiChatSessionsTableData,
          $$AiChatSessionsTableTableFilterComposer,
          $$AiChatSessionsTableTableOrderingComposer,
          $$AiChatSessionsTableTableAnnotationComposer,
          $$AiChatSessionsTableTableCreateCompanionBuilder,
          $$AiChatSessionsTableTableUpdateCompanionBuilder,
          (AiChatSessionsTableData, $$AiChatSessionsTableTableReferences),
          AiChatSessionsTableData,
          PrefetchHooks Function({bool aiChatMessagesTableRefs})
        > {
  $$AiChatSessionsTableTableTableManager(
    _$AppDatabase db,
    $AiChatSessionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiChatSessionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiChatSessionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiChatSessionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiChatSessionsTableCompanion(
                id: id,
                createdAtEpochMs: createdAtEpochMs,
                title: title,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAtEpochMs,
                required String title,
                Value<int> rowid = const Value.absent(),
              }) => AiChatSessionsTableCompanion.insert(
                id: id,
                createdAtEpochMs: createdAtEpochMs,
                title: title,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AiChatSessionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({aiChatMessagesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (aiChatMessagesTableRefs) db.aiChatMessagesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (aiChatMessagesTableRefs)
                    await $_getPrefetchedData<
                      AiChatSessionsTableData,
                      $AiChatSessionsTableTable,
                      AiChatMessagesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$AiChatSessionsTableTableReferences
                          ._aiChatMessagesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$AiChatSessionsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).aiChatMessagesTableRefs,
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

typedef $$AiChatSessionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiChatSessionsTableTable,
      AiChatSessionsTableData,
      $$AiChatSessionsTableTableFilterComposer,
      $$AiChatSessionsTableTableOrderingComposer,
      $$AiChatSessionsTableTableAnnotationComposer,
      $$AiChatSessionsTableTableCreateCompanionBuilder,
      $$AiChatSessionsTableTableUpdateCompanionBuilder,
      (AiChatSessionsTableData, $$AiChatSessionsTableTableReferences),
      AiChatSessionsTableData,
      PrefetchHooks Function({bool aiChatMessagesTableRefs})
    >;
typedef $$AiChatMessagesTableTableCreateCompanionBuilder =
    AiChatMessagesTableCompanion Function({
      required String id,
      required String sessionId,
      required String role,
      required String content,
      required int createdAtEpochMs,
      Value<int> rowid,
    });
typedef $$AiChatMessagesTableTableUpdateCompanionBuilder =
    AiChatMessagesTableCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> role,
      Value<String> content,
      Value<int> createdAtEpochMs,
      Value<int> rowid,
    });

final class $$AiChatMessagesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AiChatMessagesTableTable,
          AiChatMessagesTableData
        > {
  $$AiChatMessagesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AiChatSessionsTableTable _sessionIdTable(_$AppDatabase db) =>
      db.aiChatSessionsTable.createAlias(
        $_aliasNameGenerator(
          db.aiChatMessagesTable.sessionId,
          db.aiChatSessionsTable.id,
        ),
      );

  $$AiChatSessionsTableTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$AiChatSessionsTableTableTableManager(
      $_db,
      $_db.aiChatSessionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AiChatMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AiChatMessagesTableTable> {
  $$AiChatMessagesTableTableFilterComposer({
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

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  $$AiChatSessionsTableTableFilterComposer get sessionId {
    final $$AiChatSessionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.aiChatSessionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AiChatSessionsTableTableFilterComposer(
            $db: $db,
            $table: $db.aiChatSessionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AiChatMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AiChatMessagesTableTable> {
  $$AiChatMessagesTableTableOrderingComposer({
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$AiChatSessionsTableTableOrderingComposer get sessionId {
    final $$AiChatSessionsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.aiChatSessionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AiChatSessionsTableTableOrderingComposer(
                $db: $db,
                $table: $db.aiChatSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AiChatMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiChatMessagesTableTable> {
  $$AiChatMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpochMs => $composableBuilder(
    column: $table.createdAtEpochMs,
    builder: (column) => column,
  );

  $$AiChatSessionsTableTableAnnotationComposer get sessionId {
    final $$AiChatSessionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.sessionId,
          referencedTable: $db.aiChatSessionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AiChatSessionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.aiChatSessionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$AiChatMessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiChatMessagesTableTable,
          AiChatMessagesTableData,
          $$AiChatMessagesTableTableFilterComposer,
          $$AiChatMessagesTableTableOrderingComposer,
          $$AiChatMessagesTableTableAnnotationComposer,
          $$AiChatMessagesTableTableCreateCompanionBuilder,
          $$AiChatMessagesTableTableUpdateCompanionBuilder,
          (AiChatMessagesTableData, $$AiChatMessagesTableTableReferences),
          AiChatMessagesTableData,
          PrefetchHooks Function({bool sessionId})
        > {
  $$AiChatMessagesTableTableTableManager(
    _$AppDatabase db,
    $AiChatMessagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiChatMessagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiChatMessagesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AiChatMessagesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> createdAtEpochMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AiChatMessagesTableCompanion(
                id: id,
                sessionId: sessionId,
                role: role,
                content: content,
                createdAtEpochMs: createdAtEpochMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String role,
                required String content,
                required int createdAtEpochMs,
                Value<int> rowid = const Value.absent(),
              }) => AiChatMessagesTableCompanion.insert(
                id: id,
                sessionId: sessionId,
                role: role,
                content: content,
                createdAtEpochMs: createdAtEpochMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AiChatMessagesTableTableReferences(db, table, e),
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
                                referencedTable:
                                    $$AiChatMessagesTableTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$AiChatMessagesTableTableReferences
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

typedef $$AiChatMessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiChatMessagesTableTable,
      AiChatMessagesTableData,
      $$AiChatMessagesTableTableFilterComposer,
      $$AiChatMessagesTableTableOrderingComposer,
      $$AiChatMessagesTableTableAnnotationComposer,
      $$AiChatMessagesTableTableCreateCompanionBuilder,
      $$AiChatMessagesTableTableUpdateCompanionBuilder,
      (AiChatMessagesTableData, $$AiChatMessagesTableTableReferences),
      AiChatMessagesTableData,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$AiSettingsTableTableCreateCompanionBuilder =
    AiSettingsTableCompanion Function({
      Value<int> singletonId,
      Value<String> selectedModel,
      Value<bool> notebookContextEnabled,
      Value<bool> enableAssistantActions,
    });
typedef $$AiSettingsTableTableUpdateCompanionBuilder =
    AiSettingsTableCompanion Function({
      Value<int> singletonId,
      Value<String> selectedModel,
      Value<bool> notebookContextEnabled,
      Value<bool> enableAssistantActions,
    });

class $$AiSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AiSettingsTableTable> {
  $$AiSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedModel => $composableBuilder(
    column: $table.selectedModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notebookContextEnabled => $composableBuilder(
    column: $table.notebookContextEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enableAssistantActions => $composableBuilder(
    column: $table.enableAssistantActions,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AiSettingsTableTable> {
  $$AiSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedModel => $composableBuilder(
    column: $table.selectedModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notebookContextEnabled => $composableBuilder(
    column: $table.notebookContextEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enableAssistantActions => $composableBuilder(
    column: $table.enableAssistantActions,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiSettingsTableTable> {
  $$AiSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get singletonId => $composableBuilder(
    column: $table.singletonId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedModel => $composableBuilder(
    column: $table.selectedModel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notebookContextEnabled => $composableBuilder(
    column: $table.notebookContextEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enableAssistantActions => $composableBuilder(
    column: $table.enableAssistantActions,
    builder: (column) => column,
  );
}

class $$AiSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiSettingsTableTable,
          AiSettingsTableData,
          $$AiSettingsTableTableFilterComposer,
          $$AiSettingsTableTableOrderingComposer,
          $$AiSettingsTableTableAnnotationComposer,
          $$AiSettingsTableTableCreateCompanionBuilder,
          $$AiSettingsTableTableUpdateCompanionBuilder,
          (
            AiSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AiSettingsTableTable,
              AiSettingsTableData
            >,
          ),
          AiSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AiSettingsTableTableTableManager(
    _$AppDatabase db,
    $AiSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                Value<String> selectedModel = const Value.absent(),
                Value<bool> notebookContextEnabled = const Value.absent(),
                Value<bool> enableAssistantActions = const Value.absent(),
              }) => AiSettingsTableCompanion(
                singletonId: singletonId,
                selectedModel: selectedModel,
                notebookContextEnabled: notebookContextEnabled,
                enableAssistantActions: enableAssistantActions,
              ),
          createCompanionCallback:
              ({
                Value<int> singletonId = const Value.absent(),
                Value<String> selectedModel = const Value.absent(),
                Value<bool> notebookContextEnabled = const Value.absent(),
                Value<bool> enableAssistantActions = const Value.absent(),
              }) => AiSettingsTableCompanion.insert(
                singletonId: singletonId,
                selectedModel: selectedModel,
                notebookContextEnabled: notebookContextEnabled,
                enableAssistantActions: enableAssistantActions,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiSettingsTableTable,
      AiSettingsTableData,
      $$AiSettingsTableTableFilterComposer,
      $$AiSettingsTableTableOrderingComposer,
      $$AiSettingsTableTableAnnotationComposer,
      $$AiSettingsTableTableCreateCompanionBuilder,
      $$AiSettingsTableTableUpdateCompanionBuilder,
      (
        AiSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AiSettingsTableTable,
          AiSettingsTableData
        >,
      ),
      AiSettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$NotebooksTableTableTableManager get notebooksTable =>
      $$NotebooksTableTableTableManager(_db, _db.notebooksTable);
  $$NotebookPagesTableTableTableManager get notebookPagesTable =>
      $$NotebookPagesTableTableTableManager(_db, _db.notebookPagesTable);
  $$VisionItemsTableTableTableManager get visionItemsTable =>
      $$VisionItemsTableTableTableManager(_db, _db.visionItemsTable);
  $$GoalsTableTableTableManager get goalsTable =>
      $$GoalsTableTableTableManager(_db, _db.goalsTable);
  $$TasksTableTableTableManager get tasksTable =>
      $$TasksTableTableTableManager(_db, _db.tasksTable);
  $$AiChatSessionsTableTableTableManager get aiChatSessionsTable =>
      $$AiChatSessionsTableTableTableManager(_db, _db.aiChatSessionsTable);
  $$AiChatMessagesTableTableTableManager get aiChatMessagesTable =>
      $$AiChatMessagesTableTableTableManager(_db, _db.aiChatMessagesTable);
  $$AiSettingsTableTableTableManager get aiSettingsTable =>
      $$AiSettingsTableTableTableManager(_db, _db.aiSettingsTable);
}
