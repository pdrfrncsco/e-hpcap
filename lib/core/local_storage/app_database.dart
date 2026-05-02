import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class HinosTable extends Table {
  IntColumn get id => integer()();
  IntColumn get numero => integer()();
  TextColumn get titulo => text()();
  TextColumn get secao => text()();
  TextColumn get temasJson => text().named('temas_json')();
  TextColumn get hinoJson => text().named('hino_json')();
  BoolColumn get isDetalhado => boolean().withDefault(const Constant(false)).named('is_detalhado')();

  @override
  Set<Column> get primaryKey => {id};
}

class TemasTable extends Table {
  IntColumn get id => integer()();
  TextColumn get nome => text()();
  TextColumn get slug => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class TextosLiturgicosTable extends Table {
  IntColumn get id => integer()();
  TextColumn get tipo => text()();
  TextColumn get tipoDisplay => text()();
  TextColumn get idioma => text().nullable()();
  TextColumn get titulo => text()();
  TextColumn get conteudo => text()();
  IntColumn get ordem => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [HinosTable, TemasTable, TextosLiturgicosTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(textosLiturgicosTable);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'hpc_database',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
