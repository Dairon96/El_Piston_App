// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordenes_dao.dart';

// ignore_for_file: type=lint
mixin _$OrdenesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientesTable get clientes => attachedDatabase.clientes;
  $VehiculosTable get vehiculos => attachedDatabase.vehiculos;
  $MecanicosTable get mecanicos => attachedDatabase.mecanicos;
  $OrdenesServicioTable get ordenesServicio => attachedDatabase.ordenesServicio;
  $TrabajosTable get trabajos => attachedDatabase.trabajos;
  $RepuestosTable get repuestos => attachedDatabase.repuestos;
  $RepuestosUsadosTable get repuestosUsados => attachedDatabase.repuestosUsados;
  $PagosTable get pagos => attachedDatabase.pagos;
  OrdenesDaoManager get managers => OrdenesDaoManager(this);
}

class OrdenesDaoManager {
  final _$OrdenesDaoMixin _db;
  OrdenesDaoManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db.attachedDatabase, _db.clientes);
  $$VehiculosTableTableManager get vehiculos =>
      $$VehiculosTableTableManager(_db.attachedDatabase, _db.vehiculos);
  $$MecanicosTableTableManager get mecanicos =>
      $$MecanicosTableTableManager(_db.attachedDatabase, _db.mecanicos);
  $$OrdenesServicioTableTableManager get ordenesServicio =>
      $$OrdenesServicioTableTableManager(
          _db.attachedDatabase, _db.ordenesServicio);
  $$TrabajosTableTableManager get trabajos =>
      $$TrabajosTableTableManager(_db.attachedDatabase, _db.trabajos);
  $$RepuestosTableTableManager get repuestos =>
      $$RepuestosTableTableManager(_db.attachedDatabase, _db.repuestos);
  $$RepuestosUsadosTableTableManager get repuestosUsados =>
      $$RepuestosUsadosTableTableManager(
          _db.attachedDatabase, _db.repuestosUsados);
  $$PagosTableTableManager get pagos =>
      $$PagosTableTableManager(_db.attachedDatabase, _db.pagos);
}
