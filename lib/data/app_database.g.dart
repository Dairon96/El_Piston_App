// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _direccionMeta =
      const VerificationMeta('direccion');
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
      'direccion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, nombre, telefono, direccion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(Insertable<Cliente> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(_direccionMeta,
          direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono'])!,
      direccion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direccion']),
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String nombre;
  final String telefono;
  final String? direccion;
  const Cliente(
      {required this.id,
      required this.nombre,
      required this.telefono,
      this.direccion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['telefono'] = Variable<String>(telefono);
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: Value(telefono),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
    );
  }

  factory Cliente.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String>(json['telefono']),
      direccion: serializer.fromJson<String?>(json['direccion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String>(telefono),
      'direccion': serializer.toJson<String?>(direccion),
    };
  }

  Cliente copyWith(
          {int? id,
          String? nombre,
          String? telefono,
          Value<String?> direccion = const Value.absent()}) =>
      Cliente(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        telefono: telefono ?? this.telefono,
        direccion: direccion.present ? direccion.value : this.direccion,
      );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('direccion: $direccion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, telefono, direccion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.direccion == this.direccion);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> telefono;
  final Value<String?> direccion;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.direccion = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String telefono,
    this.direccion = const Value.absent(),
  })  : nombre = Value(nombre),
        telefono = Value(telefono);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<String>? direccion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (direccion != null) 'direccion': direccion,
    });
  }

  ClientesCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String>? telefono,
      Value<String?>? direccion}) {
    return ClientesCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('direccion: $direccion')
          ..write(')'))
        .toString();
  }
}

class $VehiculosTable extends Vehiculos
    with TableInfo<$VehiculosTable, Vehiculo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiculosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _clienteIdMeta =
      const VerificationMeta('clienteId');
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
      'cliente_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clientes (id)'));
  static const VerificationMeta _matriculaMeta =
      const VerificationMeta('matricula');
  @override
  late final GeneratedColumn<String> matricula = GeneratedColumn<String>(
      'matricula', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 15),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _marcaMeta = const VerificationMeta('marca');
  @override
  late final GeneratedColumn<String> marca = GeneratedColumn<String>(
      'marca', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _modeloMeta = const VerificationMeta('modelo');
  @override
  late final GeneratedColumn<String> modelo = GeneratedColumn<String>(
      'modelo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _anioMeta = const VerificationMeta('anio');
  @override
  late final GeneratedColumn<int> anio = GeneratedColumn<int>(
      'anio', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _kilometrajeMeta =
      const VerificationMeta('kilometraje');
  @override
  late final GeneratedColumn<int> kilometraje = GeneratedColumn<int>(
      'kilometraje', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, clienteId, matricula, marca, modelo, anio, kilometraje];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehiculos';
  @override
  VerificationContext validateIntegrity(Insertable<Vehiculo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(_clienteIdMeta,
          clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta));
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('matricula')) {
      context.handle(_matriculaMeta,
          matricula.isAcceptableOrUnknown(data['matricula']!, _matriculaMeta));
    } else if (isInserting) {
      context.missing(_matriculaMeta);
    }
    if (data.containsKey('marca')) {
      context.handle(
          _marcaMeta, marca.isAcceptableOrUnknown(data['marca']!, _marcaMeta));
    } else if (isInserting) {
      context.missing(_marcaMeta);
    }
    if (data.containsKey('modelo')) {
      context.handle(_modeloMeta,
          modelo.isAcceptableOrUnknown(data['modelo']!, _modeloMeta));
    } else if (isInserting) {
      context.missing(_modeloMeta);
    }
    if (data.containsKey('anio')) {
      context.handle(
          _anioMeta, anio.isAcceptableOrUnknown(data['anio']!, _anioMeta));
    } else if (isInserting) {
      context.missing(_anioMeta);
    }
    if (data.containsKey('kilometraje')) {
      context.handle(
          _kilometrajeMeta,
          kilometraje.isAcceptableOrUnknown(
              data['kilometraje']!, _kilometrajeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehiculo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehiculo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      clienteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cliente_id'])!,
      matricula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}matricula'])!,
      marca: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}marca'])!,
      modelo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modelo'])!,
      anio: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anio'])!,
      kilometraje: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}kilometraje'])!,
    );
  }

  @override
  $VehiculosTable createAlias(String alias) {
    return $VehiculosTable(attachedDatabase, alias);
  }
}

