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
  static const VerificationMeta _dailySubscriptionPriceMeta =
      const VerificationMeta('dailySubscriptionPrice');
  @override
  late final GeneratedColumn<double> dailySubscriptionPrice =
      GeneratedColumn<double>(
        'daily_subscription_price',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(150.0),
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
    dailySubscriptionPrice,
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
    if (data.containsKey('daily_subscription_price')) {
      context.handle(
        _dailySubscriptionPriceMeta,
        dailySubscriptionPrice.isAcceptableOrUnknown(
          data['daily_subscription_price']!,
          _dailySubscriptionPriceMeta,
        ),
      );
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
      dailySubscriptionPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_subscription_price'],
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
  final double dailySubscriptionPrice;
  final DateTime validFrom;
  final DateTime? validTo;
  final bool isActive;
  const Tariff({
    required this.id,
    required this.name,
    required this.bracketsJson,
    required this.fullDayPrice,
    required this.monthlyPrice,
    required this.dailySubscriptionPrice,
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
    map['daily_subscription_price'] = Variable<double>(dailySubscriptionPrice);
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
      dailySubscriptionPrice: Value(dailySubscriptionPrice),
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
      dailySubscriptionPrice: serializer.fromJson<double>(
        json['dailySubscriptionPrice'],
      ),
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
      'dailySubscriptionPrice': serializer.toJson<double>(
        dailySubscriptionPrice,
      ),
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
    double? dailySubscriptionPrice,
    DateTime? validFrom,
    Value<DateTime?> validTo = const Value.absent(),
    bool? isActive,
  }) => Tariff(
    id: id ?? this.id,
    name: name ?? this.name,
    bracketsJson: bracketsJson ?? this.bracketsJson,
    fullDayPrice: fullDayPrice ?? this.fullDayPrice,
    monthlyPrice: monthlyPrice ?? this.monthlyPrice,
    dailySubscriptionPrice:
        dailySubscriptionPrice ?? this.dailySubscriptionPrice,
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
      dailySubscriptionPrice: data.dailySubscriptionPrice.present
          ? data.dailySubscriptionPrice.value
          : this.dailySubscriptionPrice,
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
          ..write('dailySubscriptionPrice: $dailySubscriptionPrice, ')
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
    dailySubscriptionPrice,
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
          other.dailySubscriptionPrice == this.dailySubscriptionPrice &&
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
  final Value<double> dailySubscriptionPrice;
  final Value<DateTime> validFrom;
  final Value<DateTime?> validTo;
  final Value<bool> isActive;
  const TariffsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.bracketsJson = const Value.absent(),
    this.fullDayPrice = const Value.absent(),
    this.monthlyPrice = const Value.absent(),
    this.dailySubscriptionPrice = const Value.absent(),
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
    this.dailySubscriptionPrice = const Value.absent(),
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
    Expression<double>? dailySubscriptionPrice,
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
      if (dailySubscriptionPrice != null)
        'daily_subscription_price': dailySubscriptionPrice,
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
    Value<double>? dailySubscriptionPrice,
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
      dailySubscriptionPrice:
          dailySubscriptionPrice ?? this.dailySubscriptionPrice,
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
    if (dailySubscriptionPrice.present) {
      map['daily_subscription_price'] = Variable<double>(
        dailySubscriptionPrice.value,
      );
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
          ..write('dailySubscriptionPrice: $dailySubscriptionPrice, ')
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
  static const VerificationMeta _isLargeVehicleMeta = const VerificationMeta(
    'isLargeVehicle',
  );
  @override
  late final GeneratedColumn<bool> isLargeVehicle = GeneratedColumn<bool>(
    'is_large_vehicle',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_large_vehicle" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDailySubscriberMeta = const VerificationMeta(
    'isDailySubscriber',
  );
  @override
  late final GeneratedColumn<bool> isDailySubscriber = GeneratedColumn<bool>(
    'is_daily_subscriber',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_daily_subscriber" IN (0, 1))',
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
    isLargeVehicle,
    isDailySubscriber,
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
    if (data.containsKey('is_large_vehicle')) {
      context.handle(
        _isLargeVehicleMeta,
        isLargeVehicle.isAcceptableOrUnknown(
          data['is_large_vehicle']!,
          _isLargeVehicleMeta,
        ),
      );
    }
    if (data.containsKey('is_daily_subscriber')) {
      context.handle(
        _isDailySubscriberMeta,
        isDailySubscriber.isAcceptableOrUnknown(
          data['is_daily_subscriber']!,
          _isDailySubscriberMeta,
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
      isLargeVehicle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_large_vehicle'],
      )!,
      isDailySubscriber: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_daily_subscriber'],
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

  /// True if vehicle was a monthly subscriber at entry time.
  final bool isSubscriber;

  /// True if vehicle was flagged as a large vehicle at entry.
  final bool isLargeVehicle;

  /// True if vehicle was flagged as a daily subscriber at entry.
  final bool isDailySubscriber;

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
    required this.isLargeVehicle,
    required this.isDailySubscriber,
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
    map['is_large_vehicle'] = Variable<bool>(isLargeVehicle);
    map['is_daily_subscriber'] = Variable<bool>(isDailySubscriber);
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
      isLargeVehicle: Value(isLargeVehicle),
      isDailySubscriber: Value(isDailySubscriber),
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
      isLargeVehicle: serializer.fromJson<bool>(json['isLargeVehicle']),
      isDailySubscriber: serializer.fromJson<bool>(json['isDailySubscriber']),
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
      'isLargeVehicle': serializer.toJson<bool>(isLargeVehicle),
      'isDailySubscriber': serializer.toJson<bool>(isDailySubscriber),
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
    bool? isLargeVehicle,
    bool? isDailySubscriber,
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
    isLargeVehicle: isLargeVehicle ?? this.isLargeVehicle,
    isDailySubscriber: isDailySubscriber ?? this.isDailySubscriber,
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
      isLargeVehicle: data.isLargeVehicle.present
          ? data.isLargeVehicle.value
          : this.isLargeVehicle,
      isDailySubscriber: data.isDailySubscriber.present
          ? data.isDailySubscriber.value
          : this.isDailySubscriber,
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
          ..write('isLargeVehicle: $isLargeVehicle, ')
          ..write('isDailySubscriber: $isDailySubscriber, ')
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
    isLargeVehicle,
    isDailySubscriber,
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
          other.isLargeVehicle == this.isLargeVehicle &&
          other.isDailySubscriber == this.isDailySubscriber &&
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
  final Value<bool> isLargeVehicle;
  final Value<bool> isDailySubscriber;
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
    this.isLargeVehicle = const Value.absent(),
    this.isDailySubscriber = const Value.absent(),
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
    this.isLargeVehicle = const Value.absent(),
    this.isDailySubscriber = const Value.absent(),
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
    Expression<bool>? isLargeVehicle,
    Expression<bool>? isDailySubscriber,
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
      if (isLargeVehicle != null) 'is_large_vehicle': isLargeVehicle,
      if (isDailySubscriber != null) 'is_daily_subscriber': isDailySubscriber,
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
    Value<bool>? isLargeVehicle,
    Value<bool>? isDailySubscriber,
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
      isLargeVehicle: isLargeVehicle ?? this.isLargeVehicle,
      isDailySubscriber: isDailySubscriber ?? this.isDailySubscriber,
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
    if (isLargeVehicle.present) {
      map['is_large_vehicle'] = Variable<bool>(isLargeVehicle.value);
    }
    if (isDailySubscriber.present) {
      map['is_daily_subscriber'] = Variable<bool>(isDailySubscriber.value);
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
          ..write('isLargeVehicle: $isLargeVehicle, ')
          ..write('isDailySubscriber: $isDailySubscriber, ')
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
  static const VerificationMeta _subscriberTypeMeta = const VerificationMeta(
    'subscriberType',
  );
  @override
  late final GeneratedColumn<String> subscriberType = GeneratedColumn<String>(
    'subscriber_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _dailyFeeMeta = const VerificationMeta(
    'dailyFee',
  );
  @override
  late final GeneratedColumn<double> dailyFee = GeneratedColumn<double>(
    'daily_fee',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feePaidUntilMeta = const VerificationMeta(
    'feePaidUntil',
  );
  @override
  late final GeneratedColumn<DateTime> feePaidUntil = GeneratedColumn<DateTime>(
    'fee_paid_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentSnoozedUntilMeta =
      const VerificationMeta('paymentSnoozedUntil');
  @override
  late final GeneratedColumn<DateTime> paymentSnoozedUntil =
      GeneratedColumn<DateTime>(
        'payment_snoozed_until',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    notes,
    startDate,
    endDate,
    monthlyFee,
    isActive,
    subscriberType,
    dailyFee,
    feePaidUntil,
    paymentSnoozedUntil,
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
    if (data.containsKey('subscriber_type')) {
      context.handle(
        _subscriberTypeMeta,
        subscriberType.isAcceptableOrUnknown(
          data['subscriber_type']!,
          _subscriberTypeMeta,
        ),
      );
    }
    if (data.containsKey('daily_fee')) {
      context.handle(
        _dailyFeeMeta,
        dailyFee.isAcceptableOrUnknown(data['daily_fee']!, _dailyFeeMeta),
      );
    }
    if (data.containsKey('fee_paid_until')) {
      context.handle(
        _feePaidUntilMeta,
        feePaidUntil.isAcceptableOrUnknown(
          data['fee_paid_until']!,
          _feePaidUntilMeta,
        ),
      );
    }
    if (data.containsKey('payment_snoozed_until')) {
      context.handle(
        _paymentSnoozedUntilMeta,
        paymentSnoozedUntil.isAcceptableOrUnknown(
          data['payment_snoozed_until']!,
          _paymentSnoozedUntilMeta,
        ),
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
      subscriberType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscriber_type'],
      )!,
      dailyFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_fee'],
      ),
      feePaidUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fee_paid_until'],
      ),
      paymentSnoozedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_snoozed_until'],
      ),
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

  /// 'monthly' or 'daily'
  final String subscriberType;

  /// Fee charged per day for daily subscribers (null = use default 150).
  final double? dailyFee;

  /// When the monthly fee was last paid until (set to endDate at payment).
  final DateTime? feePaidUntil;

  /// If set and in the future, don't prompt for payment.
  final DateTime? paymentSnoozedUntil;
  const Subscriber({
    required this.id,
    this.notes,
    required this.startDate,
    required this.endDate,
    required this.monthlyFee,
    required this.isActive,
    required this.subscriberType,
    this.dailyFee,
    this.feePaidUntil,
    this.paymentSnoozedUntil,
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
    map['subscriber_type'] = Variable<String>(subscriberType);
    if (!nullToAbsent || dailyFee != null) {
      map['daily_fee'] = Variable<double>(dailyFee);
    }
    if (!nullToAbsent || feePaidUntil != null) {
      map['fee_paid_until'] = Variable<DateTime>(feePaidUntil);
    }
    if (!nullToAbsent || paymentSnoozedUntil != null) {
      map['payment_snoozed_until'] = Variable<DateTime>(paymentSnoozedUntil);
    }
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
      subscriberType: Value(subscriberType),
      dailyFee: dailyFee == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyFee),
      feePaidUntil: feePaidUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(feePaidUntil),
      paymentSnoozedUntil: paymentSnoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentSnoozedUntil),
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
      subscriberType: serializer.fromJson<String>(json['subscriberType']),
      dailyFee: serializer.fromJson<double?>(json['dailyFee']),
      feePaidUntil: serializer.fromJson<DateTime?>(json['feePaidUntil']),
      paymentSnoozedUntil: serializer.fromJson<DateTime?>(
        json['paymentSnoozedUntil'],
      ),
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
      'subscriberType': serializer.toJson<String>(subscriberType),
      'dailyFee': serializer.toJson<double?>(dailyFee),
      'feePaidUntil': serializer.toJson<DateTime?>(feePaidUntil),
      'paymentSnoozedUntil': serializer.toJson<DateTime?>(paymentSnoozedUntil),
    };
  }

  Subscriber copyWith({
    int? id,
    Value<String?> notes = const Value.absent(),
    DateTime? startDate,
    DateTime? endDate,
    double? monthlyFee,
    bool? isActive,
    String? subscriberType,
    Value<double?> dailyFee = const Value.absent(),
    Value<DateTime?> feePaidUntil = const Value.absent(),
    Value<DateTime?> paymentSnoozedUntil = const Value.absent(),
  }) => Subscriber(
    id: id ?? this.id,
    notes: notes.present ? notes.value : this.notes,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    monthlyFee: monthlyFee ?? this.monthlyFee,
    isActive: isActive ?? this.isActive,
    subscriberType: subscriberType ?? this.subscriberType,
    dailyFee: dailyFee.present ? dailyFee.value : this.dailyFee,
    feePaidUntil: feePaidUntil.present ? feePaidUntil.value : this.feePaidUntil,
    paymentSnoozedUntil: paymentSnoozedUntil.present
        ? paymentSnoozedUntil.value
        : this.paymentSnoozedUntil,
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
      subscriberType: data.subscriberType.present
          ? data.subscriberType.value
          : this.subscriberType,
      dailyFee: data.dailyFee.present ? data.dailyFee.value : this.dailyFee,
      feePaidUntil: data.feePaidUntil.present
          ? data.feePaidUntil.value
          : this.feePaidUntil,
      paymentSnoozedUntil: data.paymentSnoozedUntil.present
          ? data.paymentSnoozedUntil.value
          : this.paymentSnoozedUntil,
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
          ..write('isActive: $isActive, ')
          ..write('subscriberType: $subscriberType, ')
          ..write('dailyFee: $dailyFee, ')
          ..write('feePaidUntil: $feePaidUntil, ')
          ..write('paymentSnoozedUntil: $paymentSnoozedUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    notes,
    startDate,
    endDate,
    monthlyFee,
    isActive,
    subscriberType,
    dailyFee,
    feePaidUntil,
    paymentSnoozedUntil,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subscriber &&
          other.id == this.id &&
          other.notes == this.notes &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.monthlyFee == this.monthlyFee &&
          other.isActive == this.isActive &&
          other.subscriberType == this.subscriberType &&
          other.dailyFee == this.dailyFee &&
          other.feePaidUntil == this.feePaidUntil &&
          other.paymentSnoozedUntil == this.paymentSnoozedUntil);
}

class SubscribersCompanion extends UpdateCompanion<Subscriber> {
  final Value<int> id;
  final Value<String?> notes;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<double> monthlyFee;
  final Value<bool> isActive;
  final Value<String> subscriberType;
  final Value<double?> dailyFee;
  final Value<DateTime?> feePaidUntil;
  final Value<DateTime?> paymentSnoozedUntil;
  const SubscribersCompanion({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.monthlyFee = const Value.absent(),
    this.isActive = const Value.absent(),
    this.subscriberType = const Value.absent(),
    this.dailyFee = const Value.absent(),
    this.feePaidUntil = const Value.absent(),
    this.paymentSnoozedUntil = const Value.absent(),
  });
  SubscribersCompanion.insert({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required double monthlyFee,
    this.isActive = const Value.absent(),
    this.subscriberType = const Value.absent(),
    this.dailyFee = const Value.absent(),
    this.feePaidUntil = const Value.absent(),
    this.paymentSnoozedUntil = const Value.absent(),
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
    Expression<String>? subscriberType,
    Expression<double>? dailyFee,
    Expression<DateTime>? feePaidUntil,
    Expression<DateTime>? paymentSnoozedUntil,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notes != null) 'notes': notes,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (monthlyFee != null) 'monthly_fee': monthlyFee,
      if (isActive != null) 'is_active': isActive,
      if (subscriberType != null) 'subscriber_type': subscriberType,
      if (dailyFee != null) 'daily_fee': dailyFee,
      if (feePaidUntil != null) 'fee_paid_until': feePaidUntil,
      if (paymentSnoozedUntil != null)
        'payment_snoozed_until': paymentSnoozedUntil,
    });
  }

  SubscribersCompanion copyWith({
    Value<int>? id,
    Value<String?>? notes,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<double>? monthlyFee,
    Value<bool>? isActive,
    Value<String>? subscriberType,
    Value<double?>? dailyFee,
    Value<DateTime?>? feePaidUntil,
    Value<DateTime?>? paymentSnoozedUntil,
  }) {
    return SubscribersCompanion(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      isActive: isActive ?? this.isActive,
      subscriberType: subscriberType ?? this.subscriberType,
      dailyFee: dailyFee ?? this.dailyFee,
      feePaidUntil: feePaidUntil ?? this.feePaidUntil,
      paymentSnoozedUntil: paymentSnoozedUntil ?? this.paymentSnoozedUntil,
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
    if (subscriberType.present) {
      map['subscriber_type'] = Variable<String>(subscriberType.value);
    }
    if (dailyFee.present) {
      map['daily_fee'] = Variable<double>(dailyFee.value);
    }
    if (feePaidUntil.present) {
      map['fee_paid_until'] = Variable<DateTime>(feePaidUntil.value);
    }
    if (paymentSnoozedUntil.present) {
      map['payment_snoozed_until'] = Variable<DateTime>(
        paymentSnoozedUntil.value,
      );
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
          ..write('isActive: $isActive, ')
          ..write('subscriberType: $subscriberType, ')
          ..write('dailyFee: $dailyFee, ')
          ..write('feePaidUntil: $feePaidUntil, ')
          ..write('paymentSnoozedUntil: $paymentSnoozedUntil')
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

class $LargeVehiclePlatesTable extends LargeVehiclePlates
    with TableInfo<$LargeVehiclePlatesTable, LargeVehiclePlate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LargeVehiclePlatesTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [id, plate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'large_vehicle_plates';
  @override
  VerificationContext validateIntegrity(
    Insertable<LargeVehiclePlate> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LargeVehiclePlate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LargeVehiclePlate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
    );
  }

  @override
  $LargeVehiclePlatesTable createAlias(String alias) {
    return $LargeVehiclePlatesTable(attachedDatabase, alias);
  }
}

class LargeVehiclePlate extends DataClass
    implements Insertable<LargeVehiclePlate> {
  final int id;

  /// Normalised uppercase plate string — unique per plate.
  final String plate;
  const LargeVehiclePlate({required this.id, required this.plate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plate'] = Variable<String>(plate);
    return map;
  }

  LargeVehiclePlatesCompanion toCompanion(bool nullToAbsent) {
    return LargeVehiclePlatesCompanion(id: Value(id), plate: Value(plate));
  }

  factory LargeVehiclePlate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LargeVehiclePlate(
      id: serializer.fromJson<int>(json['id']),
      plate: serializer.fromJson<String>(json['plate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plate': serializer.toJson<String>(plate),
    };
  }

  LargeVehiclePlate copyWith({int? id, String? plate}) =>
      LargeVehiclePlate(id: id ?? this.id, plate: plate ?? this.plate);
  LargeVehiclePlate copyWithCompanion(LargeVehiclePlatesCompanion data) {
    return LargeVehiclePlate(
      id: data.id.present ? data.id.value : this.id,
      plate: data.plate.present ? data.plate.value : this.plate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LargeVehiclePlate(')
          ..write('id: $id, ')
          ..write('plate: $plate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LargeVehiclePlate &&
          other.id == this.id &&
          other.plate == this.plate);
}

class LargeVehiclePlatesCompanion extends UpdateCompanion<LargeVehiclePlate> {
  final Value<int> id;
  final Value<String> plate;
  const LargeVehiclePlatesCompanion({
    this.id = const Value.absent(),
    this.plate = const Value.absent(),
  });
  LargeVehiclePlatesCompanion.insert({
    this.id = const Value.absent(),
    required String plate,
  }) : plate = Value(plate);
  static Insertable<LargeVehiclePlate> custom({
    Expression<int>? id,
    Expression<String>? plate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plate != null) 'plate': plate,
    });
  }

  LargeVehiclePlatesCompanion copyWith({Value<int>? id, Value<String>? plate}) {
    return LargeVehiclePlatesCompanion(
      id: id ?? this.id,
      plate: plate ?? this.plate,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LargeVehiclePlatesCompanion(')
          ..write('id: $id, ')
          ..write('plate: $plate')
          ..write(')'))
        .toString();
  }
}

class $RegisteredVehiclesTable extends RegisteredVehicles
    with TableInfo<$RegisteredVehiclesTable, RegisteredVehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegisteredVehiclesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _vehicleTypeMeta = const VerificationMeta(
    'vehicleType',
  );
  @override
  late final GeneratedColumn<String> vehicleType = GeneratedColumn<String>(
    'vehicle_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _subscriptionTypeMeta = const VerificationMeta(
    'subscriptionType',
  );
  @override
  late final GeneratedColumn<String> subscriptionType = GeneratedColumn<String>(
    'subscription_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _subscriptionStartDateMeta =
      const VerificationMeta('subscriptionStartDate');
  @override
  late final GeneratedColumn<DateTime> subscriptionStartDate =
      GeneratedColumn<DateTime>(
        'subscription_start_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _subscriptionEndDateMeta =
      const VerificationMeta('subscriptionEndDate');
  @override
  late final GeneratedColumn<DateTime> subscriptionEndDate =
      GeneratedColumn<DateTime>(
        'subscription_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dailyFeeMeta = const VerificationMeta(
    'dailyFee',
  );
  @override
  late final GeneratedColumn<double> dailyFee = GeneratedColumn<double>(
    'daily_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(150.0),
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
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plate,
    vehicleType,
    subscriptionType,
    subscriptionStartDate,
    subscriptionEndDate,
    dailyFee,
    monthlyFee,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'registered_vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegisteredVehicle> instance, {
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
    if (data.containsKey('vehicle_type')) {
      context.handle(
        _vehicleTypeMeta,
        vehicleType.isAcceptableOrUnknown(
          data['vehicle_type']!,
          _vehicleTypeMeta,
        ),
      );
    }
    if (data.containsKey('subscription_type')) {
      context.handle(
        _subscriptionTypeMeta,
        subscriptionType.isAcceptableOrUnknown(
          data['subscription_type']!,
          _subscriptionTypeMeta,
        ),
      );
    }
    if (data.containsKey('subscription_start_date')) {
      context.handle(
        _subscriptionStartDateMeta,
        subscriptionStartDate.isAcceptableOrUnknown(
          data['subscription_start_date']!,
          _subscriptionStartDateMeta,
        ),
      );
    }
    if (data.containsKey('subscription_end_date')) {
      context.handle(
        _subscriptionEndDateMeta,
        subscriptionEndDate.isAcceptableOrUnknown(
          data['subscription_end_date']!,
          _subscriptionEndDateMeta,
        ),
      );
    }
    if (data.containsKey('daily_fee')) {
      context.handle(
        _dailyFeeMeta,
        dailyFee.isAcceptableOrUnknown(data['daily_fee']!, _dailyFeeMeta),
      );
    }
    if (data.containsKey('monthly_fee')) {
      context.handle(
        _monthlyFeeMeta,
        monthlyFee.isAcceptableOrUnknown(data['monthly_fee']!, _monthlyFeeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {plate},
  ];
  @override
  RegisteredVehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegisteredVehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
      vehicleType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_type'],
      )!,
      subscriptionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_type'],
      )!,
      subscriptionStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}subscription_start_date'],
      ),
      subscriptionEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}subscription_end_date'],
      ),
      dailyFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_fee'],
      )!,
      monthlyFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_fee'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RegisteredVehiclesTable createAlias(String alias) {
    return $RegisteredVehiclesTable(attachedDatabase, alias);
  }
}

class RegisteredVehicle extends DataClass
    implements Insertable<RegisteredVehicle> {
  final int id;

  /// Normalised uppercase plate — unique per vehicle.
  final String plate;

  /// 'normal' | 'large'
  final String vehicleType;

  /// 'none' | 'daily' | 'monthly'
  final String subscriptionType;

  /// When the current monthly subscription period started.
  final DateTime? subscriptionStartDate;

  /// When the current monthly subscription period ends (start + 30 days).
  final DateTime? subscriptionEndDate;

  /// Per-day fee for daily subscribers.
  final double dailyFee;

  /// Monthly fee amount (loaded from tariff at registration/renewal).
  final double monthlyFee;
  final String? notes;
  final DateTime createdAt;
  const RegisteredVehicle({
    required this.id,
    required this.plate,
    required this.vehicleType,
    required this.subscriptionType,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    required this.dailyFee,
    required this.monthlyFee,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plate'] = Variable<String>(plate);
    map['vehicle_type'] = Variable<String>(vehicleType);
    map['subscription_type'] = Variable<String>(subscriptionType);
    if (!nullToAbsent || subscriptionStartDate != null) {
      map['subscription_start_date'] = Variable<DateTime>(
        subscriptionStartDate,
      );
    }
    if (!nullToAbsent || subscriptionEndDate != null) {
      map['subscription_end_date'] = Variable<DateTime>(subscriptionEndDate);
    }
    map['daily_fee'] = Variable<double>(dailyFee);
    map['monthly_fee'] = Variable<double>(monthlyFee);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RegisteredVehiclesCompanion toCompanion(bool nullToAbsent) {
    return RegisteredVehiclesCompanion(
      id: Value(id),
      plate: Value(plate),
      vehicleType: Value(vehicleType),
      subscriptionType: Value(subscriptionType),
      subscriptionStartDate: subscriptionStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionStartDate),
      subscriptionEndDate: subscriptionEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionEndDate),
      dailyFee: Value(dailyFee),
      monthlyFee: Value(monthlyFee),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory RegisteredVehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegisteredVehicle(
      id: serializer.fromJson<int>(json['id']),
      plate: serializer.fromJson<String>(json['plate']),
      vehicleType: serializer.fromJson<String>(json['vehicleType']),
      subscriptionType: serializer.fromJson<String>(json['subscriptionType']),
      subscriptionStartDate: serializer.fromJson<DateTime?>(
        json['subscriptionStartDate'],
      ),
      subscriptionEndDate: serializer.fromJson<DateTime?>(
        json['subscriptionEndDate'],
      ),
      dailyFee: serializer.fromJson<double>(json['dailyFee']),
      monthlyFee: serializer.fromJson<double>(json['monthlyFee']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plate': serializer.toJson<String>(plate),
      'vehicleType': serializer.toJson<String>(vehicleType),
      'subscriptionType': serializer.toJson<String>(subscriptionType),
      'subscriptionStartDate': serializer.toJson<DateTime?>(
        subscriptionStartDate,
      ),
      'subscriptionEndDate': serializer.toJson<DateTime?>(subscriptionEndDate),
      'dailyFee': serializer.toJson<double>(dailyFee),
      'monthlyFee': serializer.toJson<double>(monthlyFee),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RegisteredVehicle copyWith({
    int? id,
    String? plate,
    String? vehicleType,
    String? subscriptionType,
    Value<DateTime?> subscriptionStartDate = const Value.absent(),
    Value<DateTime?> subscriptionEndDate = const Value.absent(),
    double? dailyFee,
    double? monthlyFee,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => RegisteredVehicle(
    id: id ?? this.id,
    plate: plate ?? this.plate,
    vehicleType: vehicleType ?? this.vehicleType,
    subscriptionType: subscriptionType ?? this.subscriptionType,
    subscriptionStartDate: subscriptionStartDate.present
        ? subscriptionStartDate.value
        : this.subscriptionStartDate,
    subscriptionEndDate: subscriptionEndDate.present
        ? subscriptionEndDate.value
        : this.subscriptionEndDate,
    dailyFee: dailyFee ?? this.dailyFee,
    monthlyFee: monthlyFee ?? this.monthlyFee,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  RegisteredVehicle copyWithCompanion(RegisteredVehiclesCompanion data) {
    return RegisteredVehicle(
      id: data.id.present ? data.id.value : this.id,
      plate: data.plate.present ? data.plate.value : this.plate,
      vehicleType: data.vehicleType.present
          ? data.vehicleType.value
          : this.vehicleType,
      subscriptionType: data.subscriptionType.present
          ? data.subscriptionType.value
          : this.subscriptionType,
      subscriptionStartDate: data.subscriptionStartDate.present
          ? data.subscriptionStartDate.value
          : this.subscriptionStartDate,
      subscriptionEndDate: data.subscriptionEndDate.present
          ? data.subscriptionEndDate.value
          : this.subscriptionEndDate,
      dailyFee: data.dailyFee.present ? data.dailyFee.value : this.dailyFee,
      monthlyFee: data.monthlyFee.present
          ? data.monthlyFee.value
          : this.monthlyFee,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegisteredVehicle(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('subscriptionType: $subscriptionType, ')
          ..write('subscriptionStartDate: $subscriptionStartDate, ')
          ..write('subscriptionEndDate: $subscriptionEndDate, ')
          ..write('dailyFee: $dailyFee, ')
          ..write('monthlyFee: $monthlyFee, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plate,
    vehicleType,
    subscriptionType,
    subscriptionStartDate,
    subscriptionEndDate,
    dailyFee,
    monthlyFee,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegisteredVehicle &&
          other.id == this.id &&
          other.plate == this.plate &&
          other.vehicleType == this.vehicleType &&
          other.subscriptionType == this.subscriptionType &&
          other.subscriptionStartDate == this.subscriptionStartDate &&
          other.subscriptionEndDate == this.subscriptionEndDate &&
          other.dailyFee == this.dailyFee &&
          other.monthlyFee == this.monthlyFee &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class RegisteredVehiclesCompanion extends UpdateCompanion<RegisteredVehicle> {
  final Value<int> id;
  final Value<String> plate;
  final Value<String> vehicleType;
  final Value<String> subscriptionType;
  final Value<DateTime?> subscriptionStartDate;
  final Value<DateTime?> subscriptionEndDate;
  final Value<double> dailyFee;
  final Value<double> monthlyFee;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const RegisteredVehiclesCompanion({
    this.id = const Value.absent(),
    this.plate = const Value.absent(),
    this.vehicleType = const Value.absent(),
    this.subscriptionType = const Value.absent(),
    this.subscriptionStartDate = const Value.absent(),
    this.subscriptionEndDate = const Value.absent(),
    this.dailyFee = const Value.absent(),
    this.monthlyFee = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RegisteredVehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String plate,
    this.vehicleType = const Value.absent(),
    this.subscriptionType = const Value.absent(),
    this.subscriptionStartDate = const Value.absent(),
    this.subscriptionEndDate = const Value.absent(),
    this.dailyFee = const Value.absent(),
    this.monthlyFee = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
  }) : plate = Value(plate),
       createdAt = Value(createdAt);
  static Insertable<RegisteredVehicle> custom({
    Expression<int>? id,
    Expression<String>? plate,
    Expression<String>? vehicleType,
    Expression<String>? subscriptionType,
    Expression<DateTime>? subscriptionStartDate,
    Expression<DateTime>? subscriptionEndDate,
    Expression<double>? dailyFee,
    Expression<double>? monthlyFee,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plate != null) 'plate': plate,
      if (vehicleType != null) 'vehicle_type': vehicleType,
      if (subscriptionType != null) 'subscription_type': subscriptionType,
      if (subscriptionStartDate != null)
        'subscription_start_date': subscriptionStartDate,
      if (subscriptionEndDate != null)
        'subscription_end_date': subscriptionEndDate,
      if (dailyFee != null) 'daily_fee': dailyFee,
      if (monthlyFee != null) 'monthly_fee': monthlyFee,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RegisteredVehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? plate,
    Value<String>? vehicleType,
    Value<String>? subscriptionType,
    Value<DateTime?>? subscriptionStartDate,
    Value<DateTime?>? subscriptionEndDate,
    Value<double>? dailyFee,
    Value<double>? monthlyFee,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return RegisteredVehiclesCompanion(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      vehicleType: vehicleType ?? this.vehicleType,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionStartDate:
          subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      dailyFee: dailyFee ?? this.dailyFee,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
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
    if (vehicleType.present) {
      map['vehicle_type'] = Variable<String>(vehicleType.value);
    }
    if (subscriptionType.present) {
      map['subscription_type'] = Variable<String>(subscriptionType.value);
    }
    if (subscriptionStartDate.present) {
      map['subscription_start_date'] = Variable<DateTime>(
        subscriptionStartDate.value,
      );
    }
    if (subscriptionEndDate.present) {
      map['subscription_end_date'] = Variable<DateTime>(
        subscriptionEndDate.value,
      );
    }
    if (dailyFee.present) {
      map['daily_fee'] = Variable<double>(dailyFee.value);
    }
    if (monthlyFee.present) {
      map['monthly_fee'] = Variable<double>(monthlyFee.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegisteredVehiclesCompanion(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('vehicleType: $vehicleType, ')
          ..write('subscriptionType: $subscriptionType, ')
          ..write('subscriptionStartDate: $subscriptionStartDate, ')
          ..write('subscriptionEndDate: $subscriptionEndDate, ')
          ..write('dailyFee: $dailyFee, ')
          ..write('monthlyFee: $monthlyFee, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CleaningRecordsTable extends CleaningRecords
    with TableInfo<$CleaningRecordsTable, CleaningRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CleaningRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseCostMeta = const VerificationMeta(
    'baseCost',
  );
  @override
  late final GeneratedColumn<double> baseCost = GeneratedColumn<double>(
    'base_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalCostMeta = const VerificationMeta(
    'finalCost',
  );
  @override
  late final GeneratedColumn<double> finalCost = GeneratedColumn<double>(
    'final_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<double> discountPercent = GeneratedColumn<double>(
    'discount_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _isLargeVehicleMeta = const VerificationMeta(
    'isLargeVehicle',
  );
  @override
  late final GeneratedColumn<bool> isLargeVehicle = GeneratedColumn<bool>(
    'is_large_vehicle',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_large_vehicle" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _wasParkingCarMeta = const VerificationMeta(
    'wasParkingCar',
  );
  @override
  late final GeneratedColumn<bool> wasParkingCar = GeneratedColumn<bool>(
    'was_parking_car',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_parking_car" IN (0, 1))',
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
    defaultValue: const Constant('cleaned'),
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
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    plate,
    serviceType,
    baseCost,
    finalCost,
    discountPercent,
    isLargeVehicle,
    wasParkingCar,
    status,
    notes,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cleaning_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<CleaningRecord> instance, {
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
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
    }
    if (data.containsKey('base_cost')) {
      context.handle(
        _baseCostMeta,
        baseCost.isAcceptableOrUnknown(data['base_cost']!, _baseCostMeta),
      );
    } else if (isInserting) {
      context.missing(_baseCostMeta);
    }
    if (data.containsKey('final_cost')) {
      context.handle(
        _finalCostMeta,
        finalCost.isAcceptableOrUnknown(data['final_cost']!, _finalCostMeta),
      );
    } else if (isInserting) {
      context.missing(_finalCostMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('is_large_vehicle')) {
      context.handle(
        _isLargeVehicleMeta,
        isLargeVehicle.isAcceptableOrUnknown(
          data['is_large_vehicle']!,
          _isLargeVehicleMeta,
        ),
      );
    }
    if (data.containsKey('was_parking_car')) {
      context.handle(
        _wasParkingCarMeta,
        wasParkingCar.isAcceptableOrUnknown(
          data['was_parking_car']!,
          _wasParkingCarMeta,
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CleaningRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CleaningRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      plate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plate'],
      )!,
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      baseCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_cost'],
      )!,
      finalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_cost'],
      )!,
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_percent'],
      )!,
      isLargeVehicle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_large_vehicle'],
      )!,
      wasParkingCar: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_parking_car'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $CleaningRecordsTable createAlias(String alias) {
    return $CleaningRecordsTable(attachedDatabase, alias);
  }
}

class CleaningRecord extends DataClass implements Insertable<CleaningRecord> {
  final int id;
  final String plate;

  /// 'interior' | 'exterior' | 'interior_exterior' | 'full'
  final String serviceType;

  /// Base price before surcharges/discounts (from settings at time of service)
  final double baseCost;

  /// Final amount actually charged
  final double finalCost;

  /// Discount percentage applied (0.0 = no discount)
  final double discountPercent;
  final bool isLargeVehicle;

  /// True if the car was inside the parking lot at time of cleaning
  final bool wasParkingCar;

  /// 'cleaning' = in progress / not yet paid | 'cleaned' = completed and paid
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? completedAt;
  const CleaningRecord({
    required this.id,
    required this.plate,
    required this.serviceType,
    required this.baseCost,
    required this.finalCost,
    required this.discountPercent,
    required this.isLargeVehicle,
    required this.wasParkingCar,
    required this.status,
    this.notes,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plate'] = Variable<String>(plate);
    map['service_type'] = Variable<String>(serviceType);
    map['base_cost'] = Variable<double>(baseCost);
    map['final_cost'] = Variable<double>(finalCost);
    map['discount_percent'] = Variable<double>(discountPercent);
    map['is_large_vehicle'] = Variable<bool>(isLargeVehicle);
    map['was_parking_car'] = Variable<bool>(wasParkingCar);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  CleaningRecordsCompanion toCompanion(bool nullToAbsent) {
    return CleaningRecordsCompanion(
      id: Value(id),
      plate: Value(plate),
      serviceType: Value(serviceType),
      baseCost: Value(baseCost),
      finalCost: Value(finalCost),
      discountPercent: Value(discountPercent),
      isLargeVehicle: Value(isLargeVehicle),
      wasParkingCar: Value(wasParkingCar),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory CleaningRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CleaningRecord(
      id: serializer.fromJson<int>(json['id']),
      plate: serializer.fromJson<String>(json['plate']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      baseCost: serializer.fromJson<double>(json['baseCost']),
      finalCost: serializer.fromJson<double>(json['finalCost']),
      discountPercent: serializer.fromJson<double>(json['discountPercent']),
      isLargeVehicle: serializer.fromJson<bool>(json['isLargeVehicle']),
      wasParkingCar: serializer.fromJson<bool>(json['wasParkingCar']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plate': serializer.toJson<String>(plate),
      'serviceType': serializer.toJson<String>(serviceType),
      'baseCost': serializer.toJson<double>(baseCost),
      'finalCost': serializer.toJson<double>(finalCost),
      'discountPercent': serializer.toJson<double>(discountPercent),
      'isLargeVehicle': serializer.toJson<bool>(isLargeVehicle),
      'wasParkingCar': serializer.toJson<bool>(wasParkingCar),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  CleaningRecord copyWith({
    int? id,
    String? plate,
    String? serviceType,
    double? baseCost,
    double? finalCost,
    double? discountPercent,
    bool? isLargeVehicle,
    bool? wasParkingCar,
    String? status,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => CleaningRecord(
    id: id ?? this.id,
    plate: plate ?? this.plate,
    serviceType: serviceType ?? this.serviceType,
    baseCost: baseCost ?? this.baseCost,
    finalCost: finalCost ?? this.finalCost,
    discountPercent: discountPercent ?? this.discountPercent,
    isLargeVehicle: isLargeVehicle ?? this.isLargeVehicle,
    wasParkingCar: wasParkingCar ?? this.wasParkingCar,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  CleaningRecord copyWithCompanion(CleaningRecordsCompanion data) {
    return CleaningRecord(
      id: data.id.present ? data.id.value : this.id,
      plate: data.plate.present ? data.plate.value : this.plate,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      baseCost: data.baseCost.present ? data.baseCost.value : this.baseCost,
      finalCost: data.finalCost.present ? data.finalCost.value : this.finalCost,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      isLargeVehicle: data.isLargeVehicle.present
          ? data.isLargeVehicle.value
          : this.isLargeVehicle,
      wasParkingCar: data.wasParkingCar.present
          ? data.wasParkingCar.value
          : this.wasParkingCar,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CleaningRecord(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('serviceType: $serviceType, ')
          ..write('baseCost: $baseCost, ')
          ..write('finalCost: $finalCost, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('isLargeVehicle: $isLargeVehicle, ')
          ..write('wasParkingCar: $wasParkingCar, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    plate,
    serviceType,
    baseCost,
    finalCost,
    discountPercent,
    isLargeVehicle,
    wasParkingCar,
    status,
    notes,
    createdAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CleaningRecord &&
          other.id == this.id &&
          other.plate == this.plate &&
          other.serviceType == this.serviceType &&
          other.baseCost == this.baseCost &&
          other.finalCost == this.finalCost &&
          other.discountPercent == this.discountPercent &&
          other.isLargeVehicle == this.isLargeVehicle &&
          other.wasParkingCar == this.wasParkingCar &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class CleaningRecordsCompanion extends UpdateCompanion<CleaningRecord> {
  final Value<int> id;
  final Value<String> plate;
  final Value<String> serviceType;
  final Value<double> baseCost;
  final Value<double> finalCost;
  final Value<double> discountPercent;
  final Value<bool> isLargeVehicle;
  final Value<bool> wasParkingCar;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  const CleaningRecordsCompanion({
    this.id = const Value.absent(),
    this.plate = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.baseCost = const Value.absent(),
    this.finalCost = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.isLargeVehicle = const Value.absent(),
    this.wasParkingCar = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  CleaningRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String plate,
    required String serviceType,
    required double baseCost,
    required double finalCost,
    this.discountPercent = const Value.absent(),
    this.isLargeVehicle = const Value.absent(),
    this.wasParkingCar = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
  }) : plate = Value(plate),
       serviceType = Value(serviceType),
       baseCost = Value(baseCost),
       finalCost = Value(finalCost),
       createdAt = Value(createdAt);
  static Insertable<CleaningRecord> custom({
    Expression<int>? id,
    Expression<String>? plate,
    Expression<String>? serviceType,
    Expression<double>? baseCost,
    Expression<double>? finalCost,
    Expression<double>? discountPercent,
    Expression<bool>? isLargeVehicle,
    Expression<bool>? wasParkingCar,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plate != null) 'plate': plate,
      if (serviceType != null) 'service_type': serviceType,
      if (baseCost != null) 'base_cost': baseCost,
      if (finalCost != null) 'final_cost': finalCost,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (isLargeVehicle != null) 'is_large_vehicle': isLargeVehicle,
      if (wasParkingCar != null) 'was_parking_car': wasParkingCar,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  CleaningRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? plate,
    Value<String>? serviceType,
    Value<double>? baseCost,
    Value<double>? finalCost,
    Value<double>? discountPercent,
    Value<bool>? isLargeVehicle,
    Value<bool>? wasParkingCar,
    Value<String>? status,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
  }) {
    return CleaningRecordsCompanion(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      serviceType: serviceType ?? this.serviceType,
      baseCost: baseCost ?? this.baseCost,
      finalCost: finalCost ?? this.finalCost,
      discountPercent: discountPercent ?? this.discountPercent,
      isLargeVehicle: isLargeVehicle ?? this.isLargeVehicle,
      wasParkingCar: wasParkingCar ?? this.wasParkingCar,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
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
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (baseCost.present) {
      map['base_cost'] = Variable<double>(baseCost.value);
    }
    if (finalCost.present) {
      map['final_cost'] = Variable<double>(finalCost.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<double>(discountPercent.value);
    }
    if (isLargeVehicle.present) {
      map['is_large_vehicle'] = Variable<bool>(isLargeVehicle.value);
    }
    if (wasParkingCar.present) {
      map['was_parking_car'] = Variable<bool>(wasParkingCar.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CleaningRecordsCompanion(')
          ..write('id: $id, ')
          ..write('plate: $plate, ')
          ..write('serviceType: $serviceType, ')
          ..write('baseCost: $baseCost, ')
          ..write('finalCost: $finalCost, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('isLargeVehicle: $isLargeVehicle, ')
          ..write('wasParkingCar: $wasParkingCar, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
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
  late final $LargeVehiclePlatesTable largeVehiclePlates =
      $LargeVehiclePlatesTable(this);
  late final $RegisteredVehiclesTable registeredVehicles =
      $RegisteredVehiclesTable(this);
  late final $CleaningRecordsTable cleaningRecords = $CleaningRecordsTable(
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
    largeVehiclePlates,
    registeredVehicles,
    cleaningRecords,
  ];
}

typedef $$TariffsTableCreateCompanionBuilder =
    TariffsCompanion Function({
      Value<int> id,
      required String name,
      required String bracketsJson,
      required double fullDayPrice,
      required double monthlyPrice,
      Value<double> dailySubscriptionPrice,
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
      Value<double> dailySubscriptionPrice,
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

  ColumnFilters<double> get dailySubscriptionPrice => $composableBuilder(
    column: $table.dailySubscriptionPrice,
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

  ColumnOrderings<double> get dailySubscriptionPrice => $composableBuilder(
    column: $table.dailySubscriptionPrice,
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

  GeneratedColumn<double> get dailySubscriptionPrice => $composableBuilder(
    column: $table.dailySubscriptionPrice,
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
                Value<double> dailySubscriptionPrice = const Value.absent(),
                Value<DateTime> validFrom = const Value.absent(),
                Value<DateTime?> validTo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TariffsCompanion(
                id: id,
                name: name,
                bracketsJson: bracketsJson,
                fullDayPrice: fullDayPrice,
                monthlyPrice: monthlyPrice,
                dailySubscriptionPrice: dailySubscriptionPrice,
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
                Value<double> dailySubscriptionPrice = const Value.absent(),
                required DateTime validFrom,
                Value<DateTime?> validTo = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TariffsCompanion.insert(
                id: id,
                name: name,
                bracketsJson: bracketsJson,
                fullDayPrice: fullDayPrice,
                monthlyPrice: monthlyPrice,
                dailySubscriptionPrice: dailySubscriptionPrice,
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
      Value<bool> isLargeVehicle,
      Value<bool> isDailySubscriber,
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
      Value<bool> isLargeVehicle,
      Value<bool> isDailySubscriber,
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

  ColumnFilters<bool> get isLargeVehicle => $composableBuilder(
    column: $table.isLargeVehicle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDailySubscriber => $composableBuilder(
    column: $table.isDailySubscriber,
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

  ColumnOrderings<bool> get isLargeVehicle => $composableBuilder(
    column: $table.isLargeVehicle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDailySubscriber => $composableBuilder(
    column: $table.isDailySubscriber,
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

  GeneratedColumn<bool> get isLargeVehicle => $composableBuilder(
    column: $table.isLargeVehicle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDailySubscriber => $composableBuilder(
    column: $table.isDailySubscriber,
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
                Value<bool> isLargeVehicle = const Value.absent(),
                Value<bool> isDailySubscriber = const Value.absent(),
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
                isLargeVehicle: isLargeVehicle,
                isDailySubscriber: isDailySubscriber,
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
                Value<bool> isLargeVehicle = const Value.absent(),
                Value<bool> isDailySubscriber = const Value.absent(),
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
                isLargeVehicle: isLargeVehicle,
                isDailySubscriber: isDailySubscriber,
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
      Value<String> subscriberType,
      Value<double?> dailyFee,
      Value<DateTime?> feePaidUntil,
      Value<DateTime?> paymentSnoozedUntil,
    });
typedef $$SubscribersTableUpdateCompanionBuilder =
    SubscribersCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<double> monthlyFee,
      Value<bool> isActive,
      Value<String> subscriberType,
      Value<double?> dailyFee,
      Value<DateTime?> feePaidUntil,
      Value<DateTime?> paymentSnoozedUntil,
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

  ColumnFilters<String> get subscriberType => $composableBuilder(
    column: $table.subscriberType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyFee => $composableBuilder(
    column: $table.dailyFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get feePaidUntil => $composableBuilder(
    column: $table.feePaidUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paymentSnoozedUntil => $composableBuilder(
    column: $table.paymentSnoozedUntil,
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

  ColumnOrderings<String> get subscriberType => $composableBuilder(
    column: $table.subscriberType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyFee => $composableBuilder(
    column: $table.dailyFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get feePaidUntil => $composableBuilder(
    column: $table.feePaidUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentSnoozedUntil => $composableBuilder(
    column: $table.paymentSnoozedUntil,
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

  GeneratedColumn<String> get subscriberType => $composableBuilder(
    column: $table.subscriberType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dailyFee =>
      $composableBuilder(column: $table.dailyFee, builder: (column) => column);

  GeneratedColumn<DateTime> get feePaidUntil => $composableBuilder(
    column: $table.feePaidUntil,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get paymentSnoozedUntil => $composableBuilder(
    column: $table.paymentSnoozedUntil,
    builder: (column) => column,
  );

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
                Value<String> subscriberType = const Value.absent(),
                Value<double?> dailyFee = const Value.absent(),
                Value<DateTime?> feePaidUntil = const Value.absent(),
                Value<DateTime?> paymentSnoozedUntil = const Value.absent(),
              }) => SubscribersCompanion(
                id: id,
                notes: notes,
                startDate: startDate,
                endDate: endDate,
                monthlyFee: monthlyFee,
                isActive: isActive,
                subscriberType: subscriberType,
                dailyFee: dailyFee,
                feePaidUntil: feePaidUntil,
                paymentSnoozedUntil: paymentSnoozedUntil,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required double monthlyFee,
                Value<bool> isActive = const Value.absent(),
                Value<String> subscriberType = const Value.absent(),
                Value<double?> dailyFee = const Value.absent(),
                Value<DateTime?> feePaidUntil = const Value.absent(),
                Value<DateTime?> paymentSnoozedUntil = const Value.absent(),
              }) => SubscribersCompanion.insert(
                id: id,
                notes: notes,
                startDate: startDate,
                endDate: endDate,
                monthlyFee: monthlyFee,
                isActive: isActive,
                subscriberType: subscriberType,
                dailyFee: dailyFee,
                feePaidUntil: feePaidUntil,
                paymentSnoozedUntil: paymentSnoozedUntil,
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
typedef $$LargeVehiclePlatesTableCreateCompanionBuilder =
    LargeVehiclePlatesCompanion Function({
      Value<int> id,
      required String plate,
    });
typedef $$LargeVehiclePlatesTableUpdateCompanionBuilder =
    LargeVehiclePlatesCompanion Function({Value<int> id, Value<String> plate});

class $$LargeVehiclePlatesTableFilterComposer
    extends Composer<_$AppDatabase, $LargeVehiclePlatesTable> {
  $$LargeVehiclePlatesTableFilterComposer({
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
}

class $$LargeVehiclePlatesTableOrderingComposer
    extends Composer<_$AppDatabase, $LargeVehiclePlatesTable> {
  $$LargeVehiclePlatesTableOrderingComposer({
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
}

class $$LargeVehiclePlatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LargeVehiclePlatesTable> {
  $$LargeVehiclePlatesTableAnnotationComposer({
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
}

class $$LargeVehiclePlatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LargeVehiclePlatesTable,
          LargeVehiclePlate,
          $$LargeVehiclePlatesTableFilterComposer,
          $$LargeVehiclePlatesTableOrderingComposer,
          $$LargeVehiclePlatesTableAnnotationComposer,
          $$LargeVehiclePlatesTableCreateCompanionBuilder,
          $$LargeVehiclePlatesTableUpdateCompanionBuilder,
          (
            LargeVehiclePlate,
            BaseReferences<
              _$AppDatabase,
              $LargeVehiclePlatesTable,
              LargeVehiclePlate
            >,
          ),
          LargeVehiclePlate,
          PrefetchHooks Function()
        > {
  $$LargeVehiclePlatesTableTableManager(
    _$AppDatabase db,
    $LargeVehiclePlatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LargeVehiclePlatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LargeVehiclePlatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LargeVehiclePlatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> plate = const Value.absent(),
              }) => LargeVehiclePlatesCompanion(id: id, plate: plate),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String plate}) =>
                  LargeVehiclePlatesCompanion.insert(id: id, plate: plate),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LargeVehiclePlatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LargeVehiclePlatesTable,
      LargeVehiclePlate,
      $$LargeVehiclePlatesTableFilterComposer,
      $$LargeVehiclePlatesTableOrderingComposer,
      $$LargeVehiclePlatesTableAnnotationComposer,
      $$LargeVehiclePlatesTableCreateCompanionBuilder,
      $$LargeVehiclePlatesTableUpdateCompanionBuilder,
      (
        LargeVehiclePlate,
        BaseReferences<
          _$AppDatabase,
          $LargeVehiclePlatesTable,
          LargeVehiclePlate
        >,
      ),
      LargeVehiclePlate,
      PrefetchHooks Function()
    >;
typedef $$RegisteredVehiclesTableCreateCompanionBuilder =
    RegisteredVehiclesCompanion Function({
      Value<int> id,
      required String plate,
      Value<String> vehicleType,
      Value<String> subscriptionType,
      Value<DateTime?> subscriptionStartDate,
      Value<DateTime?> subscriptionEndDate,
      Value<double> dailyFee,
      Value<double> monthlyFee,
      Value<String?> notes,
      required DateTime createdAt,
    });
typedef $$RegisteredVehiclesTableUpdateCompanionBuilder =
    RegisteredVehiclesCompanion Function({
      Value<int> id,
      Value<String> plate,
      Value<String> vehicleType,
      Value<String> subscriptionType,
      Value<DateTime?> subscriptionStartDate,
      Value<DateTime?> subscriptionEndDate,
      Value<double> dailyFee,
      Value<double> monthlyFee,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

class $$RegisteredVehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $RegisteredVehiclesTable> {
  $$RegisteredVehiclesTableFilterComposer({
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

  ColumnFilters<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionType => $composableBuilder(
    column: $table.subscriptionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get subscriptionStartDate => $composableBuilder(
    column: $table.subscriptionStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get subscriptionEndDate => $composableBuilder(
    column: $table.subscriptionEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyFee => $composableBuilder(
    column: $table.dailyFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyFee => $composableBuilder(
    column: $table.monthlyFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegisteredVehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $RegisteredVehiclesTable> {
  $$RegisteredVehiclesTableOrderingComposer({
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

  ColumnOrderings<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionType => $composableBuilder(
    column: $table.subscriptionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get subscriptionStartDate => $composableBuilder(
    column: $table.subscriptionStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get subscriptionEndDate => $composableBuilder(
    column: $table.subscriptionEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyFee => $composableBuilder(
    column: $table.dailyFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyFee => $composableBuilder(
    column: $table.monthlyFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegisteredVehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RegisteredVehiclesTable> {
  $$RegisteredVehiclesTableAnnotationComposer({
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

  GeneratedColumn<String> get vehicleType => $composableBuilder(
    column: $table.vehicleType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subscriptionType => $composableBuilder(
    column: $table.subscriptionType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get subscriptionStartDate => $composableBuilder(
    column: $table.subscriptionStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get subscriptionEndDate => $composableBuilder(
    column: $table.subscriptionEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dailyFee =>
      $composableBuilder(column: $table.dailyFee, builder: (column) => column);

  GeneratedColumn<double> get monthlyFee => $composableBuilder(
    column: $table.monthlyFee,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RegisteredVehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RegisteredVehiclesTable,
          RegisteredVehicle,
          $$RegisteredVehiclesTableFilterComposer,
          $$RegisteredVehiclesTableOrderingComposer,
          $$RegisteredVehiclesTableAnnotationComposer,
          $$RegisteredVehiclesTableCreateCompanionBuilder,
          $$RegisteredVehiclesTableUpdateCompanionBuilder,
          (
            RegisteredVehicle,
            BaseReferences<
              _$AppDatabase,
              $RegisteredVehiclesTable,
              RegisteredVehicle
            >,
          ),
          RegisteredVehicle,
          PrefetchHooks Function()
        > {
  $$RegisteredVehiclesTableTableManager(
    _$AppDatabase db,
    $RegisteredVehiclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegisteredVehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegisteredVehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegisteredVehiclesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<String> vehicleType = const Value.absent(),
                Value<String> subscriptionType = const Value.absent(),
                Value<DateTime?> subscriptionStartDate = const Value.absent(),
                Value<DateTime?> subscriptionEndDate = const Value.absent(),
                Value<double> dailyFee = const Value.absent(),
                Value<double> monthlyFee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => RegisteredVehiclesCompanion(
                id: id,
                plate: plate,
                vehicleType: vehicleType,
                subscriptionType: subscriptionType,
                subscriptionStartDate: subscriptionStartDate,
                subscriptionEndDate: subscriptionEndDate,
                dailyFee: dailyFee,
                monthlyFee: monthlyFee,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String plate,
                Value<String> vehicleType = const Value.absent(),
                Value<String> subscriptionType = const Value.absent(),
                Value<DateTime?> subscriptionStartDate = const Value.absent(),
                Value<DateTime?> subscriptionEndDate = const Value.absent(),
                Value<double> dailyFee = const Value.absent(),
                Value<double> monthlyFee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
              }) => RegisteredVehiclesCompanion.insert(
                id: id,
                plate: plate,
                vehicleType: vehicleType,
                subscriptionType: subscriptionType,
                subscriptionStartDate: subscriptionStartDate,
                subscriptionEndDate: subscriptionEndDate,
                dailyFee: dailyFee,
                monthlyFee: monthlyFee,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegisteredVehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RegisteredVehiclesTable,
      RegisteredVehicle,
      $$RegisteredVehiclesTableFilterComposer,
      $$RegisteredVehiclesTableOrderingComposer,
      $$RegisteredVehiclesTableAnnotationComposer,
      $$RegisteredVehiclesTableCreateCompanionBuilder,
      $$RegisteredVehiclesTableUpdateCompanionBuilder,
      (
        RegisteredVehicle,
        BaseReferences<
          _$AppDatabase,
          $RegisteredVehiclesTable,
          RegisteredVehicle
        >,
      ),
      RegisteredVehicle,
      PrefetchHooks Function()
    >;
typedef $$CleaningRecordsTableCreateCompanionBuilder =
    CleaningRecordsCompanion Function({
      Value<int> id,
      required String plate,
      required String serviceType,
      required double baseCost,
      required double finalCost,
      Value<double> discountPercent,
      Value<bool> isLargeVehicle,
      Value<bool> wasParkingCar,
      Value<String> status,
      Value<String?> notes,
      required DateTime createdAt,
      Value<DateTime?> completedAt,
    });
typedef $$CleaningRecordsTableUpdateCompanionBuilder =
    CleaningRecordsCompanion Function({
      Value<int> id,
      Value<String> plate,
      Value<String> serviceType,
      Value<double> baseCost,
      Value<double> finalCost,
      Value<double> discountPercent,
      Value<bool> isLargeVehicle,
      Value<bool> wasParkingCar,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
    });

class $$CleaningRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $CleaningRecordsTable> {
  $$CleaningRecordsTableFilterComposer({
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

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baseCost => $composableBuilder(
    column: $table.baseCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalCost => $composableBuilder(
    column: $table.finalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLargeVehicle => $composableBuilder(
    column: $table.isLargeVehicle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasParkingCar => $composableBuilder(
    column: $table.wasParkingCar,
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CleaningRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $CleaningRecordsTable> {
  $$CleaningRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baseCost => $composableBuilder(
    column: $table.baseCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalCost => $composableBuilder(
    column: $table.finalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLargeVehicle => $composableBuilder(
    column: $table.isLargeVehicle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasParkingCar => $composableBuilder(
    column: $table.wasParkingCar,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CleaningRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CleaningRecordsTable> {
  $$CleaningRecordsTableAnnotationComposer({
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

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get baseCost =>
      $composableBuilder(column: $table.baseCost, builder: (column) => column);

  GeneratedColumn<double> get finalCost =>
      $composableBuilder(column: $table.finalCost, builder: (column) => column);

  GeneratedColumn<double> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLargeVehicle => $composableBuilder(
    column: $table.isLargeVehicle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wasParkingCar => $composableBuilder(
    column: $table.wasParkingCar,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$CleaningRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CleaningRecordsTable,
          CleaningRecord,
          $$CleaningRecordsTableFilterComposer,
          $$CleaningRecordsTableOrderingComposer,
          $$CleaningRecordsTableAnnotationComposer,
          $$CleaningRecordsTableCreateCompanionBuilder,
          $$CleaningRecordsTableUpdateCompanionBuilder,
          (
            CleaningRecord,
            BaseReferences<
              _$AppDatabase,
              $CleaningRecordsTable,
              CleaningRecord
            >,
          ),
          CleaningRecord,
          PrefetchHooks Function()
        > {
  $$CleaningRecordsTableTableManager(
    _$AppDatabase db,
    $CleaningRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CleaningRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CleaningRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CleaningRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> plate = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<double> baseCost = const Value.absent(),
                Value<double> finalCost = const Value.absent(),
                Value<double> discountPercent = const Value.absent(),
                Value<bool> isLargeVehicle = const Value.absent(),
                Value<bool> wasParkingCar = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => CleaningRecordsCompanion(
                id: id,
                plate: plate,
                serviceType: serviceType,
                baseCost: baseCost,
                finalCost: finalCost,
                discountPercent: discountPercent,
                isLargeVehicle: isLargeVehicle,
                wasParkingCar: wasParkingCar,
                status: status,
                notes: notes,
                createdAt: createdAt,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String plate,
                required String serviceType,
                required double baseCost,
                required double finalCost,
                Value<double> discountPercent = const Value.absent(),
                Value<bool> isLargeVehicle = const Value.absent(),
                Value<bool> wasParkingCar = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
              }) => CleaningRecordsCompanion.insert(
                id: id,
                plate: plate,
                serviceType: serviceType,
                baseCost: baseCost,
                finalCost: finalCost,
                discountPercent: discountPercent,
                isLargeVehicle: isLargeVehicle,
                wasParkingCar: wasParkingCar,
                status: status,
                notes: notes,
                createdAt: createdAt,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CleaningRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CleaningRecordsTable,
      CleaningRecord,
      $$CleaningRecordsTableFilterComposer,
      $$CleaningRecordsTableOrderingComposer,
      $$CleaningRecordsTableAnnotationComposer,
      $$CleaningRecordsTableCreateCompanionBuilder,
      $$CleaningRecordsTableUpdateCompanionBuilder,
      (
        CleaningRecord,
        BaseReferences<_$AppDatabase, $CleaningRecordsTable, CleaningRecord>,
      ),
      CleaningRecord,
      PrefetchHooks Function()
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
  $$LargeVehiclePlatesTableTableManager get largeVehiclePlates =>
      $$LargeVehiclePlatesTableTableManager(_db, _db.largeVehiclePlates);
  $$RegisteredVehiclesTableTableManager get registeredVehicles =>
      $$RegisteredVehiclesTableTableManager(_db, _db.registeredVehicles);
  $$CleaningRecordsTableTableManager get cleaningRecords =>
      $$CleaningRecordsTableTableManager(_db, _db.cleaningRecords);
}
