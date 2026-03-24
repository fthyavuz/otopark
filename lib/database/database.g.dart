// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TariffsTable extends Tariffs with TableInfo<$TariffsTable, Tariff> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TariffsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bracketsJsonMeta = const VerificationMeta(
    'bracketsJson',
  );
  @override
  late final GeneratedColumn<String> bracketsJson = GeneratedColumn<String>(
    'brackets_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullDayPriceMeta = const VerificationMeta(
    'fullDayPrice',
  );
  @override
  late final GeneratedColumn<double> fullDayPrice = GeneratedColumn<double>(
    'full_day_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyPriceMeta = const VerificationMeta(
    'monthlyPrice',
  );
  @override
  late final GeneratedColumn<double> monthlyPrice = GeneratedColumn<double>(
    'monthly_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validToMeta = const VerificationMeta(
    'validTo',
  );
  @override
  late final GeneratedColumn<DateTime> validTo = GeneratedColumn<DateTime>(
    'valid_to',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    bracketsJson,
    fullDayPrice,
    monthlyPrice,
    validFrom,
    validTo,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tariffs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tariff> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brackets_json')) {
      context.handle(
        _bracketsJsonMeta,
        bracketsJson.isAcceptableOrUnknown(
          data['brackets_json']!,
          _bracketsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bracketsJsonMeta);
    }
    if (data.containsKey('full_day_price')) {
      context.handle(
        _fullDayPriceMeta,
        fullDayPrice.isAcceptableOrUnknown(
          data['full_day_price']!,
          _fullDayPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fullDayPriceMeta);
    }
    if (data.containsKey('monthly_price')) {
      context.handle(
        _monthlyPriceMeta,
        monthlyPrice.isAcceptableOrUnknown(
          data['monthly_price']!,
          _monthlyPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyPriceMeta);
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('valid_to')) {
      context.handle(
        _validToMeta,
        validTo.isAcceptableOrUnknown(data['valid_to']!, _validToMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tariff map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tariff(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      bracketsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brackets_json'],
      )!,
      fullDayPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}full_day_price'],
      )!,
      monthlyPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_price'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_from'],
      )!,
      validTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_to'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $TariffsTable createAlias(String alias) {
    return $TariffsTable(attachedDatabase, alias);
  }
}

class Tariff extends DataClass implements Insertable<Tariff> {
  final int id;
  final String name;

