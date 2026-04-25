import 'dart:convert';
import 'package:drift/drift.dart';
import 'app_database.dart';
import '../../features/hinario/domain/models/hino.dart';
import '../../features/hinario/domain/models/tema.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  final AppDatabase _db;

  factory DatabaseService() => _instance;

  DatabaseService._internal() : _db = AppDatabase();

  Future<void> saveHinos(List<Hino> hinos) async {
    // Para evitar apagar letras já descarregadas ao receber uma lista simples da API,
    // verificamos hino a hino.
    for (final hino in hinos) {
      final existing = await (_db.select(_db.hinosTable)..where((t) => t.id.equals(hino.id))).getSingleOrNull();
      
      // Só substituímos se o novo for detalhado OU se o antigo não for detalhado
      final deveSubstituir = existing == null || hino.estrofes != null || !existing.isDetalhado;

      if (deveSubstituir) {
        await _db.into(_db.hinosTable).insertOnConflictUpdate(
          HinosTableCompanion.insert(
            id: Value(hino.id),
            numero: hino.numero,
            titulo: hino.titulo,
            secao: hino.secao,
            temasJson: jsonEncode(hino.temas.map((t) => t.toJson()).toList()),
            hinoJson: jsonEncode(hino.toJson()),
            isDetalhado: Value(hino.estrofes != null),
          ),
        );
      }
    }
  }

  Future<List<Hino>> searchHinosLocal(String query, {String? secao}) async {
    final driftQuery = _db.select(_db.hinosTable);
    
    driftQuery.where((t) {
      final match = t.titulo.contains(query) | 
                    t.numero.cast<String>().contains(query) |
                    t.hinoJson.contains(query);
      
      if (secao != null) {
        return match & t.secao.equals(secao);
      }
      return match;
    });

    driftQuery.orderBy([(t) => OrderingTerm(expression: t.numero)]);
    final rows = await driftQuery.get();

    return rows.map((row) {
      return Hino.fromJson(jsonDecode(row.hinoJson) as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Hino>> getHinos({String? secao, String? temaSlug}) async {
    final query = _db.select(_db.hinosTable);
    
    if (secao != null) {
      query.where((t) => t.secao.equals(secao));
    }
    
    if (temaSlug != null) {
      query.where((t) => t.temasJson.like('%"slug":"$temaSlug"%'));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.numero)]);

    final rows = await query.get();

    return rows.map((row) {
      return Hino.fromJson(jsonDecode(row.hinoJson) as Map<String, dynamic>);
    }).toList();
  }

  Future<Hino?> getHinoDetalhe(int id) async {
    final query = _db.select(_db.hinosTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.isDetalhado.equals(true));

    final row = await query.getSingleOrNull();

    if (row != null) {
      return Hino.fromJson(jsonDecode(row.hinoJson) as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> saveTemas(List<Tema> temas) async {
    await _db.batch((batch) {
      for (final tema in temas) {
        batch.insert(
          _db.temasTable,
          TemasTableCompanion.insert(
            id: Value(tema.id),
            nome: tema.nome,
            slug: tema.slug,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<Tema>> getTemas() async {
    final query = _db.select(_db.temasTable)
      ..orderBy([(t) => OrderingTerm(expression: t.nome)]);

    final rows = await query.get();

    return rows.map((row) {
      return Tema(
        id: row.id,
        nome: row.nome,
        slug: row.slug,
      );
    }).toList();
  }

  Future<void> clearAll() async {
    await _db.delete(_db.hinosTable).go();
    await _db.delete(_db.temasTable).go();
  }
}