class Vehiculo extends DataClass implements Insertable<Vehiculo> {
  final int id;
  final int clienteId;
  final String matricula;
  final String marca;
  final String modelo;
  final int anio;
  final int kilometraje;
  const Vehiculo(
      {required this.id,
      required this.clienteId,
      required this.matricula,
      required this.marca,
      required this.modelo,
      required this.anio,
      required this.kilometraje});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    map['matricula'] = Variable<String>(matricula);
    map['marca'] = Variable<String>(marca);
    map['modelo'] = Variable<String>(modelo);
    map['anio'] = Variable<int>(anio);
    map['kilometraje'] = Variable<int>(kilometraje);
    return map;
  }

  VehiculosCompanion toCompanion(bool nullToAbsent) {
    return VehiculosCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      matricula: Value(matricula),
      marca: Value(marca),
      modelo: Value(modelo),
      anio: Value(anio),
      kilometraje: Value(kilometraje),
    );
  }

  factory Vehiculo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehiculo(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
      matricula: serializer.fromJson<String>(json['matricula']),
      marca: serializer.fromJson<String>(json['marca']),
      modelo: serializer.fromJson<String>(json['modelo']),
      anio: serializer.fromJson<int>(json['anio']),
      kilometraje: serializer.fromJson<int>(json['kilometraje']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clienteId': serializer.toJson<int>(clienteId),
      'matricula': serializer.toJson<String>(matricula),
      'marca': serializer.toJson<String>(marca),
      'modelo': serializer.toJson<String>(modelo),
      'anio': serializer.toJson<int>(anio),
      'kilometraje': serializer.toJson<int>(kilometraje),
    };
  }

  Vehiculo copyWith(
          {int? id,
          int? clienteId,
          String? matricula,
          String? marca,
          String? modelo,
          int? anio,
          int? kilometraje}) =>
      Vehiculo(
        id: id ?? this.id,
        clienteId: clienteId ?? this.clienteId,
        matricula: matricula ?? this.matricula,
        marca: marca ?? this.marca,
        modelo: modelo ?? this.modelo,
        anio: anio ?? this.anio,
        kilometraje: kilometraje ?? this.kilometraje,
      );
  Vehiculo copyWithCompanion(VehiculosCompanion data) {
    return Vehiculo(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      matricula: data.matricula.present ? data.matricula.value : this.matricula,
      marca: data.marca.present ? data.marca.value : this.marca,
      modelo: data.modelo.present ? data.modelo.value : this.modelo,
      anio: data.anio.present ? data.anio.value : this.anio,
      kilometraje:
          data.kilometraje.present ? data.kilometraje.value : this.kilometraje,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehiculo(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('matricula: $matricula, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('anio: $anio, ')
          ..write('kilometraje: $kilometraje')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, clienteId, matricula, marca, modelo, anio, kilometraje);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehiculo &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.matricula == this.matricula &&
          other.marca == this.marca &&
          other.modelo == this.modelo &&
          other.anio == this.anio &&
          other.kilometraje == this.kilometraje);
}

class VehiculosCompanion extends UpdateCompanion<Vehiculo> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<String> matricula;
  final Value<String> marca;
  final Value<String> modelo;
  final Value<int> anio;
  final Value<int> kilometraje;
  const VehiculosCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.matricula = const Value.absent(),
    this.marca = const Value.absent(),
    this.modelo = const Value.absent(),
    this.anio = const Value.absent(),
    this.kilometraje = const Value.absent(),
  });
  VehiculosCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    required String matricula,
    required String marca,
    required String modelo,
    required int anio,
    this.kilometraje = const Value.absent(),
  })  : clienteId = Value(clienteId),
        matricula = Value(matricula),
        marca = Value(marca),
        modelo = Value(modelo),
        anio = Value(anio);
  static Insertable<Vehiculo> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<String>? matricula,
    Expression<String>? marca,
    Expression<String>? modelo,
    Expression<int>? anio,
    Expression<int>? kilometraje,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (matricula != null) 'matricula': matricula,
      if (marca != null) 'marca': marca,
      if (modelo != null) 'modelo': modelo,
      if (anio != null) 'anio': anio,
      if (kilometraje != null) 'kilometraje': kilometraje,
    });
  }

  VehiculosCompanion copyWith(
      {Value<int>? id,
      Value<int>? clienteId,
      Value<String>? matricula,
      Value<String>? marca,
      Value<String>? modelo,
      Value<int>? anio,
      Value<int>? kilometraje}) {
    return VehiculosCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      matricula: matricula ?? this.matricula,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      kilometraje: kilometraje ?? this.kilometraje,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (matricula.present) {
      map['matricula'] = Variable<String>(matricula.value);
    }
    if (marca.present) {
      map['marca'] = Variable<String>(marca.value);
    }
    if (modelo.present) {
      map['modelo'] = Variable<String>(modelo.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
    }
    if (kilometraje.present) {
      map['kilometraje'] = Variable<int>(kilometraje.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiculosCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('matricula: $matricula, ')
          ..write('marca: $marca, ')
          ..write('modelo: $modelo, ')
          ..write('anio: $anio, ')
          ..write('kilometraje: $kilometraje')
          ..write(')'))
        .toString();
  }
}

class $MecanicosTable extends Mecanicos
    with TableInfo<$MecanicosTable, Mecanico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MecanicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, nombre, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mecanicos';
  @override
  VerificationContext validateIntegrity(Insertable<Mecanico> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mecanico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mecanico(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $MecanicosTable createAlias(String alias) {
    return $MecanicosTable(attachedDatabase, alias);
  }
}

class Mecanico extends DataClass implements Insertable<Mecanico> {
  final int id;
  final String nombre;
  final bool activo;
  const Mecanico(
      {required this.id, required this.nombre, required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  MecanicosCompanion toCompanion(bool nullToAbsent) {
    return MecanicosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      activo: Value(activo),
    );
  }

  factory Mecanico.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mecanico(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Mecanico copyWith({int? id, String? nombre, bool? activo}) => Mecanico(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        activo: activo ?? this.activo,
      );
  Mecanico copyWithCompanion(MecanicosCompanion data) {
    return Mecanico(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mecanico(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mecanico &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.activo == this.activo);
}

class MecanicosCompanion extends UpdateCompanion<Mecanico> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<bool> activo;
  const MecanicosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.activo = const Value.absent(),
  });
  MecanicosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<Mecanico> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (activo != null) 'activo': activo,
    });
  }

  MecanicosCompanion copyWith(
      {Value<int>? id, Value<String>? nombre, Value<bool>? activo}) {
    return MecanicosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MecanicosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $OrdenesServicioTable extends OrdenesServicio
    with TableInfo<$OrdenesServicioTable, OrdenServicio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdenesServicioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _vehiculoIdMeta =
      const VerificationMeta('vehiculoId');
  @override
  late final GeneratedColumn<int> vehiculoId = GeneratedColumn<int>(
      'vehiculo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vehiculos (id)'));
  static const VerificationMeta _mecanicoIdMeta =
      const VerificationMeta('mecanicoId');
  @override
  late final GeneratedColumn<int> mecanicoId = GeneratedColumn<int>(
      'mecanico_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES mecanicos (id)'));
  static const VerificationMeta _fechaEntradaMeta =
      const VerificationMeta('fechaEntrada');
  @override
  late final GeneratedColumn<DateTime> fechaEntrada = GeneratedColumn<DateTime>(
      'fecha_entrada', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _problemaMeta =
      const VerificationMeta('problema');
  @override
  late final GeneratedColumn<String> problema = GeneratedColumn<String>(
      'problema', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<EstadoOrden, int> estado =
      GeneratedColumn<int>('estado', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<EstadoOrden>($OrdenesServicioTable.$converterestado);
  static const VerificationMeta _kilometrajeIngresoMeta =
      const VerificationMeta('kilometrajeIngreso');
  @override
  late final GeneratedColumn<int> kilometrajeIngreso = GeneratedColumn<int>(
      'kilometraje_ingreso', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fechaCierreMeta =
      const VerificationMeta('fechaCierre');
  @override
  late final GeneratedColumn<DateTime> fechaCierre = GeneratedColumn<DateTime>(
      'fecha_cierre', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        vehiculoId,
        mecanicoId,
        fechaEntrada,
        problema,
        estado,
        kilometrajeIngreso,
        fechaCierre
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ordenes_servicio';
  @override
  VerificationContext validateIntegrity(Insertable<OrdenServicio> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('vehiculo_id')) {
      context.handle(
          _vehiculoIdMeta,
          vehiculoId.isAcceptableOrUnknown(
              data['vehiculo_id']!, _vehiculoIdMeta));
    } else if (isInserting) {
      context.missing(_vehiculoIdMeta);
    }
    if (data.containsKey('mecanico_id')) {
      context.handle(
          _mecanicoIdMeta,
          mecanicoId.isAcceptableOrUnknown(
              data['mecanico_id']!, _mecanicoIdMeta));
    } else if (isInserting) {
      context.missing(_mecanicoIdMeta);
    }
    if (data.containsKey('fecha_entrada')) {
      context.handle(
          _fechaEntradaMeta,
          fechaEntrada.isAcceptableOrUnknown(
              data['fecha_entrada']!, _fechaEntradaMeta));
    } else if (isInserting) {
      context.missing(_fechaEntradaMeta);
    }
    if (data.containsKey('problema')) {
      context.handle(_problemaMeta,
          problema.isAcceptableOrUnknown(data['problema']!, _problemaMeta));
    } else if (isInserting) {
      context.missing(_problemaMeta);
    }
    if (data.containsKey('kilometraje_ingreso')) {
      context.handle(
          _kilometrajeIngresoMeta,
          kilometrajeIngreso.isAcceptableOrUnknown(
              data['kilometraje_ingreso']!, _kilometrajeIngresoMeta));
    } else if (isInserting) {
      context.missing(_kilometrajeIngresoMeta);
    }
    if (data.containsKey('fecha_cierre')) {
      context.handle(
          _fechaCierreMeta,
          fechaCierre.isAcceptableOrUnknown(
              data['fecha_cierre']!, _fechaCierreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdenServicio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdenServicio(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      vehiculoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vehiculo_id'])!,
      mecanicoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mecanico_id'])!,
      fechaEntrada: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_entrada'])!,
      problema: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}problema'])!,
      estado: $OrdenesServicioTable.$converterestado.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estado'])!),
      kilometrajeIngreso: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}kilometraje_ingreso'])!,
      fechaCierre: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha_cierre']),
    );
  }

  @override
  $OrdenesServicioTable createAlias(String alias) {
    return $OrdenesServicioTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EstadoOrden, int, int> $converterestado =
      const EnumIndexConverter<EstadoOrden>(EstadoOrden.values);
}

class OrdenServicio extends DataClass implements Insertable<OrdenServicio> {
  final int id;
  final int vehiculoId;
  final int mecanicoId;
  final DateTime fechaEntrada;
  final String problema;
  final EstadoOrden estado;
  final int kilometrajeIngreso;
  final DateTime? fechaCierre;
  const OrdenServicio(
      {required this.id,
      required this.vehiculoId,
      required this.mecanicoId,
      required this.fechaEntrada,
      required this.problema,
      required this.estado,
      required this.kilometrajeIngreso,
      this.fechaCierre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['vehiculo_id'] = Variable<int>(vehiculoId);
    map['mecanico_id'] = Variable<int>(mecanicoId);
    map['fecha_entrada'] = Variable<DateTime>(fechaEntrada);
    map['problema'] = Variable<String>(problema);
    {
      map['estado'] =
          Variable<int>($OrdenesServicioTable.$converterestado.toSql(estado));
    }
    map['kilometraje_ingreso'] = Variable<int>(kilometrajeIngreso);
    if (!nullToAbsent || fechaCierre != null) {
      map['fecha_cierre'] = Variable<DateTime>(fechaCierre);
    }
    return map;
  }

  OrdenesServicioCompanion toCompanion(bool nullToAbsent) {
    return OrdenesServicioCompanion(
      id: Value(id),
      vehiculoId: Value(vehiculoId),
      mecanicoId: Value(mecanicoId),
      fechaEntrada: Value(fechaEntrada),
      problema: Value(problema),
      estado: Value(estado),
      kilometrajeIngreso: Value(kilometrajeIngreso),
      fechaCierre: fechaCierre == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCierre),
    );
  }

  factory OrdenServicio.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdenServicio(
      id: serializer.fromJson<int>(json['id']),
      vehiculoId: serializer.fromJson<int>(json['vehiculoId']),
      mecanicoId: serializer.fromJson<int>(json['mecanicoId']),
      fechaEntrada: serializer.fromJson<DateTime>(json['fechaEntrada']),
      problema: serializer.fromJson<String>(json['problema']),
      estado: $OrdenesServicioTable.$converterestado
          .fromJson(serializer.fromJson<int>(json['estado'])),
      kilometrajeIngreso: serializer.fromJson<int>(json['kilometrajeIngreso']),
      fechaCierre: serializer.fromJson<DateTime?>(json['fechaCierre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'vehiculoId': serializer.toJson<int>(vehiculoId),
      'mecanicoId': serializer.toJson<int>(mecanicoId),
      'fechaEntrada': serializer.toJson<DateTime>(fechaEntrada),
      'problema': serializer.toJson<String>(problema),
      'estado': serializer
          .toJson<int>($OrdenesServicioTable.$converterestado.toJson(estado)),
      'kilometrajeIngreso': serializer.toJson<int>(kilometrajeIngreso),
      'fechaCierre': serializer.toJson<DateTime?>(fechaCierre),
    };
  }

  OrdenServicio copyWith(
          {int? id,
          int? vehiculoId,
          int? mecanicoId,
          DateTime? fechaEntrada,
          String? problema,
          EstadoOrden? estado,
          int? kilometrajeIngreso,
          Value<DateTime?> fechaCierre = const Value.absent()}) =>
      OrdenServicio(
        id: id ?? this.id,
        vehiculoId: vehiculoId ?? this.vehiculoId,
        mecanicoId: mecanicoId ?? this.mecanicoId,
        fechaEntrada: fechaEntrada ?? this.fechaEntrada,
        problema: problema ?? this.problema,
        estado: estado ?? this.estado,
        kilometrajeIngreso: kilometrajeIngreso ?? this.kilometrajeIngreso,
        fechaCierre: fechaCierre.present ? fechaCierre.value : this.fechaCierre,
      );
  OrdenServicio copyWithCompanion(OrdenesServicioCompanion data) {
    return OrdenServicio(
      id: data.id.present ? data.id.value : this.id,
      vehiculoId:
          data.vehiculoId.present ? data.vehiculoId.value : this.vehiculoId,
      mecanicoId:
          data.mecanicoId.present ? data.mecanicoId.value : this.mecanicoId,
      fechaEntrada: data.fechaEntrada.present
          ? data.fechaEntrada.value
          : this.fechaEntrada,
      problema: data.problema.present ? data.problema.value : this.problema,
      estado: data.estado.present ? data.estado.value : this.estado,
      kilometrajeIngreso: data.kilometrajeIngreso.present
          ? data.kilometrajeIngreso.value
          : this.kilometrajeIngreso,
      fechaCierre:
          data.fechaCierre.present ? data.fechaCierre.value : this.fechaCierre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdenServicio(')
          ..write('id: $id, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fechaEntrada: $fechaEntrada, ')
          ..write('problema: $problema, ')
          ..write('estado: $estado, ')
          ..write('kilometrajeIngreso: $kilometrajeIngreso, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, vehiculoId, mecanicoId, fechaEntrada,
      problema, estado, kilometrajeIngreso, fechaCierre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdenServicio &&
          other.id == this.id &&
          other.vehiculoId == this.vehiculoId &&
          other.mecanicoId == this.mecanicoId &&
          other.fechaEntrada == this.fechaEntrada &&
          other.problema == this.problema &&
          other.estado == this.estado &&
          other.kilometrajeIngreso == this.kilometrajeIngreso &&
          other.fechaCierre == this.fechaCierre);
}

class OrdenesServicioCompanion extends UpdateCompanion<OrdenServicio> {
  final Value<int> id;
  final Value<int> vehiculoId;
  final Value<int> mecanicoId;
  final Value<DateTime> fechaEntrada;
  final Value<String> problema;
  final Value<EstadoOrden> estado;
  final Value<int> kilometrajeIngreso;
  final Value<DateTime?> fechaCierre;
  const OrdenesServicioCompanion({
    this.id = const Value.absent(),
    this.vehiculoId = const Value.absent(),
    this.mecanicoId = const Value.absent(),
    this.fechaEntrada = const Value.absent(),
    this.problema = const Value.absent(),
    this.estado = const Value.absent(),
    this.kilometrajeIngreso = const Value.absent(),
    this.fechaCierre = const Value.absent(),
  });
  OrdenesServicioCompanion.insert({
    this.id = const Value.absent(),
    required int vehiculoId,
    required int mecanicoId,
    required DateTime fechaEntrada,
    required String problema,
    required EstadoOrden estado,
    required int kilometrajeIngreso,
    this.fechaCierre = const Value.absent(),
  })  : vehiculoId = Value(vehiculoId),
        mecanicoId = Value(mecanicoId),
        fechaEntrada = Value(fechaEntrada),
        problema = Value(problema),
        estado = Value(estado),
        kilometrajeIngreso = Value(kilometrajeIngreso);
  static Insertable<OrdenServicio> custom({
    Expression<int>? id,
    Expression<int>? vehiculoId,
    Expression<int>? mecanicoId,
    Expression<DateTime>? fechaEntrada,
    Expression<String>? problema,
    Expression<int>? estado,
    Expression<int>? kilometrajeIngreso,
    Expression<DateTime>? fechaCierre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (vehiculoId != null) 'vehiculo_id': vehiculoId,
      if (mecanicoId != null) 'mecanico_id': mecanicoId,
      if (fechaEntrada != null) 'fecha_entrada': fechaEntrada,
      if (problema != null) 'problema': problema,
      if (estado != null) 'estado': estado,
      if (kilometrajeIngreso != null) 'kilometraje_ingreso': kilometrajeIngreso,
      if (fechaCierre != null) 'fecha_cierre': fechaCierre,
    });
  }

  OrdenesServicioCompanion copyWith(
      {Value<int>? id,
      Value<int>? vehiculoId,
      Value<int>? mecanicoId,
      Value<DateTime>? fechaEntrada,
      Value<String>? problema,
      Value<EstadoOrden>? estado,
      Value<int>? kilometrajeIngreso,
      Value<DateTime?>? fechaCierre}) {
    return OrdenesServicioCompanion(
      id: id ?? this.id,
      vehiculoId: vehiculoId ?? this.vehiculoId,
      mecanicoId: mecanicoId ?? this.mecanicoId,
      fechaEntrada: fechaEntrada ?? this.fechaEntrada,
      problema: problema ?? this.problema,
      estado: estado ?? this.estado,
      kilometrajeIngreso: kilometrajeIngreso ?? this.kilometrajeIngreso,
      fechaCierre: fechaCierre ?? this.fechaCierre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (vehiculoId.present) {
      map['vehiculo_id'] = Variable<int>(vehiculoId.value);
    }
    if (mecanicoId.present) {
      map['mecanico_id'] = Variable<int>(mecanicoId.value);
    }
    if (fechaEntrada.present) {
      map['fecha_entrada'] = Variable<DateTime>(fechaEntrada.value);
    }
    if (problema.present) {
      map['problema'] = Variable<String>(problema.value);
    }
    if (estado.present) {
      map['estado'] = Variable<int>(
          $OrdenesServicioTable.$converterestado.toSql(estado.value));
    }
    if (kilometrajeIngreso.present) {
      map['kilometraje_ingreso'] = Variable<int>(kilometrajeIngreso.value);
    }
    if (fechaCierre.present) {
      map['fecha_cierre'] = Variable<DateTime>(fechaCierre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdenesServicioCompanion(')
          ..write('id: $id, ')
          ..write('vehiculoId: $vehiculoId, ')
          ..write('mecanicoId: $mecanicoId, ')
          ..write('fechaEntrada: $fechaEntrada, ')
          ..write('problema: $problema, ')
          ..write('estado: $estado, ')
          ..write('kilometrajeIngreso: $kilometrajeIngreso, ')
          ..write('fechaCierre: $fechaCierre')
          ..write(')'))
        .toString();
  }
}

class $TrabajosTable extends Trabajos with TableInfo<$TrabajosTable, Trabajo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrabajosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ordenIdMeta =
      const VerificationMeta('ordenId');
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
      'orden_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ordenes_servicio (id)'));
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _precioManoObraMeta =
      const VerificationMeta('precioManoObra');
  @override
  late final GeneratedColumn<double> precioManoObra = GeneratedColumn<double>(
      'precio_mano_obra', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ordenId, descripcion, precioManoObra, fecha];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trabajos';
  @override
  VerificationContext validateIntegrity(Insertable<Trabajo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(_ordenIdMeta,
          ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta));
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('precio_mano_obra')) {
      context.handle(
          _precioManoObraMeta,
          precioManoObra.isAcceptableOrUnknown(
              data['precio_mano_obra']!, _precioManoObraMeta));
    } else if (isInserting) {
      context.missing(_precioManoObraMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trabajo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trabajo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ordenId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orden_id'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      precioManoObra: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}precio_mano_obra'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
    );
  }

  @override
  $TrabajosTable createAlias(String alias) {
    return $TrabajosTable(attachedDatabase, alias);
  }
}

class Trabajo extends DataClass implements Insertable<Trabajo> {
  final int id;
  final int ordenId;
  final String descripcion;
  final double precioManoObra;
  final DateTime fecha;
  const Trabajo(
      {required this.id,
      required this.ordenId,
      required this.descripcion,
      required this.precioManoObra,
      required this.fecha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['descripcion'] = Variable<String>(descripcion);
    map['precio_mano_obra'] = Variable<double>(precioManoObra);
    map['fecha'] = Variable<DateTime>(fecha);
    return map;
  }

  TrabajosCompanion toCompanion(bool nullToAbsent) {
    return TrabajosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      descripcion: Value(descripcion),
      precioManoObra: Value(precioManoObra),
      fecha: Value(fecha),
    );
  }

  factory Trabajo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trabajo(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      precioManoObra: serializer.fromJson<double>(json['precioManoObra']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'descripcion': serializer.toJson<String>(descripcion),
      'precioManoObra': serializer.toJson<double>(precioManoObra),
      'fecha': serializer.toJson<DateTime>(fecha),
    };
  }

  Trabajo copyWith(
          {int? id,
          int? ordenId,
          String? descripcion,
          double? precioManoObra,
          DateTime? fecha}) =>
      Trabajo(
        id: id ?? this.id,
        ordenId: ordenId ?? this.ordenId,
        descripcion: descripcion ?? this.descripcion,
        precioManoObra: precioManoObra ?? this.precioManoObra,
        fecha: fecha ?? this.fecha,
      );
  Trabajo copyWithCompanion(TrabajosCompanion data) {
    return Trabajo(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      precioManoObra: data.precioManoObra.present
          ? data.precioManoObra.value
          : this.precioManoObra,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trabajo(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioManoObra: $precioManoObra, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ordenId, descripcion, precioManoObra, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trabajo &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.descripcion == this.descripcion &&
          other.precioManoObra == this.precioManoObra &&
          other.fecha == this.fecha);
}

class TrabajosCompanion extends UpdateCompanion<Trabajo> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<String> descripcion;
  final Value<double> precioManoObra;
  final Value<DateTime> fecha;
  const TrabajosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precioManoObra = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  TrabajosCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required String descripcion,
    required double precioManoObra,
    this.fecha = const Value.absent(),
  })  : ordenId = Value(ordenId),
        descripcion = Value(descripcion),
        precioManoObra = Value(precioManoObra);
  static Insertable<Trabajo> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<String>? descripcion,
    Expression<double>? precioManoObra,
    Expression<DateTime>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (descripcion != null) 'descripcion': descripcion,
      if (precioManoObra != null) 'precio_mano_obra': precioManoObra,
      if (fecha != null) 'fecha': fecha,
    });
  }

  TrabajosCompanion copyWith(
      {Value<int>? id,
      Value<int>? ordenId,
      Value<String>? descripcion,
      Value<double>? precioManoObra,
      Value<DateTime>? fecha}) {
    return TrabajosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      descripcion: descripcion ?? this.descripcion,
      precioManoObra: precioManoObra ?? this.precioManoObra,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precioManoObra.present) {
      map['precio_mano_obra'] = Variable<double>(precioManoObra.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrabajosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioManoObra: $precioManoObra, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class $RepuestosTable extends Repuestos
    with TableInfo<$RepuestosTable, Repuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 80),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _precioVentaMeta =
      const VerificationMeta('precioVenta');
  @override
  late final GeneratedColumn<double> precioVenta = GeneratedColumn<double>(
      'precio_venta', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _existenciasMeta =
      const VerificationMeta('existencias');
  @override
  late final GeneratedColumn<int> existencias = GeneratedColumn<int>(
      'existencias', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stockMinimoMeta =
      const VerificationMeta('stockMinimo');
  @override
  late final GeneratedColumn<int> stockMinimo = GeneratedColumn<int>(
      'stock_minimo', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, codigo, precioVenta, existencias, stockMinimo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos';
  @override
  VerificationContext validateIntegrity(Insertable<Repuesto> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('precio_venta')) {
      context.handle(
          _precioVentaMeta,
          precioVenta.isAcceptableOrUnknown(
              data['precio_venta']!, _precioVentaMeta));
    } else if (isInserting) {
      context.missing(_precioVentaMeta);
    }
    if (data.containsKey('existencias')) {
      context.handle(
          _existenciasMeta,
          existencias.isAcceptableOrUnknown(
              data['existencias']!, _existenciasMeta));
    }
    if (data.containsKey('stock_minimo')) {
      context.handle(
          _stockMinimoMeta,
          stockMinimo.isAcceptableOrUnknown(
              data['stock_minimo']!, _stockMinimoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Repuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Repuesto(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo'])!,
      precioVenta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}precio_venta'])!,
      existencias: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}existencias'])!,
      stockMinimo: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_minimo'])!,
    );
  }

  @override
  $RepuestosTable createAlias(String alias) {
    return $RepuestosTable(attachedDatabase, alias);
  }
}

class Repuesto extends DataClass implements Insertable<Repuesto> {
  final int id;
  final String nombre;
  final String codigo;
  final double precioVenta;
  final int existencias;
  final int stockMinimo;
  const Repuesto(
      {required this.id,
      required this.nombre,
      required this.codigo,
      required this.precioVenta,
      required this.existencias,
      required this.stockMinimo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['precio_venta'] = Variable<double>(precioVenta);
    map['existencias'] = Variable<int>(existencias);
    map['stock_minimo'] = Variable<int>(stockMinimo);
    return map;
  }

  RepuestosCompanion toCompanion(bool nullToAbsent) {
    return RepuestosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      precioVenta: Value(precioVenta),
      existencias: Value(existencias),
      stockMinimo: Value(stockMinimo),
    );
  }

  factory Repuesto.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Repuesto(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      precioVenta: serializer.fromJson<double>(json['precioVenta']),
      existencias: serializer.fromJson<int>(json['existencias']),
      stockMinimo: serializer.fromJson<int>(json['stockMinimo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'precioVenta': serializer.toJson<double>(precioVenta),
      'existencias': serializer.toJson<int>(existencias),
      'stockMinimo': serializer.toJson<int>(stockMinimo),
    };
  }

  Repuesto copyWith(
          {int? id,
          String? nombre,
          String? codigo,
          double? precioVenta,
          int? existencias,
          int? stockMinimo}) =>
      Repuesto(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        codigo: codigo ?? this.codigo,
        precioVenta: precioVenta ?? this.precioVenta,
        existencias: existencias ?? this.existencias,
        stockMinimo: stockMinimo ?? this.stockMinimo,
      );
  Repuesto copyWithCompanion(RepuestosCompanion data) {
    return Repuesto(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      precioVenta:
          data.precioVenta.present ? data.precioVenta.value : this.precioVenta,
      existencias:
          data.existencias.present ? data.existencias.value : this.existencias,
      stockMinimo:
          data.stockMinimo.present ? data.stockMinimo.value : this.stockMinimo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Repuesto(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('existencias: $existencias, ')
          ..write('stockMinimo: $stockMinimo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, codigo, precioVenta, existencias, stockMinimo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Repuesto &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.precioVenta == this.precioVenta &&
          other.existencias == this.existencias &&
          other.stockMinimo == this.stockMinimo);
}

class RepuestosCompanion extends UpdateCompanion<Repuesto> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<double> precioVenta;
  final Value<int> existencias;
  final Value<int> stockMinimo;
  const RepuestosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.precioVenta = const Value.absent(),
    this.existencias = const Value.absent(),
    this.stockMinimo = const Value.absent(),
  });
  RepuestosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String codigo,
    required double precioVenta,
    this.existencias = const Value.absent(),
    this.stockMinimo = const Value.absent(),
  })  : nombre = Value(nombre),
        codigo = Value(codigo),
        precioVenta = Value(precioVenta);
  static Insertable<Repuesto> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<double>? precioVenta,
    Expression<int>? existencias,
    Expression<int>? stockMinimo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (precioVenta != null) 'precio_venta': precioVenta,
      if (existencias != null) 'existencias': existencias,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
    });
  }

  RepuestosCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String>? codigo,
      Value<double>? precioVenta,
      Value<int>? existencias,
      Value<int>? stockMinimo}) {
    return RepuestosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      precioVenta: precioVenta ?? this.precioVenta,
      existencias: existencias ?? this.existencias,
      stockMinimo: stockMinimo ?? this.stockMinimo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (precioVenta.present) {
      map['precio_venta'] = Variable<double>(precioVenta.value);
    }
    if (existencias.present) {
      map['existencias'] = Variable<int>(existencias.value);
    }
    if (stockMinimo.present) {
      map['stock_minimo'] = Variable<int>(stockMinimo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('precioVenta: $precioVenta, ')
          ..write('existencias: $existencias, ')
          ..write('stockMinimo: $stockMinimo')
          ..write(')'))
        .toString();
  }
}

class $RepuestosUsadosTable extends RepuestosUsados
    with TableInfo<$RepuestosUsadosTable, RepuestoUsado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepuestosUsadosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ordenIdMeta =
      const VerificationMeta('ordenId');
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
      'orden_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ordenes_servicio (id)'));
  static const VerificationMeta _repuestoIdMeta =
      const VerificationMeta('repuestoId');
  @override
  late final GeneratedColumn<int> repuestoId = GeneratedColumn<int>(
      'repuesto_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES repuestos (id)'));
  static const VerificationMeta _cantidadMeta =
      const VerificationMeta('cantidad');
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
      'cantidad', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _precioUnitarioMeta =
      const VerificationMeta('precioUnitario');
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
      'precio_unitario', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ordenId, repuestoId, cantidad, precioUnitario];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repuestos_usados';
  @override
  VerificationContext validateIntegrity(Insertable<RepuestoUsado> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(_ordenIdMeta,
          ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta));
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('repuesto_id')) {
      context.handle(
          _repuestoIdMeta,
          repuestoId.isAcceptableOrUnknown(
              data['repuesto_id']!, _repuestoIdMeta));
    } else if (isInserting) {
      context.missing(_repuestoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(_cantidadMeta,
          cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta));
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
          _precioUnitarioMeta,
          precioUnitario.isAcceptableOrUnknown(
              data['precio_unitario']!, _precioUnitarioMeta));
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RepuestoUsado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepuestoUsado(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ordenId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orden_id'])!,
      repuestoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repuesto_id'])!,
      cantidad: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cantidad'])!,
      precioUnitario: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}precio_unitario'])!,
    );
  }

  @override
  $RepuestosUsadosTable createAlias(String alias) {
    return $RepuestosUsadosTable(attachedDatabase, alias);
  }
}