  /// JSON array of TariffBracket objects sorted by upToMinutes ascending.
  /// Last entry with upToMinutes = null means "full day" price.
  final String bracketsJson;
  final double fullDayPrice;
  final double monthlyPrice;
  final DateTime validFrom;
  final DateTime? validTo;
  final bool isActive;
  const Tariff({
    required this.id,
    required this.name,
    required this.bracketsJson,
    required this.fullDayPrice,
    required this.monthlyPrice,
    required this.validFrom,
    this.validTo,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['brackets_json'] = Variable<String>(bracketsJson);
    map['full_day_price'] = Variable<double>(fullDayPrice);
    map['monthly_price'] = Variable<double>(monthlyPrice);
    map['valid_from'] = Variable<DateTime>(validFrom);
    if (!nullToAbsent || validTo != null) {
      map['valid_to'] = Variable<DateTime>(validTo);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TariffsCompanion toCompanion(bool nullToAbsent) {
    return TariffsCompanion(
      id: Value(id),
      name: Value(name),
      bracketsJson: Value(bracketsJson),
      fullDayPrice: Value(fullDayPrice),
      monthlyPrice: Value(monthlyPrice),
      validFrom: Value(validFrom),
      validTo: validTo == null && nullToAbsent
          ? const Value.absent()
          : Value(validTo),
      isActive: Value(isActive),
    );
  }

  factory Tariff.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tariff(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      bracketsJson: serializer.fromJson<String>(json['bracketsJson']),
      fullDayPrice: serializer.fromJson<double>(json['fullDayPrice']),
      monthlyPrice: serializer.fromJson<double>(json['monthlyPrice']),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      validTo: serializer.fromJson<DateTime?>(json['validTo']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'bracketsJson': serializer.toJson<String>(bracketsJson),
      'fullDayPrice': serializer.toJson<double>(fullDayPrice),
      'monthlyPrice': serializer.toJson<double>(monthlyPrice),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'validTo': serializer.toJson<DateTime?>(validTo),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Tariff copyWith({
    int? id,
    String? name,
    String? bracketsJson,
    double? fullDayPrice,
    double? monthlyPrice,
    DateTime? validFrom,
    Value<DateTime?> validTo = const Value.absent(),
    bool? isActive,
  }) => Tariff(
    id: id ?? this.id,
    name: name ?? this.name,
    bracketsJson: bracketsJson ?? this.bracketsJson,
    fullDayPrice: fullDayPrice ?? this.fullDayPrice,
    monthlyPrice: monthlyPrice ?? this.monthlyPrice,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo.present ? validTo.value : this.validTo,
    isActive: isActive ?? this.isActive,
  );
  Tariff copyWithCompanion(TariffsCompanion data) {
    return Tariff(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      bracketsJson: data.bracketsJson.present
          ? data.bracketsJson.value
          : this.bracketsJson,
      fullDayPrice: data.fullDayPrice.present
          ? data.fullDayPrice.value
          : this.fullDayPrice,
      monthlyPrice: data.monthlyPrice.present
          ? data.monthlyPrice.value
          : this.monthlyPrice,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validTo: data.validTo.present ? data.validTo.value : this.validTo,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tariff(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bracketsJson: $bracketsJson, ')
          ..write('fullDayPrice: $fullDayPrice, ')
          ..write('monthlyPrice: $monthlyPrice, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    bracketsJson,
    fullDayPrice,
    monthlyPrice,
    validFrom,
    validTo,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tariff &&
          other.id == this.id &&
          other.name == this.name &&
          other.bracketsJson == this.bracketsJson &&
          other.fullDayPrice == this.fullDayPrice &&
          other.monthlyPrice == this.monthlyPrice &&
          other.validFrom == this.validFrom &&
          other.validTo == this.validTo &&
          other.isActive == this.isActive);
}

class TariffsCompanion extends UpdateCompanion<Tariff> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> bracketsJson;
  final Value<double> fullDayPrice;
  final Value<double> monthlyPrice;
  final Value<DateTime> validFrom;
  final Value<DateTime?> validTo;
  final Value<bool> isActive;
  const TariffsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bracketsJson = const Value.absent(),
    this.fullDayPrice = const Value.absent(),
    this.monthlyPrice = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  TariffsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String bracketsJson,
    required double fullDayPrice,
    required double monthlyPrice,
    required DateTime validFrom,
    this.validTo = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       bracketsJson = Value(bracketsJson),
       fullDayPrice = Value(fullDayPrice),
       monthlyPrice = Value(monthlyPrice),
       validFrom = Value(validFrom);
  static Insertable<Tariff> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? bracketsJson,
    Expression<double>? fullDayPrice,
    Expression<double>? monthlyPrice,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validTo,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (bracketsJson != null) 'brackets_json': bracketsJson,
      if (fullDayPrice != null) 'full_day_price': fullDayPrice,
      if (monthlyPrice != null) 'monthly_price': monthlyPrice,
      if (validFrom != null) 'valid_from': validFrom,
      if (validTo != null) 'valid_to': validTo,
      if (isActive != null) 'is_active': isActive,
    });
  }

  TariffsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? bracketsJson,
    Value<double>? fullDayPrice,
    Value<double>? monthlyPrice,
    Value<DateTime>? validFrom,
    Value<DateTime?>? validTo,
    Value<bool>? isActive,
  }) {
    return TariffsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      bracketsJson: bracketsJson ?? this.bracketsJson,
      fullDayPrice: fullDayPrice ?? this.fullDayPrice,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (bracketsJson.present) {
      map['brackets_json'] = Variable<String>(bracketsJson.value);
    }
    if (fullDayPrice.present) {
      map['full_day_price'] = Variable<double>(fullDayPrice.value);
    }
    if (monthlyPrice.present) {
      map['monthly_price'] = Variable<double>(monthlyPrice.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validTo.present) {
      map['valid_to'] = Variable<DateTime>(validTo.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TariffsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('bracketsJson: $bracketsJson, ')
          ..write('fullDayPrice: $fullDayPrice, ')
          ..write('monthlyPrice: $monthlyPrice, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ParkingRecordsTable extends ParkingRecords
    with TableInfo<$ParkingRecordsTable, ParkingRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParkingRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryTimeMeta = const VerificationMeta(
    'entryTime',
  );
  @override
  late final GeneratedColumn<DateTime> entryTime = GeneratedColumn<DateTime>(
    'entry_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exitTimeMeta = const VerificationMeta(
    'exitTime',
  );
  @override
  late final GeneratedColumn<DateTime> exitTime = GeneratedColumn<DateTime>(
    'exit_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tariffIdMeta = const VerificationMeta(
    'tariffId',
  );
  @override
  late final GeneratedColumn<int> tariffId = GeneratedColumn<int>(
    'tariff_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tariffs (id)',
    ),
  );
  static const VerificationMeta _tariffNameSnapshotMeta =
      const VerificationMeta('tariffNameSnapshot');
  @override
  late final GeneratedColumn<String> tariffNameSnapshot =
      GeneratedColumn<String>(
        'tariff_name_snapshot',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calculatedCostMeta = const VerificationMeta(
    'calculatedCost',
  );
  @override
  late final GeneratedColumn<double> calculatedCost = GeneratedColumn<double>(
    'calculated_cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSubscriberMeta = const VerificationMeta(
    'isSubscriber',
  );
  @override
  late final GeneratedColumn<bool> isSubscriber = GeneratedColumn<bool>(
    'is_subscriber',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_subscriber" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inside'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plate,
    entryTime,
    exitTime,
    tariffId,
    tariffNameSnapshot,
    calculatedCost,
    isSubscriber,
    status,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parking_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParkingRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    } else if (isInserting) {
      context.missing(_plateMeta);
    }
    if (data.containsKey('entry_time')) {
      context.handle(
        _entryTimeMeta,
        entryTime.isAcceptableOrUnknown(data['entry_time']!, _entryTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_entryTimeMeta);
    }
    if (data.containsKey('exit_time')) {
      context.handle(
        _exitTimeMeta,
        exitTime.isAcceptableOrUnknown(data['exit_time']!, _exitTimeMeta),
      );
    }
    if (data.containsKey('tariff_id')) {
      context.handle(
        _tariffIdMeta,
        tariffId.isAcceptableOrUnknown(data['tariff_id']!, _tariffIdMeta),
      );
    }
    if (data.containsKey('tariff_name_snapshot')) {
      context.handle(
        _tariffNameSnapshotMeta,
        tariffNameSnapshot.isAcceptableOrUnknown(
          data['tariff_name_snapshot']!,
          _tariffNameSnapshotMeta,
        ),
      );
    }
    if (data.containsKey('calculated_cost')) {
      context.handle(
        _calculatedCostMeta,
        calculatedCost.isAcceptableOrUnknown(
          data['calculated_cost']!,
          _calculatedCostMeta,
        ),
      );
    }
    if (data.containsKey('is_subscriber')) {
      context.handle(
        _isSubscriberMeta,
        isSubscriber.isAcceptableOrUnknown(
          data['is_subscriber']!,
          _isSubscriberMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParkingRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParkingRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
      entryTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_time'],
      )!,
      exitTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exit_time'],
      ),
      tariffId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tariff_id'],
      ),
      tariffNameSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tariff_name_snapshot'],
      ),
      calculatedCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calculated_cost'],
      ),
      isSubscriber: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_subscriber'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ParkingRecordsTable createAlias(String alias) {
    return $ParkingRecordsTable(attachedDatabase, alias);
  }
}

class ParkingRecord extends DataClass implements Insertable<ParkingRecord> {
  final int id;
  final String plate;
  final DateTime entryTime;
  final DateTime? exitTime;

  /// The tariff that was active at entry time — used for accurate billing.
  final int? tariffId;

  /// Snapshot of the tariff name at time of exit — for historical records.
  final String? tariffNameSnapshot;
  final double? calculatedCost;
  final bool isSubscriber;

  /// 'inside' or 'exited'
  final String status;
  final String? notes;
  const ParkingRecord({
    required this.id,
    required this.plate,
    required this.entryTime,
    this.exitTime,
    this.tariffId,
    this.tariffNameSnapshot,
    this.calculatedCost,
    required this.isSubscriber,
    required this.status,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plate'] = Variable<String>(plate);
    map['entry_time'] = Variable<DateTime>(entryTime);
    if (!nullToAbsent || exitTime != null) {
      map['exit_time'] = Variable<DateTime>(exitTime);
    }
    if (!nullToAbsent || tariffId != null) {
      map['tariff_id'] = Variable<int>(tariffId);
    }
    if (!nullToAbsent || tariffNameSnapshot != null) {
      map['tariff_name_snapshot'] = Variable<String>(tariffNameSnapshot);
    }
    if (!nullToAbsent || calculatedCost != null) {
      map['calculated_cost'] = Variable<double>(calculatedCost);
    }
    map['is_subscriber'] = Variable<bool>(isSubscriber);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ParkingRecordsCompanion toCompanion(bool nullToAbsent) {
    return ParkingRecordsCompanion(
      id: Value(id),
      plate: Value(plate),
      entryTime: Value(entryTime),
      exitTime: exitTime == null && nullToAbsent
          ? const Value.absent()
          : Value(exitTime),
      tariffId: tariffId == null && nullToAbsent
          ? const Value.absent()
          : Value(tariffId),
      tariffNameSnapshot: tariffNameSnapshot == null && nullToAbsent
          ? const Value.absent()
          : Value(tariffNameSnapshot),
      calculatedCost: calculatedCost == null && nullToAbsent
          ? const Value.absent()
          : Value(calculatedCost),
      isSubscriber: Value(isSubscriber),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ParkingRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParkingRecord(
      id: serializer.fromJson<int>(json['id']),
      plate: serializer.fromJson<String>(json['plate']),
      entryTime: serializer.fromJson<DateTime>(json['entryTime']),
      exitTime: serializer.fromJson<DateTime?>(json['exitTime']),
      tariffId: serializer.fromJson<int?>(json['tariffId']),
      tariffNameSnapshot: serializer.fromJson<String?>(
        json['tariffNameSnapshot'],
      ),
      calculatedCost: serializer.fromJson<double?>(json['calculatedCost']),
      isSubscriber: serializer.fromJson<bool>(json['isSubscriber']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plate': serializer.toJson<String>(plate),
      'entryTime': serializer.toJson<DateTime>(entryTime),
      'exitTime': serializer.toJson<DateTime?>(exitTime),
      'tariffId': serializer.toJson<int?>(tariffId),
      'tariffNameSnapshot': serializer.toJson<String?>(tariffNameSnapshot),
      'calculatedCost': serializer.toJson<double?>(calculatedCost),
      'isSubscriber': serializer.toJson<bool>(isSubscriber),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ParkingRecord copyWith({
    int? id,
    String? plate,
    DateTime? entryTime,
    Value<DateTime?> exitTime = const Value.absent(),
    Value<int?> tariffId = const Value.absent(),
    Value<String?> tariffNameSnapshot = const Value.absent(),
    Value<double?> calculatedCost = const Value.absent(),
    bool? isSubscriber,
    String? status,
    Value<String?> notes = const Value.absent(),
  }) => ParkingRecord(
    id: id ?? this.id,
    plate: plate ?? this.plate,
    entryTime: entryTime ?? this.entryTime,
    exitTime: exitTime.present ? exitTime.value : this.exitTime,
    tariffId: tariffId.present ? tariffId.value : this.tariffId,
    tariffNameSnapshot: tariffNameSnapshot.present
        ? tariffNameSnapshot.value
        : this.tariffNameSnapshot,
    calculatedCost: calculatedCost.present
        ? calculatedCost.value
        : this.calculatedCost,
    isSubscriber: isSubscriber ?? this.isSubscriber,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
  );
  ParkingRecord copyWithCompanion(ParkingRecordsCompanion data) {
    return ParkingRecord(
      id: data.id.present ? data.id.value : this.id,
      plate: data.plate.present ? data.plate.value : this.plate,
      entryTime: data.entryTime.present ? data.entryTime.value : this.entryTime,
      exitTime: data.exitTime.present ? data.exitTime.value : this.exitTime,
      tariffId: data.tariffId.present ? data.tariffId.value : this.tariffId,
      tariffNameSnapshot: data.tariffNameSnapshot.present
          ? data.tariffNameSnapshot.value
          : this.tariffNameSnapshot,
      calculatedCost: data.calculatedCost.present
          ? data.calculatedCost.value
          : this.calculatedCost,
      isSubscriber: data.isSubscriber.present
          ? data.isSubscriber.value
          : this.isSubscriber,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParkingRecord(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('entryTime: $entryTime, ')
          ..write('exitTime: $exitTime, ')
          ..write('tariffId: $tariffId, ')
          ..write('tariffNameSnapshot: $tariffNameSnapshot, ')
          ..write('calculatedCost: $calculatedCost, ')
          ..write('isSubscriber: $isSubscriber, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plate,
    entryTime,
    exitTime,
    tariffId,
    tariffNameSnapshot,
    calculatedCost,
    isSubscriber,
    status,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParkingRecord &&
          other.id == this.id &&
          other.plate == this.plate &&
          other.entryTime == this.entryTime &&
          other.exitTime == this.exitTime &&
          other.tariffId == this.tariffId &&
          other.tariffNameSnapshot == this.tariffNameSnapshot &&
          other.calculatedCost == this.calculatedCost &&
          other.isSubscriber == this.isSubscriber &&
          other.status == this.status &&
          other.notes == this.notes);
}

class ParkingRecordsCompanion extends UpdateCompanion<ParkingRecord> {
  final Value<int> id;
  final Value<String> plate;
  final Value<DateTime> entryTime;
  final Value<DateTime?> exitTime;
  final Value<int?> tariffId;
  final Value<String?> tariffNameSnapshot;
  final Value<double?> calculatedCost;
  final Value<bool> isSubscriber;
  final Value<String> status;
  final Value<String?> notes;
  const ParkingRecordsCompanion({
    this.id = const Value.absent(),
    this.plate = const Value.absent(),
    this.entryTime = const Value.absent(),
    this.exitTime = const Value.absent(),
    this.tariffId = const Value.absent(),
    this.tariffNameSnapshot = const Value.absent(),
    this.calculatedCost = const Value.absent(),
    this.isSubscriber = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ParkingRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String plate,
    required DateTime entryTime,
    this.exitTime = const Value.absent(),
    this.tariffId = const Value.absent(),
    this.tariffNameSnapshot = const Value.absent(),
    this.calculatedCost = const Value.absent(),
    this.isSubscriber = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
  }) : plate = Value(plate),
       entryTime = Value(entryTime);
  static Insertable<ParkingRecord> custom({
    Expression<int>? id,
    Expression<String>? plate,
    Expression<DateTime>? entryTime,
    Expression<DateTime>? exitTime,
    Expression<int>? tariffId,
    Expression<String>? tariffNameSnapshot,
    Expression<double>? calculatedCost,
    Expression<bool>? isSubscriber,
    Expression<String>? status,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plate != null) 'plate': plate,
      if (entryTime != null) 'entry_time': entryTime,
      if (exitTime != null) 'exit_time': exitTime,
      if (tariffId != null) 'tariff_id': tariffId,
      if (tariffNameSnapshot != null)
        'tariff_name_snapshot': tariffNameSnapshot,
      if (calculatedCost != null) 'calculated_cost': calculatedCost,
      if (isSubscriber != null) 'is_subscriber': isSubscriber,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
    });
  }

  ParkingRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? plate,
    Value<DateTime>? entryTime,
    Value<DateTime?>? exitTime,
    Value<int?>? tariffId,
    Value<String?>? tariffNameSnapshot,
    Value<double?>? calculatedCost,
    Value<bool>? isSubscriber,
    Value<String>? status,
    Value<String?>? notes,
  }) {
    return ParkingRecordsCompanion(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      entryTime: entryTime ?? this.entryTime,
      exitTime: exitTime ?? this.exitTime,
      tariffId: tariffId ?? this.tariffId,
      tariffNameSnapshot: tariffNameSnapshot ?? this.tariffNameSnapshot,
      calculatedCost: calculatedCost ?? this.calculatedCost,
      isSubscriber: isSubscriber ?? this.isSubscriber,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    if (entryTime.present) {
      map['entry_time'] = Variable<DateTime>(entryTime.value);
    }
    if (exitTime.present) {
      map['exit_time'] = Variable<DateTime>(exitTime.value);
    }
    if (tariffId.present) {
      map['tariff_id'] = Variable<int>(tariffId.value);
    }
    if (tariffNameSnapshot.present) {
      map['tariff_name_snapshot'] = Variable<String>(tariffNameSnapshot.value);
    }
    if (calculatedCost.present) {
      map['calculated_cost'] = Variable<double>(calculatedCost.value);
    }
    if (isSubscriber.present) {
      map['is_subscriber'] = Variable<bool>(isSubscriber.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParkingRecordsCompanion(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('entryTime: $entryTime, ')
          ..write('exitTime: $exitTime, ')
          ..write('tariffId: $tariffId, ')
          ..write('tariffNameSnapshot: $tariffNameSnapshot, ')
          ..write('calculatedCost: $calculatedCost, ')
          ..write('isSubscriber: $isSubscriber, ')
          ..write('status: $status, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $SubscribersTable extends Subscribers
    with TableInfo<$SubscribersTable, Subscriber> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscribersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyFeeMeta = const VerificationMeta(
    'monthlyFee',
  );
  @override
  late final GeneratedColumn<double> monthlyFee = GeneratedColumn<double>(
    'monthly_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notes,
    startDate,
    endDate,
    monthlyFee,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscribers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subscriber> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('monthly_fee')) {
      context.handle(
        _monthlyFeeMeta,
        monthlyFee.isAcceptableOrUnknown(data['monthly_fee']!, _monthlyFeeMeta),
      );
    } else if (isInserting) {
      context.missing(_monthlyFeeMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subscriber map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subscriber(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      monthlyFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_fee'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SubscribersTable createAlias(String alias) {
    return $SubscribersTable(attachedDatabase, alias);
  }
}

class Subscriber extends DataClass implements Insertable<Subscriber> {
  final int id;
  final String? notes;
  final DateTime startDate;
  final DateTime endDate;
  final double monthlyFee;
  final bool isActive;
  const Subscriber({
    required this.id,
    this.notes,
    required this.startDate,
    required this.endDate,
    required this.monthlyFee,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['monthly_fee'] = Variable<double>(monthlyFee);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SubscribersCompanion toCompanion(bool nullToAbsent) {
    return SubscribersCompanion(
      id: Value(id),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      startDate: Value(startDate),
      endDate: Value(endDate),
      monthlyFee: Value(monthlyFee),
      isActive: Value(isActive),
    );
  }

  factory Subscriber.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subscriber(
      id: serializer.fromJson<int>(json['id']),
      notes: serializer.fromJson<String?>(json['notes']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      monthlyFee: serializer.fromJson<double>(json['monthlyFee']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'notes': serializer.toJson<String?>(notes),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'monthlyFee': serializer.toJson<double>(monthlyFee),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Subscriber copyWith({
    int? id,
    Value<String?> notes = const Value.absent(),
    DateTime? startDate,
    DateTime? endDate,
    double? monthlyFee,
    bool? isActive,
  }) => Subscriber(
    id: id ?? this.id,
    notes: notes.present ? notes.value : this.notes,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    monthlyFee: monthlyFee ?? this.monthlyFee,
    isActive: isActive ?? this.isActive,
  );
  Subscriber copyWithCompanion(SubscribersCompanion data) {
    return Subscriber(
      id: data.id.present ? data.id.value : this.id,
      notes: data.notes.present ? data.notes.value : this.notes,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      monthlyFee: data.monthlyFee.present
          ? data.monthlyFee.value
          : this.monthlyFee,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subscriber(')
          ..write('id: $id, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('monthlyFee: $monthlyFee, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, notes, startDate, endDate, monthlyFee, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscriber &&
          other.id == this.id &&
          other.notes == this.notes &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.monthlyFee == this.monthlyFee &&
          other.isActive == this.isActive);
}

class SubscribersCompanion extends UpdateCompanion<Subscriber> {
  final Value<int> id;
  final Value<String?> notes;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> monthlyFee;
  final Value<bool> isActive;
  const SubscribersCompanion({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.monthlyFee = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  SubscribersCompanion.insert({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required double monthlyFee,
    this.isActive = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       monthlyFee = Value(monthlyFee);
  static Insertable<Subscriber> custom({
    Expression<int>? id,
    Expression<String>? notes,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? monthlyFee,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notes != null) 'notes': notes,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (monthlyFee != null) 'monthly_fee': monthlyFee,
      if (isActive != null) 'is_active': isActive,
    });
  }

  SubscribersCompanion copyWith({
    Value<int>? id,
    Value<String?>? notes,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<double>? monthlyFee,
    Value<bool>? isActive,
  }) {
    return SubscribersCompanion(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (monthlyFee.present) {
      map['monthly_fee'] = Variable<double>(monthlyFee.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscribersCompanion(')
          ..write('id: $id, ')
          ..write('notes: $notes, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('monthlyFee: $monthlyFee, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SubscriberPlatesTable extends SubscriberPlates
    with TableInfo<$SubscriberPlatesTable, SubscriberPlate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriberPlatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subscriberIdMeta = const VerificationMeta(
    'subscriberId',
  );
  @override
  late final GeneratedColumn<int> subscriberId = GeneratedColumn<int>(
    'subscriber_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subscribers (id)',
    ),
  );
  static const VerificationMeta _plateMeta = const VerificationMeta('plate');
  @override
  late final GeneratedColumn<String> plate = GeneratedColumn<String>(
    'plate',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, subscriberId, plate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriber_plates';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubscriberPlate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subscriber_id')) {
      context.handle(
        _subscriberIdMeta,
        subscriberId.isAcceptableOrUnknown(
          data['subscriber_id']!,
          _subscriberIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subscriberIdMeta);
    }
    if (data.containsKey('plate')) {
      context.handle(
        _plateMeta,
        plate.isAcceptableOrUnknown(data['plate']!, _plateMeta),
      );
    } else if (isInserting) {
      context.missing(_plateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriberPlate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriberPlate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subscriberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subscriber_id'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
    );
  }

  @override
  $SubscriberPlatesTable createAlias(String alias) {
    return $SubscriberPlatesTable(attachedDatabase, alias);
  }
}

class SubscriberPlate extends DataClass implements Insertable<SubscriberPlate> {
  final int id;
  final int subscriberId;
  final String plate;
  const SubscriberPlate({
    required this.id,
    required this.subscriberId,
    required this.plate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subscriber_id'] = Variable<int>(subscriberId);
    map['plate'] = Variable<String>(plate);
    return map;
  }

  SubscriberPlatesCompanion toCompanion(bool nullToAbsent) {
    return SubscriberPlatesCompanion(
      id: Value(id),
      subscriberId: Value(subscriberId),
      plate: Value(plate),
    );
  }

  factory SubscriberPlate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriberPlate(
      id: serializer.fromJson<int>(json['id']),
      subscriberId: serializer.fromJson<int>(json['subscriberId']),
      plate: serializer.fromJson<String>(json['plate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subscriberId': serializer.toJson<int>(subscriberId),
      'plate': serializer.toJson<String>(plate),
    };
  }

  SubscriberPlate copyWith({int? id, int? subscriberId, String? plate}) =>
      SubscriberPlate(
        id: id ?? this.id,
        subscriberId: subscriberId ?? this.subscriberId,
        plate: plate ?? this.plate,
      );
  SubscriberPlate copyWithCompanion(SubscriberPlatesCompanion data) {
    return SubscriberPlate(
      id: data.id.present ? data.id.value : this.id,
      subscriberId: data.subscriberId.present
          ? data.subscriberId.value
          : this.subscriberId,
      plate: data.plate.present ? data.plate.value : this.plate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriberPlate(')
          ..write('id: $id, ')
          ..write('subscriberId: $subscriberId, ')
          ..write('plate: $plate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, subscriberId, plate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriberPlate &&
          other.id == this.id &&
          other.subscriberId == this.subscriberId &&
          other.plate == this.plate);
}

class SubscriberPlatesCompanion extends UpdateCompanion<SubscriberPlate> {
  final Value<int> id;
  final Value<int> subscriberId;
  final Value<String> plate;
  const SubscriberPlatesCompanion({
    this.id = const Value.absent(),
    this.subscriberId = const Value.absent(),
    this.plate = const Value.absent(),
  });
  SubscriberPlatesCompanion.insert({
    this.id = const Value.absent(),
    required int subscriberId,
    required String plate,
  }) : subscriberId = Value(subscriberId),
       plate = Value(plate);
  static Insertable<SubscriberPlate> custom({
    Expression<int>? id,
    Expression<int>? subscriberId,
    Expression<String>? plate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subscriberId != null) 'subscriber_id': subscriberId,
      if (plate != null) 'plate': plate,
    });
  }

  SubscriberPlatesCompanion copyWith({
    Value<int>? id,
    Value<int>? subscriberId,
    Value<String>? plate,
  }) {
    return SubscriberPlatesCompanion(
      id: id ?? this.id,
      subscriberId: subscriberId ?? this.subscriberId,
      plate: plate ?? this.plate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subscriberId.present) {
      map['subscriber_id'] = Variable<int>(subscriberId.value);
    }
    if (plate.present) {
      map['plate'] = Variable<String>(plate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriberPlatesCompanion(')
          ..write('id: $id, ')
          ..write('subscriberId: $subscriberId, ')
          ..write('plate: $plate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TariffsTable tariffs = $TariffsTable(this);
  late final $ParkingRecordsTable parkingRecords = $ParkingRecordsTable(this);
  late final $SubscribersTable subscribers = $SubscribersTable(this);
  late final $SubscriberPlatesTable subscriberPlates = $SubscriberPlatesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tariffs,
    parkingRecords,
    subscribers,
    subscriberPlates,
  ];
}

typedef $$TariffsTableCreateCompanionBuilder =
    TariffsCompanion Function({
      Value<int> id,
      required String name,
      required String bracketsJson,
      required double fullDayPrice,
      required double monthlyPrice,
      required DateTime validFrom,
      Value<DateTime?> validTo,
      Value<bool> isActive,
    });
typedef $$TariffsTableUpdateCompanionBuilder =
    TariffsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> bracketsJson,
      Value<double> fullDayPrice,
      Value<double> monthlyPrice,
      Value<DateTime> validFrom,
      Value<DateTime?> validTo,
      Value<bool> isActive,
    });

final class $$TariffsTableReferences
    extends BaseReferences<_$AppDatabase, $TariffsTable, Tariff> {
  $$TariffsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ParkingRecordsTable, List<ParkingRecord>>
  _parkingRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.parkingRecords,
    aliasName: $_aliasNameGenerator(db.tariffs.id, db.parkingRecords.tariffId),
  );

  $$ParkingRecordsTableProcessedTableManager get parkingRecordsRefs {
    final manager = $$ParkingRecordsTableTableManager(
      $_db,
      $_db.parkingRecords,
    ).filter((f) => f.tariffId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_parkingRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TariffsTableFilterComposer
    extends Composer<_$AppDatabase, $TariffsTable> {
  $$TariffsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bracketsJson => $composableBuilder(
    column: $table.bracketsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fullDayPrice => $composableBuilder(
    column: $table.fullDayPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> parkingRecordsRefs(
    Expression<bool> Function($$ParkingRecordsTableFilterComposer f) f,
  ) {
    final $$ParkingRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parkingRecords,
      getReferencedColumn: (t) => t.tariffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParkingRecordsTableFilterComposer(
            $db: $db,
            $table: $db.parkingRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TariffsTableOrderingComposer
    extends Composer<_$AppDatabase, $TariffsTable> {
  $$TariffsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bracketsJson => $composableBuilder(
    column: $table.bracketsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fullDayPrice => $composableBuilder(
    column: $table.fullDayPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TariffsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TariffsTable> {
  $$TariffsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get bracketsJson => $composableBuilder(
    column: $table.bracketsJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fullDayPrice => $composableBuilder(
    column: $table.fullDayPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validTo =>
      $composableBuilder(column: $table.validTo, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> parkingRecordsRefs<T extends Object>(
    Expression<T> Function($$ParkingRecordsTableAnnotationComposer a) f,
  ) {
    final $$ParkingRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parkingRecords,
      getReferencedColumn: (t) => t.tariffId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParkingRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.parkingRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TariffsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TariffsTable,
          Tariff,
          $$TariffsTableFilterComposer,
          $$TariffsTableOrderingComposer,
          $$TariffsTableAnnotationComposer,
          $$TariffsTableCreateCompanionBuilder,
          $$TariffsTableUpdateCompanionBuilder,
          (Tariff, $$TariffsTableReferences),
          Tariff,
          PrefetchHooks Function({bool parkingRecordsRefs})
        > {
  $$TariffsTableTableManager(_$AppDatabase db, $TariffsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TariffsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TariffsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TariffsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> bracketsJson = const Value.absent(),
                Value<double> fullDayPrice = const Value.absent(),
                Value<double> monthlyPrice = const Value.absent(),
                Value<DateTime> validFrom = const Value.absent(),
                Value<DateTime?> validTo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TariffsCompanion(
                id: id,
                name: name,
                bracketsJson: bracketsJson,
                fullDayPrice: fullDayPrice,
                monthlyPrice: monthlyPrice,
                validFrom: validFrom,
                validTo: validTo,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String bracketsJson,
                required double fullDayPrice,
                required double monthlyPrice,
                required DateTime validFrom,
                Value<DateTime?> validTo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TariffsCompanion.insert(
                id: id,
                name: name,
                bracketsJson: bracketsJson,
                fullDayPrice: fullDayPrice,
                monthlyPrice: monthlyPrice,
                validFrom: validFrom,
                validTo: validTo,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TariffsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({parkingRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (parkingRecordsRefs) db.parkingRecords,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (parkingRecordsRefs)
                    await $_getPrefetchedData<
                      Tariff,
                      $TariffsTable,
                      ParkingRecord
                    >(
                      currentTable: table,
                      referencedTable: $$TariffsTableReferences
                          ._parkingRecordsRefsTable(db),
                      managerFromTypedResult: (p0) => $$TariffsTableReferences(
                        db,
                        table,
                        p0,
                      ).parkingRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tariffId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TariffsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TariffsTable,
      Tariff,
      $$TariffsTableFilterComposer,
      $$TariffsTableOrderingComposer,
      $$TariffsTableAnnotationComposer,
      $$TariffsTableCreateCompanionBuilder,
      $$TariffsTableUpdateCompanionBuilder,
      (Tariff, $$TariffsTableReferences),
      Tariff,
      PrefetchHooks Function({bool parkingRecordsRefs})
    >;
typedef $$ParkingRecordsTableCreateCompanionBuilder =
    ParkingRecordsCompanion Function({
      Value<int> id,
      required String plate,
      required DateTime entryTime,
      Value<DateTime?> exitTime,
      Value<int?> tariffId,
      Value<String?> tariffNameSnapshot,
      Value<double?> calculatedCost,
      Value<bool> isSubscriber,
      Value<String> status,
      Value<String?> notes,
    });
typedef $$ParkingRecordsTableUpdateCompanionBuilder =
    ParkingRecordsCompanion Function({
      Value<int> id,
      Value<String> plate,
      Value<DateTime> entryTime,
      Value<DateTime?> exitTime,
      Value<int?> tariffId,
      Value<String?> tariffNameSnapshot,
      Value<double?> calculatedCost,
      Value<bool> isSubscriber,
      Value<String> status,
      Value<String?> notes,
    });

final class $$ParkingRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $ParkingRecordsTable, ParkingRecord> {
  $$ParkingRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TariffsTable _tariffIdTable(_$AppDatabase db) =>
      db.tariffs.createAlias(
        $_aliasNameGenerator(db.parkingRecords.tariffId, db.tariffs.id),
      );

  $$TariffsTableProcessedTableManager? get tariffId {
    final $_column = $_itemColumn<int>('tariff_id');
    if ($_column == null) return null;
    final manager = $$TariffsTableTableManager(
      $_db,
      $_db.tariffs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tariffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ParkingRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ParkingRecordsTable> {
  $$ParkingRecordsTableFilterComposer({
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

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get exitTime => $composableBuilder(
    column: $table.exitTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tariffNameSnapshot => $composableBuilder(
    column: $table.tariffNameSnapshot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calculatedCost => $composableBuilder(
    column: $table.calculatedCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSubscriber => $composableBuilder(
    column: $table.isSubscriber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$TariffsTableFilterComposer get tariffId {
    final $$TariffsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tariffId,
      referencedTable: $db.tariffs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TariffsTableFilterComposer(
            $db: $db,
            $table: $db.tariffs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParkingRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParkingRecordsTable> {
  $$ParkingRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get entryTime => $composableBuilder(
    column: $table.entryTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get exitTime => $composableBuilder(
    column: $table.exitTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tariffNameSnapshot => $composableBuilder(
    column: $table.tariffNameSnapshot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calculatedCost => $composableBuilder(
    column: $table.calculatedCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSubscriber => $composableBuilder(
    column: $table.isSubscriber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$TariffsTableOrderingComposer get tariffId {
    final $$TariffsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tariffId,
      referencedTable: $db.tariffs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TariffsTableOrderingComposer(
            $db: $db,
            $table: $db.tariffs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParkingRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParkingRecordsTable> {
  $$ParkingRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  GeneratedColumn<DateTime> get entryTime =>
      $composableBuilder(column: $table.entryTime, builder: (column) => column);

  GeneratedColumn<DateTime> get exitTime =>
      $composableBuilder(column: $table.exitTime, builder: (column) => column);

  GeneratedColumn<String> get tariffNameSnapshot => $composableBuilder(
    column: $table.tariffNameSnapshot,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calculatedCost => $composableBuilder(
    column: $table.calculatedCost,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSubscriber => $composableBuilder(
    column: $table.isSubscriber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$TariffsTableAnnotationComposer get tariffId {
    final $$TariffsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tariffId,
      referencedTable: $db.tariffs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TariffsTableAnnotationComposer(
            $db: $db,
            $table: $db.tariffs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParkingRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParkingRecordsTable,
          ParkingRecord,
          $$ParkingRecordsTableFilterComposer,
          $$ParkingRecordsTableOrderingComposer,
          $$ParkingRecordsTableAnnotationComposer,
          $$ParkingRecordsTableCreateCompanionBuilder,
          $$ParkingRecordsTableUpdateCompanionBuilder,
          (ParkingRecord, $$ParkingRecordsTableReferences),
          ParkingRecord,
          PrefetchHooks Function({bool tariffId})
        > {
  $$ParkingRecordsTableTableManager(
    _$AppDatabase db,
    $ParkingRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParkingRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParkingRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParkingRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<DateTime> entryTime = const Value.absent(),
                Value<DateTime?> exitTime = const Value.absent(),
                Value<int?> tariffId = const Value.absent(),
                Value<String?> tariffNameSnapshot = const Value.absent(),
                Value<double?> calculatedCost = const Value.absent(),
                Value<bool> isSubscriber = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ParkingRecordsCompanion(
                id: id,
                plate: plate,
                entryTime: entryTime,
                exitTime: exitTime,
                tariffId: tariffId,
                tariffNameSnapshot: tariffNameSnapshot,
                calculatedCost: calculatedCost,
                isSubscriber: isSubscriber,
                status: status,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String plate,
                required DateTime entryTime,
                Value<DateTime?> exitTime = const Value.absent(),
                Value<int?> tariffId = const Value.absent(),
                Value<String?> tariffNameSnapshot = const Value.absent(),
                Value<double?> calculatedCost = const Value.absent(),
                Value<bool> isSubscriber = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ParkingRecordsCompanion.insert(
                id: id,
                plate: plate,
                entryTime: entryTime,
                exitTime: exitTime,
                tariffId: tariffId,
                tariffNameSnapshot: tariffNameSnapshot,
                calculatedCost: calculatedCost,
                isSubscriber: isSubscriber,
                status: status,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ParkingRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tariffId = false}) {
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
                    if (tariffId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tariffId,
                                referencedTable: $$ParkingRecordsTableReferences
                                    ._tariffIdTable(db),
                                referencedColumn:
                                    $$ParkingRecordsTableReferences
                                        ._tariffIdTable(db)
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

typedef $$ParkingRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParkingRecordsTable,
      ParkingRecord,
      $$ParkingRecordsTableFilterComposer,
      $$ParkingRecordsTableOrderingComposer,
      $$ParkingRecordsTableAnnotationComposer,
      $$ParkingRecordsTableCreateCompanionBuilder,
      $$ParkingRecordsTableUpdateCompanionBuilder,
      (ParkingRecord, $$ParkingRecordsTableReferences),
      ParkingRecord,
      PrefetchHooks Function({bool tariffId})
    >;
typedef $$SubscribersTableCreateCompanionBuilder =
    SubscribersCompanion Function({
      Value<int> id,
      Value<String?> notes,
      required DateTime startDate,
      required DateTime endDate,
      required double monthlyFee,
      Value<bool> isActive,
    });
typedef $$SubscribersTableUpdateCompanionBuilder =
    SubscribersCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<double> monthlyFee,
      Value<bool> isActive,
    });

final class $$SubscribersTableReferences
    extends BaseReferences<_$AppDatabase, $SubscribersTable, Subscriber> {
  $$SubscribersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubscriberPlatesTable, List<SubscriberPlate>>
  _subscriberPlatesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subscriberPlates,
    aliasName: $_aliasNameGenerator(
      db.subscribers.id,
      db.subscriberPlates.subscriberId,
    ),
  );

  $$SubscriberPlatesTableProcessedTableManager get subscriberPlatesRefs {
    final manager = $$SubscriberPlatesTableTableManager(
      $_db,
      $_db.subscriberPlates,
    ).filter((f) => f.subscriberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _subscriberPlatesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubscribersTableFilterComposer
    extends Composer<_$AppDatabase, $SubscribersTable> {
  $$SubscribersTableFilterComposer({
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

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyFee => $composableBuilder(
    column: $table.monthlyFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subscriberPlatesRefs(
    Expression<bool> Function($$SubscriberPlatesTableFilterComposer f) f,
  ) {
    final $$SubscriberPlatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriberPlates,
      getReferencedColumn: (t) => t.subscriberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriberPlatesTableFilterComposer(
            $db: $db,
            $table: $db.subscriberPlates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubscribersTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscribersTable> {
  $$SubscribersTableOrderingComposer({
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

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyFee => $composableBuilder(
    column: $table.monthlyFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubscribersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscribersTable> {
  $$SubscribersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get monthlyFee => $composableBuilder(
    column: $table.monthlyFee,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> subscriberPlatesRefs<T extends Object>(
    Expression<T> Function($$SubscriberPlatesTableAnnotationComposer a) f,
  ) {
    final $$SubscriberPlatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subscriberPlates,
      getReferencedColumn: (t) => t.subscriberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscriberPlatesTableAnnotationComposer(
            $db: $db,
            $table: $db.subscriberPlates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubscribersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscribersTable,
          Subscriber,
          $$SubscribersTableFilterComposer,
          $$SubscribersTableOrderingComposer,
          $$SubscribersTableAnnotationComposer,
          $$SubscribersTableCreateCompanionBuilder,
          $$SubscribersTableUpdateCompanionBuilder,
          (Subscriber, $$SubscribersTableReferences),
          Subscriber,
          PrefetchHooks Function({bool subscriberPlatesRefs})
        > {
  $$SubscribersTableTableManager(_$AppDatabase db, $SubscribersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscribersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscribersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscribersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<double> monthlyFee = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => SubscribersCompanion(
                id: id,
                notes: notes,
                startDate: startDate,
                endDate: endDate,
                monthlyFee: monthlyFee,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required double monthlyFee,
                Value<bool> isActive = const Value.absent(),
              }) => SubscribersCompanion.insert(
                id: id,
                notes: notes,
                startDate: startDate,
                endDate: endDate,
                monthlyFee: monthlyFee,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubscribersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subscriberPlatesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (subscriberPlatesRefs) db.subscriberPlates,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (subscriberPlatesRefs)
                    await $_getPrefetchedData<
                      Subscriber,
                      $SubscribersTable,
                      SubscriberPlate
                    >(
                      currentTable: table,
                      referencedTable: $$SubscribersTableReferences
                          ._subscriberPlatesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SubscribersTableReferences(
                            db,
                            table,
                            p0,
                          ).subscriberPlatesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.subscriberId == item.id,
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

typedef $$SubscribersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscribersTable,
      Subscriber,
      $$SubscribersTableFilterComposer,
      $$SubscribersTableOrderingComposer,
      $$SubscribersTableAnnotationComposer,
      $$SubscribersTableCreateCompanionBuilder,
      $$SubscribersTableUpdateCompanionBuilder,
      (Subscriber, $$SubscribersTableReferences),
      Subscriber,
      PrefetchHooks Function({bool subscriberPlatesRefs})
    >;
typedef $$SubscriberPlatesTableCreateCompanionBuilder =
    SubscriberPlatesCompanion Function({
      Value<int> id,
      required int subscriberId,
      required String plate,
    });
typedef $$SubscriberPlatesTableUpdateCompanionBuilder =
    SubscriberPlatesCompanion Function({
      Value<int> id,
      Value<int> subscriberId,
      Value<String> plate,
    });

final class $$SubscriberPlatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SubscriberPlatesTable, SubscriberPlate> {
  $$SubscriberPlatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubscribersTable _subscriberIdTable(_$AppDatabase db) =>
      db.subscribers.createAlias(
        $_aliasNameGenerator(
          db.subscriberPlates.subscriberId,
          db.subscribers.id,
        ),
      );

  $$SubscribersTableProcessedTableManager get subscriberId {
    final $_column = $_itemColumn<int>('subscriber_id')!;

    final manager = $$SubscribersTableTableManager(
      $_db,
      $_db.subscribers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subscriberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubscriberPlatesTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriberPlatesTable> {
  $$SubscriberPlatesTableFilterComposer({
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

  ColumnFilters<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnFilters(column),
  );

  $$SubscribersTableFilterComposer get subscriberId {
    final $$SubscribersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriberId,
      referencedTable: $db.subscribers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscribersTableFilterComposer(
            $db: $db,
            $table: $db.subscribers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriberPlatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriberPlatesTable> {
  $$SubscriberPlatesTableOrderingComposer({
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

  ColumnOrderings<String> get plate => $composableBuilder(
    column: $table.plate,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubscribersTableOrderingComposer get subscriberId {
    final $$SubscribersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriberId,
      referencedTable: $db.subscribers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscribersTableOrderingComposer(
            $db: $db,
            $table: $db.subscribers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriberPlatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriberPlatesTable> {
  $$SubscriberPlatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plate =>
      $composableBuilder(column: $table.plate, builder: (column) => column);

  $$SubscribersTableAnnotationComposer get subscriberId {
    final $$SubscribersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subscriberId,
      referencedTable: $db.subscribers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubscribersTableAnnotationComposer(
            $db: $db,
            $table: $db.subscribers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubscriberPlatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubscriberPlatesTable,
          SubscriberPlate,
          $$SubscriberPlatesTableFilterComposer,
          $$SubscriberPlatesTableOrderingComposer,
          $$SubscriberPlatesTableAnnotationComposer,
          $$SubscriberPlatesTableCreateCompanionBuilder,
          $$SubscriberPlatesTableUpdateCompanionBuilder,
          (SubscriberPlate, $$SubscriberPlatesTableReferences),
          SubscriberPlate,
          PrefetchHooks Function({bool subscriberId})
        > {
  $$SubscriberPlatesTableTableManager(
    _$AppDatabase db,
    $SubscriberPlatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriberPlatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriberPlatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriberPlatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subscriberId = const Value.absent(),
                Value<String> plate = const Value.absent(),
              }) => SubscriberPlatesCompanion(
                id: id,
                subscriberId: subscriberId,
                plate: plate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subscriberId,
                required String plate,
              }) => SubscriberPlatesCompanion.insert(
                id: id,
                subscriberId: subscriberId,
                plate: plate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubscriberPlatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subscriberId = false}) {
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
                    if (subscriberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subscriberId,
                                referencedTable:
                                    $$SubscriberPlatesTableReferences
                                        ._subscriberIdTable(db),
                                referencedColumn:
                                    $$SubscriberPlatesTableReferences
                                        ._subscriberIdTable(db)
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

typedef $$SubscriberPlatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubscriberPlatesTable,
      SubscriberPlate,
      $$SubscriberPlatesTableFilterComposer,
      $$SubscriberPlatesTableOrderingComposer,
      $$SubscriberPlatesTableAnnotationComposer,
      $$SubscriberPlatesTableCreateCompanionBuilder,
      $$SubscriberPlatesTableUpdateCompanionBuilder,
      (SubscriberPlate, $$SubscriberPlatesTableReferences),
      SubscriberPlate,
      PrefetchHooks Function({bool subscriberId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TariffsTableTableManager get tariffs =>
      $$TariffsTableTableManager(_db, _db.tariffs);
  $$ParkingRecordsTableTableManager get parkingRecords =>
      $$ParkingRecordsTableTableManager(_db, _db.parkingRecords);
  $$SubscribersTableTableManager get subscribers =>
      $$SubscribersTableTableManager(_db, _db.subscribers);
  $$SubscriberPlatesTableTableManager get subscriberPlates =>
      $$SubscriberPlatesTableTableManager(_db, _db.subscriberPlates);
}
