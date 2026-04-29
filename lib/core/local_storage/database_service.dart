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

  /// Guarda uma lista de hinos de forma atómica.
  Future<void> saveHinos(List<Hino> hinos) async {
    final ids = hinos.map((h) => h.id).toList();
    final existingRows = await (_db.select(_db.hinosTable)..where((t) => t.id.isIn(ids))).get();
    
    final Map<int, bool> existingIsDetalhado = {
      for (var row in existingRows) row.id: row.isDetalhado
    };

    await _db.batch((batch) {
      for (final hino in hinos) {
        final isLocalDetalhado = existingIsDetalhado[hino.id] ?? false;
        final isNovoDetalhado = hino.estrofes != null && hino.estrofes!.isNotEmpty;

        final deveSubstituir = !existingIsDetalhado.containsKey(hino.id) || isNovoDetalhado || !isLocalDetalhado;

        if (deveSubstituir) {
          batch.insert(
            _db.hinosTable,
            HinosTableCompanion.insert(
              id: Value(hino.id),
              numero: hino.numero,
              titulo: hino.titulo,
              secao: hino.secao,
              temasJson: jsonEncode(hino.temas.map((t) => t.toJson()).toList()),
              hinoJson: jsonEncode(hino.toJson()),
              isDetalhado: Value(isNovoDetalhado),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
    });
  }

  /// Pesquisa hinos localmente com lógica mais robusta.
  Future<List<Hino>> searchHinosLocal(String query, {String? secao}) async {
    if (query.isEmpty) return [];
    
    final cleanQuery = query.toLowerCase().trim();
    final driftQuery = _db.select(_db.hinosTable);
    
    driftQuery.where((t) {
      // Usamos LIKE explicitly para maior compatibilidade e flexibilidade
      final match = t.titulo.lower().like('%$cleanQuery%') | 
                    t.numero.cast<String>().like('%$cleanQuery%') |
                    t.hinoJson.lower().like('%$cleanQuery%');
      
      if (secao != null && secao.isNotEmpty) {
        return match & t.secao.equals(secao);
      }
      return match;
    });

    driftQuery.orderBy([
      (t) => OrderingTerm(
        expression: t.titulo.lower().like('$cleanQuery%'), 
        mode: OrderingMode.desc
      ),
      (t) => OrderingTerm(expression: t.numero),
    ]);

    final rows = await driftQuery.get();
    return rows.map((row) => _mapRowToHino(row)).toList();
  }

  Future<List<Hino>> getHinos({String? secao, String? temaSlug}) async {
    final query = _db.select(_db.hinosTable);
    
    if (secao != null && secao.isNotEmpty) {
      query.where((t) => t.secao.equals(secao));
    }
    
    if (temaSlug != null && temaSlug.isNotEmpty) {
      query.where((t) => t.temasJson.like('%"slug":"$temaSlug"%'));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.numero)]);

    final rows = await query.get();
    return rows.map((row) => _mapRowToHino(row)).toList();
  }

  /// Retorna um Stream de hinos que actualiza automaticamente quando o banco muda.
  Stream<List<Hino>> watchHinos({String? secao, String? temaSlug}) {
    final query = _db.select(_db.hinosTable);
    
    if (secao != null && secao.isNotEmpty) {
      query.where((t) => t.secao.equals(secao));
    }
    
    if (temaSlug != null && temaSlug.isNotEmpty) {
      query.where((t) => t.temasJson.like('%"slug":"$temaSlug"%'));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.numero)]);

    return query.watch().map((rows) => rows.map((row) => _mapRowToHino(row)).toList());
  }

  Future<Hino?> getHinoDetalhe(int id) async {
    final query = _db.select(_db.hinosTable)
      ..where((t) => t.id.equals(id))
      ..where((t) => t.isDetalhado.equals(true));

    final row = await query.getSingleOrNull();
    return row != null ? _mapRowToHino(row) : null;
  }

  Hino _mapRowToHino(HinosTableData row) {
    return Hino.fromJson(jsonDecode(row.hinoJson) as Map<String, dynamic>);
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