class RepuestoUsado extends DataClass implements Insertable<RepuestoUsado> {
  final int id;
  final int ordenId;
  final int repuestoId;
  final int cantidad;
  final double precioUnitario;
  const RepuestoUsado(
      {required this.id,
      required this.ordenId,
      required this.repuestoId,
      required this.cantidad,
      required this.precioUnitario});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['repuesto_id'] = Variable<int>(repuestoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    return map;
  }

  RepuestosUsadosCompanion toCompanion(bool nullToAbsent) {
    return RepuestosUsadosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      repuestoId: Value(repuestoId),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
    );
  }

  factory RepuestoUsado.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepuestoUsado(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      repuestoId: serializer.fromJson<int>(json['repuestoId']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'repuestoId': serializer.toJson<int>(repuestoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
    };
  }

  RepuestoUsado copyWith(
          {int? id,
          int? ordenId,
          int? repuestoId,
          int? cantidad,
          double? precioUnitario}) =>
      RepuestoUsado(
        id: id ?? this.id,
        ordenId: ordenId ?? this.ordenId,
        repuestoId: repuestoId ?? this.repuestoId,
        cantidad: cantidad ?? this.cantidad,
        precioUnitario: precioUnitario ?? this.precioUnitario,
      );
  RepuestoUsado copyWithCompanion(RepuestosUsadosCompanion data) {
    return RepuestoUsado(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      repuestoId:
          data.repuestoId.present ? data.repuestoId.value : this.repuestoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepuestoUsado(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ordenId, repuestoId, cantidad, precioUnitario);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepuestoUsado &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.repuestoId == this.repuestoId &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario);
}

class RepuestosUsadosCompanion extends UpdateCompanion<RepuestoUsado> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<int> repuestoId;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  const RepuestosUsadosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.repuestoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
  });
  RepuestosUsadosCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required int repuestoId,
    required int cantidad,
    required double precioUnitario,
  })  : ordenId = Value(ordenId),
        repuestoId = Value(repuestoId),
        cantidad = Value(cantidad),
        precioUnitario = Value(precioUnitario);
  static Insertable<RepuestoUsado> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<int>? repuestoId,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (repuestoId != null) 'repuesto_id': repuestoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
    });
  }

  RepuestosUsadosCompanion copyWith(
      {Value<int>? id,
      Value<int>? ordenId,
      Value<int>? repuestoId,
      Value<int>? cantidad,
      Value<double>? precioUnitario}) {
    return RepuestosUsadosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      repuestoId: repuestoId ?? this.repuestoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (repuestoId.present) {
      map['repuesto_id'] = Variable<int>(repuestoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepuestosUsadosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('repuestoId: $repuestoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario')
          ..write(')'))
        .toString();
  }
}

