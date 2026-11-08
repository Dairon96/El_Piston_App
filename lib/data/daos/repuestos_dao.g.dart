// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repuestos_dao.dart';

// ignore_for_file: type=lint
mixin _$RepuestosDaoMixin on DatabaseAccessor<AppDatabase> {
  $RepuestosTable get repuestos => attachedDatabase.repuestos;
  RepuestosDaoManager get managers => RepuestosDaoManager(this);
}

class RepuestosDaoManager {
  final _$RepuestosDaoMixin _db;
  RepuestosDaoManager(this._db);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db.attachedDatabase, _db.repuestos);
}