class $PagosTable extends Pagos with TableInfo<$PagosTable, Pago> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ordenIdMeta =
      const VerificationMeta('ordenId');
  @override
  late final GeneratedColumn<int> ordenId = GeneratedColumn<int>(
      'orden_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES ordenes_servicio (id)'));
  static const VerificationMeta _montoMeta = const VerificationMeta('monto');
  @override
  late final GeneratedColumn<double> monto = GeneratedColumn<double>(
      'monto', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
      'fecha', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
      'nota', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, ordenId, monto, fecha, nota];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pagos';
  @override
  VerificationContext validateIntegrity(Insertable<Pago> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('orden_id')) {
      context.handle(_ordenIdMeta,
          ordenId.isAcceptableOrUnknown(data['orden_id']!, _ordenIdMeta));
    } else if (isInserting) {
      context.missing(_ordenIdMeta);
    }
    if (data.containsKey('monto')) {
      context.handle(
          _montoMeta, monto.isAcceptableOrUnknown(data['monto']!, _montoMeta));
    } else if (isInserting) {
      context.missing(_montoMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
          _fechaMeta, fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta));
    }
    if (data.containsKey('nota')) {
      context.handle(
          _notaMeta, nota.isAcceptableOrUnknown(data['nota']!, _notaMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pago map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pago(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ordenId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}orden_id'])!,
      monto: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}monto'])!,
      fecha: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fecha'])!,
      nota: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nota']),
    );
  }

  @override
  $PagosTable createAlias(String alias) {
    return $PagosTable(attachedDatabase, alias);
  }
}

class Pago extends DataClass implements Insertable<Pago> {
  final int id;
  final int ordenId;
  final double monto;
  final DateTime fecha;
  final String? nota;
  const Pago(
      {required this.id,
      required this.ordenId,
      required this.monto,
      required this.fecha,
      this.nota});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['orden_id'] = Variable<int>(ordenId);
    map['monto'] = Variable<double>(monto);
    map['fecha'] = Variable<DateTime>(fecha);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    return map;
  }

  PagosCompanion toCompanion(bool nullToAbsent) {
    return PagosCompanion(
      id: Value(id),
      ordenId: Value(ordenId),
      monto: Value(monto),
      fecha: Value(fecha),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
    );
  }

  factory Pago.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pago(
      id: serializer.fromJson<int>(json['id']),
      ordenId: serializer.fromJson<int>(json['ordenId']),
      monto: serializer.fromJson<double>(json['monto']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      nota: serializer.fromJson<String?>(json['nota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ordenId': serializer.toJson<int>(ordenId),
      'monto': serializer.toJson<double>(monto),
      'fecha': serializer.toJson<DateTime>(fecha),
      'nota': serializer.toJson<String?>(nota),
    };
  }

  Pago copyWith(
          {int? id,
          int? ordenId,
          double? monto,
          DateTime? fecha,
          Value<String?> nota = const Value.absent()}) =>
      Pago(
        id: id ?? this.id,
        ordenId: ordenId ?? this.ordenId,
        monto: monto ?? this.monto,
        fecha: fecha ?? this.fecha,
        nota: nota.present ? nota.value : this.nota,
      );
  Pago copyWithCompanion(PagosCompanion data) {
    return Pago(
      id: data.id.present ? data.id.value : this.id,
      ordenId: data.ordenId.present ? data.ordenId.value : this.ordenId,
      monto: data.monto.present ? data.monto.value : this.monto,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      nota: data.nota.present ? data.nota.value : this.nota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pago(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ordenId, monto, fecha, nota);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pago &&
          other.id == this.id &&
          other.ordenId == this.ordenId &&
          other.monto == this.monto &&
          other.fecha == this.fecha &&
          other.nota == this.nota);
}

class PagosCompanion extends UpdateCompanion<Pago> {
  final Value<int> id;
  final Value<int> ordenId;
  final Value<double> monto;
  final Value<DateTime> fecha;
  final Value<String?> nota;
  const PagosCompanion({
    this.id = const Value.absent(),
    this.ordenId = const Value.absent(),
    this.monto = const Value.absent(),
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
  });
  PagosCompanion.insert({
    this.id = const Value.absent(),
    required int ordenId,
    required double monto,
    this.fecha = const Value.absent(),
    this.nota = const Value.absent(),
  })  : ordenId = Value(ordenId),
        monto = Value(monto);
  static Insertable<Pago> custom({
    Expression<int>? id,
    Expression<int>? ordenId,
    Expression<double>? monto,
    Expression<DateTime>? fecha,
    Expression<String>? nota,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ordenId != null) 'orden_id': ordenId,
      if (monto != null) 'monto': monto,
      if (fecha != null) 'fecha': fecha,
      if (nota != null) 'nota': nota,
    });
  }

  PagosCompanion copyWith(
      {Value<int>? id,
      Value<int>? ordenId,
      Value<double>? monto,
      Value<DateTime>? fecha,
      Value<String?>? nota}) {
    return PagosCompanion(
      id: id ?? this.id,
      ordenId: ordenId ?? this.ordenId,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      nota: nota ?? this.nota,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ordenId.present) {
      map['orden_id'] = Variable<int>(ordenId.value);
    }
    if (monto.present) {
      map['monto'] = Variable<double>(monto.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagosCompanion(')
          ..write('id: $id, ')
          ..write('ordenId: $ordenId, ')
          ..write('monto: $monto, ')
          ..write('fecha: $fecha, ')
          ..write('nota: $nota')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $VehiculosTable vehiculos = $VehiculosTable(this);
  late final $MecanicosTable mecanicos = $MecanicosTable(this);
  late final $OrdenesServicioTable ordenesServicio =
      $OrdenesServicioTable(this);
  late final $TrabajosTable trabajos = $TrabajosTable(this);
  late final $RepuestosTable repuestos = $RepuestosTable(this);
  late final $RepuestosUsadosTable repuestosUsados =
      $RepuestosUsadosTable(this);
  late final $PagosTable pagos = $PagosTable(this);
  late final ClientesDao clientesDao = ClientesDao(this as AppDatabase);
  late final MecanicosDao mecanicosDao = MecanicosDao(this as AppDatabase);
  late final OrdenesDao ordenesDao = OrdenesDao(this as AppDatabase);
  late final RepuestosDao repuestosDao = RepuestosDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        clientes,
        vehiculos,
        mecanicos,
        ordenesServicio,
        trabajos,
        repuestos,
        repuestosUsados,
        pagos
      ];
}

typedef $$ClientesTableCreateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  required String nombre,
  required String telefono,
  Value<String?> direccion,
});
typedef $$ClientesTableUpdateCompanionBuilder = ClientesCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> telefono,
  Value<String?> direccion,
});

final class $$ClientesTableReferences
    extends BaseReferences<_$AppDatabase, $ClientesTable, Cliente> {
  $$ClientesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VehiculosTable, List<Vehiculo>>
      _vehiculosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.vehiculos,
              aliasName: 'clientes__id__vehiculos__cliente_id');

  $$VehiculosTableProcessedTableManager get vehiculosRefs {
    final manager = $$VehiculosTableTableManager($_db, $_db.vehiculos)
        .filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiculosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnFilters(column));

  Expression<bool> vehiculosRefs(
      Expression<bool> Function($$VehiculosTableFilterComposer f) f) {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vehiculos,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiculosTableFilterComposer(
              $db: $db,
              $table: $db.vehiculos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnOrderings(column));
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  Expression<T> vehiculosRefs<T extends Object>(
      Expression<T> Function($$VehiculosTableAnnotationComposer a) f) {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.vehiculos,
        getReferencedColumn: (t) => t.clienteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiculosTableAnnotationComposer(
              $db: $db,
              $table: $db.vehiculos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool vehiculosRefs})> {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> telefono = const Value.absent(),
            Value<String?> direccion = const Value.absent(),
          }) =>
              ClientesCompanion(
            id: id,
            nombre: nombre,
            telefono: telefono,
            direccion: direccion,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required String telefono,
            Value<String?> direccion = const Value.absent(),
          }) =>
              ClientesCompanion.insert(
            id: id,
            nombre: nombre,
            telefono: telefono,
            direccion: direccion,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ClientesTable, Cliente>(table),
                    $$ClientesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({vehiculosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (vehiculosRefs) db.vehiculos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (vehiculosRefs)
                    await $_getPrefetchedDataByColumns<Cliente, $ClientesTable,
                            Vehiculo, $VehiculosTable>(
                        currentTable: table,
                        referencedTable:
                            $$ClientesTableReferences._vehiculosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientesTableReferences(db, table, p0)
                                .vehiculosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'cliente_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientesTable,
    Cliente,
    $$ClientesTableFilterComposer,
    $$ClientesTableOrderingComposer,
    $$ClientesTableAnnotationComposer,
    $$ClientesTableCreateCompanionBuilder,
    $$ClientesTableUpdateCompanionBuilder,
    (Cliente, $$ClientesTableReferences),
    Cliente,
    PrefetchHooks Function({bool vehiculosRefs})>;
typedef $$VehiculosTableCreateCompanionBuilder = VehiculosCompanion Function({
  Value<int> id,
  required int clienteId,
  required String matricula,
  required String marca,
  required String modelo,
  required int anio,
  Value<int> kilometraje,
});
typedef $$VehiculosTableUpdateCompanionBuilder = VehiculosCompanion Function({
  Value<int> id,
  Value<int> clienteId,
  Value<String> matricula,
  Value<String> marca,
  Value<String> modelo,
  Value<int> anio,
  Value<int> kilometraje,
});

final class $$VehiculosTableReferences
    extends BaseReferences<_$AppDatabase, $VehiculosTable, Vehiculo> {
  $$VehiculosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientesTable _clienteIdTable(_$AppDatabase db) =>
      db.clientes.createAlias('vehiculos__cliente_id__clientes__id');

  $$ClientesTableProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $$ClientesTableTableManager($_db, $_db.clientes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrdenesServicioTable, List<OrdenServicio>>
      _ordenesServicioRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ordenesServicio,
              aliasName: 'vehiculos__id__ordenes_servicio__vehiculo_id');

  $$OrdenesServicioTableProcessedTableManager get ordenesServicioRefs {
    final manager =
        $$OrdenesServicioTableTableManager($_db, $_db.ordenesServicio)
            .filter((f) => f.vehiculoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_ordenesServicioRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VehiculosTableFilterComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marca => $composableBuilder(
      column: $table.marca, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get anio => $composableBuilder(
      column: $table.anio, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get kilometraje => $composableBuilder(
      column: $table.kilometraje, builder: (column) => ColumnFilters(column));

  $$ClientesTableFilterComposer get clienteId {
    final $$ClientesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableFilterComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> ordenesServicioRefs(
      Expression<bool> Function($$OrdenesServicioTableFilterComposer f) f) {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.vehiculoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableFilterComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VehiculosTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get matricula => $composableBuilder(
      column: $table.matricula, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marca => $composableBuilder(
      column: $table.marca, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelo => $composableBuilder(
      column: $table.modelo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get anio => $composableBuilder(
      column: $table.anio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kilometraje => $composableBuilder(
      column: $table.kilometraje, builder: (column) => ColumnOrderings(column));

  $$ClientesTableOrderingComposer get clienteId {
    final $$ClientesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableOrderingComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$VehiculosTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiculosTable> {
  $$VehiculosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get matricula =>
      $composableBuilder(column: $table.matricula, builder: (column) => column);

  GeneratedColumn<String> get marca =>
      $composableBuilder(column: $table.marca, builder: (column) => column);

  GeneratedColumn<String> get modelo =>
      $composableBuilder(column: $table.modelo, builder: (column) => column);

  GeneratedColumn<int> get anio =>
      $composableBuilder(column: $table.anio, builder: (column) => column);

  GeneratedColumn<int> get kilometraje => $composableBuilder(
      column: $table.kilometraje, builder: (column) => column);

  $$ClientesTableAnnotationComposer get clienteId {
    final $$ClientesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clienteId,
        referencedTable: $db.clientes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientesTableAnnotationComposer(
              $db: $db,
              $table: $db.clientes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> ordenesServicioRefs<T extends Object>(
      Expression<T> Function($$OrdenesServicioTableAnnotationComposer a) f) {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.vehiculoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableAnnotationComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VehiculosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VehiculosTable,
    Vehiculo,
    $$VehiculosTableFilterComposer,
    $$VehiculosTableOrderingComposer,
    $$VehiculosTableAnnotationComposer,
    $$VehiculosTableCreateCompanionBuilder,
    $$VehiculosTableUpdateCompanionBuilder,
    (Vehiculo, $$VehiculosTableReferences),
    Vehiculo,
    PrefetchHooks Function({bool clienteId, bool ordenesServicioRefs})> {
  $$VehiculosTableTableManager(_$AppDatabase db, $VehiculosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiculosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiculosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiculosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> clienteId = const Value.absent(),
            Value<String> matricula = const Value.absent(),
            Value<String> marca = const Value.absent(),
            Value<String> modelo = const Value.absent(),
            Value<int> anio = const Value.absent(),
            Value<int> kilometraje = const Value.absent(),
          }) =>
              VehiculosCompanion(
            id: id,
            clienteId: clienteId,
            matricula: matricula,
            marca: marca,
            modelo: modelo,
            anio: anio,
            kilometraje: kilometraje,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int clienteId,
            required String matricula,
            required String marca,
            required String modelo,
            required int anio,
            Value<int> kilometraje = const Value.absent(),
          }) =>
              VehiculosCompanion.insert(
            id: id,
            clienteId: clienteId,
            matricula: matricula,
            marca: marca,
            modelo: modelo,
            anio: anio,
            kilometraje: kilometraje,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$VehiculosTable, Vehiculo>(table),
                    $$VehiculosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {clienteId = false, ordenesServicioRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ordenesServicioRefs) db.ordenesServicio
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (clienteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clienteId,
                    referencedTable:
                        $$VehiculosTableReferences._clienteIdTable(db),
                    referencedColumn:
                        $$VehiculosTableReferences._clienteIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordenesServicioRefs)
                    await $_getPrefetchedDataByColumns<
                            Vehiculo,
                            $VehiculosTable,
                            OrdenServicio,
                            $OrdenesServicioTable>(
                        currentTable: table,
                        referencedTable: $$VehiculosTableReferences
                            ._ordenesServicioRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VehiculosTableReferences(db, table, p0)
                                .ordenesServicioRefs,
                        currentColumn: 'id',
                        referencedColumn: 'vehiculo_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VehiculosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VehiculosTable,
    Vehiculo,
    $$VehiculosTableFilterComposer,
    $$VehiculosTableOrderingComposer,
    $$VehiculosTableAnnotationComposer,
    $$VehiculosTableCreateCompanionBuilder,
    $$VehiculosTableUpdateCompanionBuilder,
    (Vehiculo, $$VehiculosTableReferences),
    Vehiculo,
    PrefetchHooks Function({bool clienteId, bool ordenesServicioRefs})>;
typedef $$MecanicosTableCreateCompanionBuilder = MecanicosCompanion Function({
  Value<int> id,
  required String nombre,
  Value<bool> activo,
});
typedef $$MecanicosTableUpdateCompanionBuilder = MecanicosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<bool> activo,
});

final class $$MecanicosTableReferences
    extends BaseReferences<_$AppDatabase, $MecanicosTable, Mecanico> {
  $$MecanicosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdenesServicioTable, List<OrdenServicio>>
      _ordenesServicioRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ordenesServicio,
              aliasName: 'mecanicos__id__ordenes_servicio__mecanico_id');

  $$OrdenesServicioTableProcessedTableManager get ordenesServicioRefs {
    final manager =
        $$OrdenesServicioTableTableManager($_db, $_db.ordenesServicio)
            .filter((f) => f.mecanicoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_ordenesServicioRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MecanicosTableFilterComposer
    extends Composer<_$AppDatabase, $MecanicosTable> {
  $$MecanicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  Expression<bool> ordenesServicioRefs(
      Expression<bool> Function($$OrdenesServicioTableFilterComposer f) f) {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.mecanicoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableFilterComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MecanicosTableOrderingComposer
    extends Composer<_$AppDatabase, $MecanicosTable> {
  $$MecanicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));
}

class $$MecanicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MecanicosTable> {
  $$MecanicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> ordenesServicioRefs<T extends Object>(
      Expression<T> Function($$OrdenesServicioTableAnnotationComposer a) f) {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.mecanicoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableAnnotationComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MecanicosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MecanicosTable,
    Mecanico,
    $$MecanicosTableFilterComposer,
    $$MecanicosTableOrderingComposer,
    $$MecanicosTableAnnotationComposer,
    $$MecanicosTableCreateCompanionBuilder,
    $$MecanicosTableUpdateCompanionBuilder,
    (Mecanico, $$MecanicosTableReferences),
    Mecanico,
    PrefetchHooks Function({bool ordenesServicioRefs})> {
  $$MecanicosTableTableManager(_$AppDatabase db, $MecanicosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MecanicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MecanicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MecanicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              MecanicosCompanion(
            id: id,
            nombre: nombre,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            Value<bool> activo = const Value.absent(),
          }) =>
              MecanicosCompanion.insert(
            id: id,
            nombre: nombre,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$MecanicosTable, Mecanico>(table),
                    $$MecanicosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordenesServicioRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (ordenesServicioRefs) db.ordenesServicio
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordenesServicioRefs)
                    await $_getPrefetchedDataByColumns<
                            Mecanico,
                            $MecanicosTable,
                            OrdenServicio,
                            $OrdenesServicioTable>(
                        currentTable: table,
                        referencedTable: $$MecanicosTableReferences
                            ._ordenesServicioRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MecanicosTableReferences(db, table, p0)
                                .ordenesServicioRefs,
                        currentColumn: 'id',
                        referencedColumn: 'mecanico_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MecanicosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MecanicosTable,
    Mecanico,
    $$MecanicosTableFilterComposer,
    $$MecanicosTableOrderingComposer,
    $$MecanicosTableAnnotationComposer,
    $$MecanicosTableCreateCompanionBuilder,
    $$MecanicosTableUpdateCompanionBuilder,
    (Mecanico, $$MecanicosTableReferences),
    Mecanico,
    PrefetchHooks Function({bool ordenesServicioRefs})>;
typedef $$OrdenesServicioTableCreateCompanionBuilder = OrdenesServicioCompanion
    Function({
  Value<int> id,
  required int vehiculoId,
  required int mecanicoId,
  required DateTime fechaEntrada,
  required String problema,
  required EstadoOrden estado,
  required int kilometrajeIngreso,
  Value<DateTime?> fechaCierre,
});
typedef $$OrdenesServicioTableUpdateCompanionBuilder = OrdenesServicioCompanion
    Function({
  Value<int> id,
  Value<int> vehiculoId,
  Value<int> mecanicoId,
  Value<DateTime> fechaEntrada,
  Value<String> problema,
  Value<EstadoOrden> estado,
  Value<int> kilometrajeIngreso,
  Value<DateTime?> fechaCierre,
});

final class $$OrdenesServicioTableReferences extends BaseReferences<
    _$AppDatabase, $OrdenesServicioTable, OrdenServicio> {
  $$OrdenesServicioTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $VehiculosTable _vehiculoIdTable(_$AppDatabase db) =>
      db.vehiculos.createAlias('ordenes_servicio__vehiculo_id__vehiculos__id');

  $$VehiculosTableProcessedTableManager get vehiculoId {
    final $_column = $_itemColumn<int>('vehiculo_id')!;

    final manager = $$VehiculosTableTableManager($_db, $_db.vehiculos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehiculoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MecanicosTable _mecanicoIdTable(_$AppDatabase db) =>
      db.mecanicos.createAlias('ordenes_servicio__mecanico_id__mecanicos__id');

  $$MecanicosTableProcessedTableManager get mecanicoId {
    final $_column = $_itemColumn<int>('mecanico_id')!;

    final manager = $$MecanicosTableTableManager($_db, $_db.mecanicos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mecanicoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TrabajosTable, List<Trabajo>> _trabajosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.trabajos,
          aliasName: 'ordenes_servicio__id__trabajos__orden_id');

  $$TrabajosTableProcessedTableManager get trabajosRefs {
    final manager = $$TrabajosTableTableManager($_db, $_db.trabajos)
        .filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trabajosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RepuestosUsadosTable, List<RepuestoUsado>>
      _repuestosUsadosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.repuestosUsados,
              aliasName: 'ordenes_servicio__id__repuestos_usados__orden_id');

  $$RepuestosUsadosTableProcessedTableManager get repuestosUsadosRefs {
    final manager =
        $$RepuestosUsadosTableTableManager($_db, $_db.repuestosUsados)
            .filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_repuestosUsadosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PagosTable, List<Pago>> _pagosRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.pagos,
          aliasName: 'ordenes_servicio__id__pagos__orden_id');

  $$PagosTableProcessedTableManager get pagosRefs {
    final manager = $$PagosTableTableManager($_db, $_db.pagos)
        .filter((f) => f.ordenId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdenesServicioTableFilterComposer
    extends Composer<_$AppDatabase, $OrdenesServicioTable> {
  $$OrdenesServicioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaEntrada => $composableBuilder(
      column: $table.fechaEntrada, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get problema => $composableBuilder(
      column: $table.problema, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<EstadoOrden, EstadoOrden, int> get estado =>
      $composableBuilder(
          column: $table.estado,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get kilometrajeIngreso => $composableBuilder(
      column: $table.kilometrajeIngreso,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fechaCierre => $composableBuilder(
      column: $table.fechaCierre, builder: (column) => ColumnFilters(column));

  $$VehiculosTableFilterComposer get vehiculoId {
    final $$VehiculosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vehiculoId,
        referencedTable: $db.vehiculos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiculosTableFilterComposer(
              $db: $db,
              $table: $db.vehiculos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MecanicosTableFilterComposer get mecanicoId {
    final $$MecanicosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mecanicoId,
        referencedTable: $db.mecanicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MecanicosTableFilterComposer(
              $db: $db,
              $table: $db.mecanicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> trabajosRefs(
      Expression<bool> Function($$TrabajosTableFilterComposer f) f) {
    final $$TrabajosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trabajos,
        getReferencedColumn: (t) => t.ordenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrabajosTableFilterComposer(
              $db: $db,
              $table: $db.trabajos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> repuestosUsadosRefs(
      Expression<bool> Function($$RepuestosUsadosTableFilterComposer f) f) {
    final $$RepuestosUsadosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.repuestosUsados,
        getReferencedColumn: (t) => t.ordenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosUsadosTableFilterComposer(
              $db: $db,
              $table: $db.repuestosUsados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> pagosRefs(
      Expression<bool> Function($$PagosTableFilterComposer f) f) {
    final $$PagosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pagos,
        getReferencedColumn: (t) => t.ordenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagosTableFilterComposer(
              $db: $db,
              $table: $db.pagos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdenesServicioTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdenesServicioTable> {
  $$OrdenesServicioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaEntrada => $composableBuilder(
      column: $table.fechaEntrada,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get problema => $composableBuilder(
      column: $table.problema, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estado => $composableBuilder(
      column: $table.estado, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get kilometrajeIngreso => $composableBuilder(
      column: $table.kilometrajeIngreso,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fechaCierre => $composableBuilder(
      column: $table.fechaCierre, builder: (column) => ColumnOrderings(column));

  $$VehiculosTableOrderingComposer get vehiculoId {
    final $$VehiculosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vehiculoId,
        referencedTable: $db.vehiculos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiculosTableOrderingComposer(
              $db: $db,
              $table: $db.vehiculos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MecanicosTableOrderingComposer get mecanicoId {
    final $$MecanicosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mecanicoId,
        referencedTable: $db.mecanicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MecanicosTableOrderingComposer(
              $db: $db,
              $table: $db.mecanicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrdenesServicioTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdenesServicioTable> {
  $$OrdenesServicioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaEntrada => $composableBuilder(
      column: $table.fechaEntrada, builder: (column) => column);

  GeneratedColumn<String> get problema =>
      $composableBuilder(column: $table.problema, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EstadoOrden, int> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<int> get kilometrajeIngreso => $composableBuilder(
      column: $table.kilometrajeIngreso, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaCierre => $composableBuilder(
      column: $table.fechaCierre, builder: (column) => column);

  $$VehiculosTableAnnotationComposer get vehiculoId {
    final $$VehiculosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vehiculoId,
        referencedTable: $db.vehiculos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiculosTableAnnotationComposer(
              $db: $db,
              $table: $db.vehiculos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MecanicosTableAnnotationComposer get mecanicoId {
    final $$MecanicosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mecanicoId,
        referencedTable: $db.mecanicos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MecanicosTableAnnotationComposer(
              $db: $db,
              $table: $db.mecanicos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> trabajosRefs<T extends Object>(
      Expression<T> Function($$TrabajosTableAnnotationComposer a) f) {
    final $$TrabajosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.trabajos,
        getReferencedColumn: (t) => t.ordenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TrabajosTableAnnotationComposer(
              $db: $db,
              $table: $db.trabajos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> repuestosUsadosRefs<T extends Object>(
      Expression<T> Function($$RepuestosUsadosTableAnnotationComposer a) f) {
    final $$RepuestosUsadosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.repuestosUsados,
        getReferencedColumn: (t) => t.ordenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosUsadosTableAnnotationComposer(
              $db: $db,
              $table: $db.repuestosUsados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> pagosRefs<T extends Object>(
      Expression<T> Function($$PagosTableAnnotationComposer a) f) {
    final $$PagosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.pagos,
        getReferencedColumn: (t) => t.ordenId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PagosTableAnnotationComposer(
              $db: $db,
              $table: $db.pagos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdenesServicioTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdenesServicioTable,
    OrdenServicio,
    $$OrdenesServicioTableFilterComposer,
    $$OrdenesServicioTableOrderingComposer,
    $$OrdenesServicioTableAnnotationComposer,
    $$OrdenesServicioTableCreateCompanionBuilder,
    $$OrdenesServicioTableUpdateCompanionBuilder,
    (OrdenServicio, $$OrdenesServicioTableReferences),
    OrdenServicio,
    PrefetchHooks Function(
        {bool vehiculoId,
        bool mecanicoId,
        bool trabajosRefs,
        bool repuestosUsadosRefs,
        bool pagosRefs})> {
  $$OrdenesServicioTableTableManager(
      _$AppDatabase db, $OrdenesServicioTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdenesServicioTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdenesServicioTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdenesServicioTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> vehiculoId = const Value.absent(),
            Value<int> mecanicoId = const Value.absent(),
            Value<DateTime> fechaEntrada = const Value.absent(),
            Value<String> problema = const Value.absent(),
            Value<EstadoOrden> estado = const Value.absent(),
            Value<int> kilometrajeIngreso = const Value.absent(),
            Value<DateTime?> fechaCierre = const Value.absent(),
          }) =>
              OrdenesServicioCompanion(
            id: id,
            vehiculoId: vehiculoId,
            mecanicoId: mecanicoId,
            fechaEntrada: fechaEntrada,
            problema: problema,
            estado: estado,
            kilometrajeIngreso: kilometrajeIngreso,
            fechaCierre: fechaCierre,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int vehiculoId,
            required int mecanicoId,
            required DateTime fechaEntrada,
            required String problema,
            required EstadoOrden estado,
            required int kilometrajeIngreso,
            Value<DateTime?> fechaCierre = const Value.absent(),
          }) =>
              OrdenesServicioCompanion.insert(
            id: id,
            vehiculoId: vehiculoId,
            mecanicoId: mecanicoId,
            fechaEntrada: fechaEntrada,
            problema: problema,
            estado: estado,
            kilometrajeIngreso: kilometrajeIngreso,
            fechaCierre: fechaCierre,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$OrdenesServicioTable, OrdenServicio>(table),
                    $$OrdenesServicioTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {vehiculoId = false,
              mecanicoId = false,
              trabajosRefs = false,
              repuestosUsadosRefs = false,
              pagosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (trabajosRefs) db.trabajos,
                if (repuestosUsadosRefs) db.repuestosUsados,
                if (pagosRefs) db.pagos
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (vehiculoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.vehiculoId,
                    referencedTable:
                        $$OrdenesServicioTableReferences._vehiculoIdTable(db),
                    referencedColumn: $$OrdenesServicioTableReferences
                        ._vehiculoIdTable(db)
                        .id,
                  ) as T;
                }
                if (mecanicoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mecanicoId,
                    referencedTable:
                        $$OrdenesServicioTableReferences._mecanicoIdTable(db),
                    referencedColumn: $$OrdenesServicioTableReferences
                        ._mecanicoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trabajosRefs)
                    await $_getPrefetchedDataByColumns<OrdenServicio,
                            $OrdenesServicioTable, Trabajo, $TrabajosTable>(
                        currentTable: table,
                        referencedTable: $$OrdenesServicioTableReferences
                            ._trabajosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdenesServicioTableReferences(db, table, p0)
                                .trabajosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'orden_id',
                        typedResults: items),
                  if (repuestosUsadosRefs)
                    await $_getPrefetchedDataByColumns<
                            OrdenServicio,
                            $OrdenesServicioTable,
                            RepuestoUsado,
                            $RepuestosUsadosTable>(
                        currentTable: table,
                        referencedTable: $$OrdenesServicioTableReferences
                            ._repuestosUsadosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdenesServicioTableReferences(db, table, p0)
                                .repuestosUsadosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'orden_id',
                        typedResults: items),
                  if (pagosRefs)
                    await $_getPrefetchedDataByColumns<OrdenServicio,
                            $OrdenesServicioTable, Pago, $PagosTable>(
                        currentTable: table,
                        referencedTable: $$OrdenesServicioTableReferences
                            ._pagosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdenesServicioTableReferences(db, table, p0)
                                .pagosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'orden_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdenesServicioTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdenesServicioTable,
    OrdenServicio,
    $$OrdenesServicioTableFilterComposer,
    $$OrdenesServicioTableOrderingComposer,
    $$OrdenesServicioTableAnnotationComposer,
    $$OrdenesServicioTableCreateCompanionBuilder,
    $$OrdenesServicioTableUpdateCompanionBuilder,
    (OrdenServicio, $$OrdenesServicioTableReferences),
    OrdenServicio,
    PrefetchHooks Function(
        {bool vehiculoId,
        bool mecanicoId,
        bool trabajosRefs,
        bool repuestosUsadosRefs,
        bool pagosRefs})>;
typedef $$TrabajosTableCreateCompanionBuilder = TrabajosCompanion Function({
  Value<int> id,
  required int ordenId,
  required String descripcion,
  required double precioManoObra,
  Value<DateTime> fecha,
});
typedef $$TrabajosTableUpdateCompanionBuilder = TrabajosCompanion Function({
  Value<int> id,
  Value<int> ordenId,
  Value<String> descripcion,
  Value<double> precioManoObra,
  Value<DateTime> fecha,
});

final class $$TrabajosTableReferences
    extends BaseReferences<_$AppDatabase, $TrabajosTable, Trabajo> {
  $$TrabajosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesServicioTable _ordenIdTable(_$AppDatabase db) =>
      db.ordenesServicio
          .createAlias('trabajos__orden_id__ordenes_servicio__id');

  $$OrdenesServicioTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager =
        $$OrdenesServicioTableTableManager($_db, $_db.ordenesServicio)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TrabajosTableFilterComposer
    extends Composer<_$AppDatabase, $TrabajosTable> {
  $$TrabajosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioManoObra => $composableBuilder(
      column: $table.precioManoObra,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  $$OrdenesServicioTableFilterComposer get ordenId {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableFilterComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TrabajosTableOrderingComposer
    extends Composer<_$AppDatabase, $TrabajosTable> {
  $$TrabajosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioManoObra => $composableBuilder(
      column: $table.precioManoObra,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  $$OrdenesServicioTableOrderingComposer get ordenId {
    final $$OrdenesServicioTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableOrderingComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TrabajosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrabajosTable> {
  $$TrabajosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<double> get precioManoObra => $composableBuilder(
      column: $table.precioManoObra, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $$OrdenesServicioTableAnnotationComposer get ordenId {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableAnnotationComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TrabajosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrabajosTable,
    Trabajo,
    $$TrabajosTableFilterComposer,
    $$TrabajosTableOrderingComposer,
    $$TrabajosTableAnnotationComposer,
    $$TrabajosTableCreateCompanionBuilder,
    $$TrabajosTableUpdateCompanionBuilder,
    (Trabajo, $$TrabajosTableReferences),
    Trabajo,
    PrefetchHooks Function({bool ordenId})> {
  $$TrabajosTableTableManager(_$AppDatabase db, $TrabajosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrabajosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrabajosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrabajosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ordenId = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<double> precioManoObra = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
          }) =>
              TrabajosCompanion(
            id: id,
            ordenId: ordenId,
            descripcion: descripcion,
            precioManoObra: precioManoObra,
            fecha: fecha,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ordenId,
            required String descripcion,
            required double precioManoObra,
            Value<DateTime> fecha = const Value.absent(),
          }) =>
              TrabajosCompanion.insert(
            id: id,
            ordenId: ordenId,
            descripcion: descripcion,
            precioManoObra: precioManoObra,
            fecha: fecha,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$TrabajosTable, Trabajo>(table),
                    $$TrabajosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (ordenId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ordenId,
                    referencedTable:
                        $$TrabajosTableReferences._ordenIdTable(db),
                    referencedColumn:
                        $$TrabajosTableReferences._ordenIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TrabajosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrabajosTable,
    Trabajo,
    $$TrabajosTableFilterComposer,
    $$TrabajosTableOrderingComposer,
    $$TrabajosTableAnnotationComposer,
    $$TrabajosTableCreateCompanionBuilder,
    $$TrabajosTableUpdateCompanionBuilder,
    (Trabajo, $$TrabajosTableReferences),
    Trabajo,
    PrefetchHooks Function({bool ordenId})>;
typedef $$RepuestosTableCreateCompanionBuilder = RepuestosCompanion Function({
  Value<int> id,
  required String nombre,
  required String codigo,
  required double precioVenta,
  Value<int> existencias,
  Value<int> stockMinimo,
});
typedef $$RepuestosTableUpdateCompanionBuilder = RepuestosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> codigo,
  Value<double> precioVenta,
  Value<int> existencias,
  Value<int> stockMinimo,
});

final class $$RepuestosTableReferences
    extends BaseReferences<_$AppDatabase, $RepuestosTable, Repuesto> {
  $$RepuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RepuestosUsadosTable, List<RepuestoUsado>>
      _repuestosUsadosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.repuestosUsados,
              aliasName: 'repuestos__id__repuestos_usados__repuesto_id');

  $$RepuestosUsadosTableProcessedTableManager get repuestosUsadosRefs {
    final manager =
        $$RepuestosUsadosTableTableManager($_db, $_db.repuestosUsados)
            .filter((f) => f.repuestoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_repuestosUsadosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RepuestosTableFilterComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioVenta => $composableBuilder(
      column: $table.precioVenta, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get existencias => $composableBuilder(
      column: $table.existencias, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => ColumnFilters(column));

  Expression<bool> repuestosUsadosRefs(
      Expression<bool> Function($$RepuestosUsadosTableFilterComposer f) f) {
    final $$RepuestosUsadosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.repuestosUsados,
        getReferencedColumn: (t) => t.repuestoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosUsadosTableFilterComposer(
              $db: $db,
              $table: $db.repuestosUsados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RepuestosTableOrderingComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioVenta => $composableBuilder(
      column: $table.precioVenta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get existencias => $composableBuilder(
      column: $table.existencias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => ColumnOrderings(column));
}

class $$RepuestosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepuestosTable> {
  $$RepuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<double> get precioVenta => $composableBuilder(
      column: $table.precioVenta, builder: (column) => column);

  GeneratedColumn<int> get existencias => $composableBuilder(
      column: $table.existencias, builder: (column) => column);

  GeneratedColumn<int> get stockMinimo => $composableBuilder(
      column: $table.stockMinimo, builder: (column) => column);

  Expression<T> repuestosUsadosRefs<T extends Object>(
      Expression<T> Function($$RepuestosUsadosTableAnnotationComposer a) f) {
    final $$RepuestosUsadosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.repuestosUsados,
        getReferencedColumn: (t) => t.repuestoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosUsadosTableAnnotationComposer(
              $db: $db,
              $table: $db.repuestosUsados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RepuestosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RepuestosTable,
    Repuesto,
    $$RepuestosTableFilterComposer,
    $$RepuestosTableOrderingComposer,
    $$RepuestosTableAnnotationComposer,
    $$RepuestosTableCreateCompanionBuilder,
    $$RepuestosTableUpdateCompanionBuilder,
    (Repuesto, $$RepuestosTableReferences),
    Repuesto,
    PrefetchHooks Function({bool repuestosUsadosRefs})> {
  $$RepuestosTableTableManager(_$AppDatabase db, $RepuestosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> codigo = const Value.absent(),
            Value<double> precioVenta = const Value.absent(),
            Value<int> existencias = const Value.absent(),
            Value<int> stockMinimo = const Value.absent(),
          }) =>
              RepuestosCompanion(
            id: id,
            nombre: nombre,
            codigo: codigo,
            precioVenta: precioVenta,
            existencias: existencias,
            stockMinimo: stockMinimo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required String codigo,
            required double precioVenta,
            Value<int> existencias = const Value.absent(),
            Value<int> stockMinimo = const Value.absent(),
          }) =>
              RepuestosCompanion.insert(
            id: id,
            nombre: nombre,
            codigo: codigo,
            precioVenta: precioVenta,
            existencias: existencias,
            stockMinimo: stockMinimo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RepuestosTable, Repuesto>(table),
                    $$RepuestosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({repuestosUsadosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (repuestosUsadosRefs) db.repuestosUsados
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (repuestosUsadosRefs)
                    await $_getPrefetchedDataByColumns<
                            Repuesto,
                            $RepuestosTable,
                            RepuestoUsado,
                            $RepuestosUsadosTable>(
                        currentTable: table,
                        referencedTable: $$RepuestosTableReferences
                            ._repuestosUsadosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RepuestosTableReferences(db, table, p0)
                                .repuestosUsadosRefs,
                        currentColumn: 'id',
                        referencedColumn: 'repuesto_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RepuestosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RepuestosTable,
    Repuesto,
    $$RepuestosTableFilterComposer,
    $$RepuestosTableOrderingComposer,
    $$RepuestosTableAnnotationComposer,
    $$RepuestosTableCreateCompanionBuilder,
    $$RepuestosTableUpdateCompanionBuilder,
    (Repuesto, $$RepuestosTableReferences),
    Repuesto,
    PrefetchHooks Function({bool repuestosUsadosRefs})>;
typedef $$RepuestosUsadosTableCreateCompanionBuilder = RepuestosUsadosCompanion
    Function({
  Value<int> id,
  required int ordenId,
  required int repuestoId,
  required int cantidad,
  required double precioUnitario,
});
typedef $$RepuestosUsadosTableUpdateCompanionBuilder = RepuestosUsadosCompanion
    Function({
  Value<int> id,
  Value<int> ordenId,
  Value<int> repuestoId,
  Value<int> cantidad,
  Value<double> precioUnitario,
});

final class $$RepuestosUsadosTableReferences extends BaseReferences<
    _$AppDatabase, $RepuestosUsadosTable, RepuestoUsado> {
  $$RepuestosUsadosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesServicioTable _ordenIdTable(_$AppDatabase db) =>
      db.ordenesServicio
          .createAlias('repuestos_usados__orden_id__ordenes_servicio__id');

  $$OrdenesServicioTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager =
        $$OrdenesServicioTableTableManager($_db, $_db.ordenesServicio)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RepuestosTable _repuestoIdTable(_$AppDatabase db) =>
      db.repuestos.createAlias('repuestos_usados__repuesto_id__repuestos__id');

  $$RepuestosTableProcessedTableManager get repuestoId {
    final $_column = $_itemColumn<int>('repuesto_id')!;

    final manager = $$RepuestosTableTableManager($_db, $_db.repuestos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_repuestoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RepuestosUsadosTableFilterComposer
    extends Composer<_$AppDatabase, $RepuestosUsadosTable> {
  $$RepuestosUsadosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get precioUnitario => $composableBuilder(
      column: $table.precioUnitario,
      builder: (column) => ColumnFilters(column));

  $$OrdenesServicioTableFilterComposer get ordenId {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableFilterComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RepuestosTableFilterComposer get repuestoId {
    final $$RepuestosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.repuestoId,
        referencedTable: $db.repuestos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosTableFilterComposer(
              $db: $db,
              $table: $db.repuestos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RepuestosUsadosTableOrderingComposer
    extends Composer<_$AppDatabase, $RepuestosUsadosTable> {
  $$RepuestosUsadosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cantidad => $composableBuilder(
      column: $table.cantidad, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
      column: $table.precioUnitario,
      builder: (column) => ColumnOrderings(column));

  $$OrdenesServicioTableOrderingComposer get ordenId {
    final $$OrdenesServicioTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableOrderingComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RepuestosTableOrderingComposer get repuestoId {
    final $$RepuestosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.repuestoId,
        referencedTable: $db.repuestos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosTableOrderingComposer(
              $db: $db,
              $table: $db.repuestos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RepuestosUsadosTableAnnotationComposer
    extends Composer<_$AppDatabase, $RepuestosUsadosTable> {
  $$RepuestosUsadosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
      column: $table.precioUnitario, builder: (column) => column);

  $$OrdenesServicioTableAnnotationComposer get ordenId {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableAnnotationComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RepuestosTableAnnotationComposer get repuestoId {
    final $$RepuestosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.repuestoId,
        referencedTable: $db.repuestos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RepuestosTableAnnotationComposer(
              $db: $db,
              $table: $db.repuestos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RepuestosUsadosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RepuestosUsadosTable,
    RepuestoUsado,
    $$RepuestosUsadosTableFilterComposer,
    $$RepuestosUsadosTableOrderingComposer,
    $$RepuestosUsadosTableAnnotationComposer,
    $$RepuestosUsadosTableCreateCompanionBuilder,
    $$RepuestosUsadosTableUpdateCompanionBuilder,
    (RepuestoUsado, $$RepuestosUsadosTableReferences),
    RepuestoUsado,
    PrefetchHooks Function({bool ordenId, bool repuestoId})> {
  $$RepuestosUsadosTableTableManager(
      _$AppDatabase db, $RepuestosUsadosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepuestosUsadosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepuestosUsadosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepuestosUsadosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ordenId = const Value.absent(),
            Value<int> repuestoId = const Value.absent(),
            Value<int> cantidad = const Value.absent(),
            Value<double> precioUnitario = const Value.absent(),
          }) =>
              RepuestosUsadosCompanion(
            id: id,
            ordenId: ordenId,
            repuestoId: repuestoId,
            cantidad: cantidad,
            precioUnitario: precioUnitario,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ordenId,
            required int repuestoId,
            required int cantidad,
            required double precioUnitario,
          }) =>
              RepuestosUsadosCompanion.insert(
            id: id,
            ordenId: ordenId,
            repuestoId: repuestoId,
            cantidad: cantidad,
            precioUnitario: precioUnitario,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RepuestosUsadosTable, RepuestoUsado>(table),
                    $$RepuestosUsadosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordenId = false, repuestoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (ordenId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ordenId,
                    referencedTable:
                        $$RepuestosUsadosTableReferences._ordenIdTable(db),
                    referencedColumn:
                        $$RepuestosUsadosTableReferences._ordenIdTable(db).id,
                  ) as T;
                }
                if (repuestoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.repuestoId,
                    referencedTable:
                        $$RepuestosUsadosTableReferences._repuestoIdTable(db),
                    referencedColumn: $$RepuestosUsadosTableReferences
                        ._repuestoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RepuestosUsadosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RepuestosUsadosTable,
    RepuestoUsado,
    $$RepuestosUsadosTableFilterComposer,
    $$RepuestosUsadosTableOrderingComposer,
    $$RepuestosUsadosTableAnnotationComposer,
    $$RepuestosUsadosTableCreateCompanionBuilder,
    $$RepuestosUsadosTableUpdateCompanionBuilder,
    (RepuestoUsado, $$RepuestosUsadosTableReferences),
    RepuestoUsado,
    PrefetchHooks Function({bool ordenId, bool repuestoId})>;
typedef $$PagosTableCreateCompanionBuilder = PagosCompanion Function({
  Value<int> id,
  required int ordenId,
  required double monto,
  Value<DateTime> fecha,
  Value<String?> nota,
});
typedef $$PagosTableUpdateCompanionBuilder = PagosCompanion Function({
  Value<int> id,
  Value<int> ordenId,
  Value<double> monto,
  Value<DateTime> fecha,
  Value<String?> nota,
});

final class $$PagosTableReferences
    extends BaseReferences<_$AppDatabase, $PagosTable, Pago> {
  $$PagosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdenesServicioTable _ordenIdTable(_$AppDatabase db) =>
      db.ordenesServicio.createAlias('pagos__orden_id__ordenes_servicio__id');

  $$OrdenesServicioTableProcessedTableManager get ordenId {
    final $_column = $_itemColumn<int>('orden_id')!;

    final manager =
        $$OrdenesServicioTableTableManager($_db, $_db.ordenesServicio)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ordenIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PagosTableFilterComposer extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnFilters(column));

  $$OrdenesServicioTableFilterComposer get ordenId {
    final $$OrdenesServicioTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableFilterComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PagosTableOrderingComposer
    extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get monto => $composableBuilder(
      column: $table.monto, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
      column: $table.fecha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nota => $composableBuilder(
      column: $table.nota, builder: (column) => ColumnOrderings(column));

  $$OrdenesServicioTableOrderingComposer get ordenId {
    final $$OrdenesServicioTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableOrderingComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PagosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PagosTable> {
  $$PagosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get monto =>
      $composableBuilder(column: $table.monto, builder: (column) => column);

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  $$OrdenesServicioTableAnnotationComposer get ordenId {
    final $$OrdenesServicioTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ordenId,
        referencedTable: $db.ordenesServicio,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdenesServicioTableAnnotationComposer(
              $db: $db,
              $table: $db.ordenesServicio,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PagosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PagosTable,
    Pago,
    $$PagosTableFilterComposer,
    $$PagosTableOrderingComposer,
    $$PagosTableAnnotationComposer,
    $$PagosTableCreateCompanionBuilder,
    $$PagosTableUpdateCompanionBuilder,
    (Pago, $$PagosTableReferences),
    Pago,
    PrefetchHooks Function({bool ordenId})> {
  $$PagosTableTableManager(_$AppDatabase db, $PagosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PagosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PagosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PagosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ordenId = const Value.absent(),
            Value<double> monto = const Value.absent(),
            Value<DateTime> fecha = const Value.absent(),
            Value<String?> nota = const Value.absent(),
          }) =>
              PagosCompanion(
            id: id,
            ordenId: ordenId,
            monto: monto,
            fecha: fecha,
            nota: nota,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ordenId,
            required double monto,
            Value<DateTime> fecha = const Value.absent(),
            Value<String?> nota = const Value.absent(),
          }) =>
              PagosCompanion.insert(
            id: id,
            ordenId: ordenId,
            monto: monto,
            fecha: fecha,
            nota: nota,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$PagosTable, Pago>(table),
                    $$PagosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ordenId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (ordenId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ordenId,
                    referencedTable: $$PagosTableReferences._ordenIdTable(db),
                    referencedColumn:
                        $$PagosTableReferences._ordenIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PagosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PagosTable,
    Pago,
    $$PagosTableFilterComposer,
    $$PagosTableOrderingComposer,
    $$PagosTableAnnotationComposer,
    $$PagosTableCreateCompanionBuilder,
    $$PagosTableUpdateCompanionBuilder,
    (Pago, $$PagosTableReferences),
    Pago,
    PrefetchHooks Function({bool ordenId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$VehiculosTableTableManager get vehiculos =>
      $$VehiculosTableTableManager(_db, _db.vehiculos);
  $$MecanicosTableTableManager get mecanicos =>
      $$MecanicosTableTableManager(_db, _db.mecanicos);
  $$OrdenesServicioTableTableManager get ordenesServicio =>
      $$OrdenesServicioTableTableManager(_db, _db.ordenesServicio);
  $$TrabajosTableTableManager get trabajos =>
      $$TrabajosTableTableManager(_db, _db.trabajos);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db, _db.repuestos);
  $$RepuestosUsadosTableTableManager get repuestosUsados =>
      $$RepuestosUsadosTableTableManager(_db, _db.repuestosUsados);
  $$PagosTableTableManager get pagos =>
      $$PagosTableTableManager(_db, _db.pagos);
}
