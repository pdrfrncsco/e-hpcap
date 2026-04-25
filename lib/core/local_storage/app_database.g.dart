// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HinosTableTable extends HinosTable
    with TableInfo<$HinosTableTable, HinosTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HinosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
      'numero', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
      'titulo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _secaoMeta = const VerificationMeta('secao');
  @override
  late final GeneratedColumn<String> secao = GeneratedColumn<String>(
      'secao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _temasJsonMeta =
      const VerificationMeta('temasJson');
  @override
  late final GeneratedColumn<String> temasJson = GeneratedColumn<String>(
      'temas_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hinoJsonMeta =
      const VerificationMeta('hinoJson');
  @override
  late final GeneratedColumn<String> hinoJson = GeneratedColumn<String>(
      'hino_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDetalhadoMeta =
      const VerificationMeta('isDetalhado');
  @override
  late final GeneratedColumn<bool> isDetalhado = GeneratedColumn<bool>(
      'is_detalhado', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_detalhado" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, numero, titulo, secao, temasJson, hinoJson, isDetalhado];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hinos_table';
  @override
  VerificationContext validateIntegrity(Insertable<HinosTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('titulo')) {
      context.handle(_tituloMeta,
          titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta));
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('secao')) {
      context.handle(
          _secaoMeta, secao.isAcceptableOrUnknown(data['secao']!, _secaoMeta));
    } else if (isInserting) {
      context.missing(_secaoMeta);
    }
    if (data.containsKey('temas_json')) {
      context.handle(_temasJsonMeta,
          temasJson.isAcceptableOrUnknown(data['temas_json']!, _temasJsonMeta));
    } else if (isInserting) {
      context.missing(_temasJsonMeta);
    }
    if (data.containsKey('hino_json')) {
      context.handle(_hinoJsonMeta,
          hinoJson.isAcceptableOrUnknown(data['hino_json']!, _hinoJsonMeta));
    } else if (isInserting) {
      context.missing(_hinoJsonMeta);
    }
    if (data.containsKey('is_detalhado')) {
      context.handle(
          _isDetalhadoMeta,
          isDetalhado.isAcceptableOrUnknown(
              data['is_detalhado']!, _isDetalhadoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HinosTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HinosTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero'])!,
      titulo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}titulo'])!,
      secao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}secao'])!,
      temasJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}temas_json'])!,
      hinoJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hino_json'])!,
      isDetalhado: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_detalhado'])!,
    );
  }

  @override
  $HinosTableTable createAlias(String alias) {
    return $HinosTableTable(attachedDatabase, alias);
  }
}

class HinosTableData extends DataClass implements Insertable<HinosTableData> {
  final int id;
  final int numero;
  final String titulo;
  final String secao;
  final String temasJson;
  final String hinoJson;
  final bool isDetalhado;
  const HinosTableData(
      {required this.id,
      required this.numero,
      required this.titulo,
      required this.secao,
      required this.temasJson,
      required this.hinoJson,
      required this.isDetalhado});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['numero'] = Variable<int>(numero);
    map['titulo'] = Variable<String>(titulo);
    map['secao'] = Variable<String>(secao);
    map['temas_json'] = Variable<String>(temasJson);
    map['hino_json'] = Variable<String>(hinoJson);
    map['is_detalhado'] = Variable<bool>(isDetalhado);
    return map;
  }

  HinosTableCompanion toCompanion(bool nullToAbsent) {
    return HinosTableCompanion(
      id: Value(id),
      numero: Value(numero),
      titulo: Value(titulo),
      secao: Value(secao),
      temasJson: Value(temasJson),
      hinoJson: Value(hinoJson),
      isDetalhado: Value(isDetalhado),
    );
  }

  factory HinosTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HinosTableData(
      id: serializer.fromJson<int>(json['id']),
      numero: serializer.fromJson<int>(json['numero']),
      titulo: serializer.fromJson<String>(json['titulo']),
      secao: serializer.fromJson<String>(json['secao']),
      temasJson: serializer.fromJson<String>(json['temasJson']),
      hinoJson: serializer.fromJson<String>(json['hinoJson']),
      isDetalhado: serializer.fromJson<bool>(json['isDetalhado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numero': serializer.toJson<int>(numero),
      'titulo': serializer.toJson<String>(titulo),
      'secao': serializer.toJson<String>(secao),
      'temasJson': serializer.toJson<String>(temasJson),
      'hinoJson': serializer.toJson<String>(hinoJson),
      'isDetalhado': serializer.toJson<bool>(isDetalhado),
    };
  }

  HinosTableData copyWith(
          {int? id,
          int? numero,
          String? titulo,
          String? secao,
          String? temasJson,
          String? hinoJson,
          bool? isDetalhado}) =>
      HinosTableData(
        id: id ?? this.id,
        numero: numero ?? this.numero,
        titulo: titulo ?? this.titulo,
        secao: secao ?? this.secao,
        temasJson: temasJson ?? this.temasJson,
        hinoJson: hinoJson ?? this.hinoJson,
        isDetalhado: isDetalhado ?? this.isDetalhado,
      );
  HinosTableData copyWithCompanion(HinosTableCompanion data) {
    return HinosTableData(
      id: data.id.present ? data.id.value : this.id,
      numero: data.numero.present ? data.numero.value : this.numero,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      secao: data.secao.present ? data.secao.value : this.secao,
      temasJson: data.temasJson.present ? data.temasJson.value : this.temasJson,
      hinoJson: data.hinoJson.present ? data.hinoJson.value : this.hinoJson,
      isDetalhado:
          data.isDetalhado.present ? data.isDetalhado.value : this.isDetalhado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HinosTableData(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('titulo: $titulo, ')
          ..write('secao: $secao, ')
          ..write('temasJson: $temasJson, ')
          ..write('hinoJson: $hinoJson, ')
          ..write('isDetalhado: $isDetalhado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, numero, titulo, secao, temasJson, hinoJson, isDetalhado);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HinosTableData &&
          other.id == this.id &&
          other.numero == this.numero &&
          other.titulo == this.titulo &&
          other.secao == this.secao &&
          other.temasJson == this.temasJson &&
          other.hinoJson == this.hinoJson &&
          other.isDetalhado == this.isDetalhado);
}

class HinosTableCompanion extends UpdateCompanion<HinosTableData> {
  final Value<int> id;
  final Value<int> numero;
  final Value<String> titulo;
  final Value<String> secao;
  final Value<String> temasJson;
  final Value<String> hinoJson;
  final Value<bool> isDetalhado;
  const HinosTableCompanion({
    this.id = const Value.absent(),
    this.numero = const Value.absent(),
    this.titulo = const Value.absent(),
    this.secao = const Value.absent(),
    this.temasJson = const Value.absent(),
    this.hinoJson = const Value.absent(),
    this.isDetalhado = const Value.absent(),
  });
  HinosTableCompanion.insert({
    this.id = const Value.absent(),
    required int numero,
    required String titulo,
    required String secao,
    required String temasJson,
    required String hinoJson,
    this.isDetalhado = const Value.absent(),
  })  : numero = Value(numero),
        titulo = Value(titulo),
        secao = Value(secao),
        temasJson = Value(temasJson),
        hinoJson = Value(hinoJson);
  static Insertable<HinosTableData> custom({
    Expression<int>? id,
    Expression<int>? numero,
    Expression<String>? titulo,
    Expression<String>? secao,
    Expression<String>? temasJson,
    Expression<String>? hinoJson,
    Expression<bool>? isDetalhado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numero != null) 'numero': numero,
      if (titulo != null) 'titulo': titulo,
      if (secao != null) 'secao': secao,
      if (temasJson != null) 'temas_json': temasJson,
      if (hinoJson != null) 'hino_json': hinoJson,
      if (isDetalhado != null) 'is_detalhado': isDetalhado,
    });
  }

  HinosTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? numero,
      Value<String>? titulo,
      Value<String>? secao,
      Value<String>? temasJson,
      Value<String>? hinoJson,
      Value<bool>? isDetalhado}) {
    return HinosTableCompanion(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      titulo: titulo ?? this.titulo,
      secao: secao ?? this.secao,
      temasJson: temasJson ?? this.temasJson,
      hinoJson: hinoJson ?? this.hinoJson,
      isDetalhado: isDetalhado ?? this.isDetalhado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (secao.present) {
      map['secao'] = Variable<String>(secao.value);
    }
    if (temasJson.present) {
      map['temas_json'] = Variable<String>(temasJson.value);
    }
    if (hinoJson.present) {
      map['hino_json'] = Variable<String>(hinoJson.value);
    }
    if (isDetalhado.present) {
      map['is_detalhado'] = Variable<bool>(isDetalhado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HinosTableCompanion(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('titulo: $titulo, ')
          ..write('secao: $secao, ')
          ..write('temasJson: $temasJson, ')
          ..write('hinoJson: $hinoJson, ')
          ..write('isDetalhado: $isDetalhado')
          ..write(')'))
        .toString();
  }
}

class $TemasTableTable extends TemasTable
    with TableInfo<$TemasTableTable, TemasTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemasTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nome, slug];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'temas_table';
  @override
  VerificationContext validateIntegrity(Insertable<TemasTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemasTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemasTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
    );
  }

  @override
  $TemasTableTable createAlias(String alias) {
    return $TemasTableTable(attachedDatabase, alias);
  }
}

class TemasTableData extends DataClass implements Insertable<TemasTableData> {
  final int id;
  final String nome;
  final String slug;
  const TemasTableData(
      {required this.id, required this.nome, required this.slug});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['slug'] = Variable<String>(slug);
    return map;
  }

  TemasTableCompanion toCompanion(bool nullToAbsent) {
    return TemasTableCompanion(
      id: Value(id),
      nome: Value(nome),
      slug: Value(slug),
    );
  }

  factory TemasTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemasTableData(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      slug: serializer.fromJson<String>(json['slug']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'slug': serializer.toJson<String>(slug),
    };
  }

  TemasTableData copyWith({int? id, String? nome, String? slug}) =>
      TemasTableData(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        slug: slug ?? this.slug,
      );
  TemasTableData copyWithCompanion(TemasTableCompanion data) {
    return TemasTableData(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      slug: data.slug.present ? data.slug.value : this.slug,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemasTableData(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('slug: $slug')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, slug);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemasTableData &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.slug == this.slug);
}

class TemasTableCompanion extends UpdateCompanion<TemasTableData> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> slug;
  const TemasTableCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.slug = const Value.absent(),
  });
  TemasTableCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String slug,
  })  : nome = Value(nome),
        slug = Value(slug);
  static Insertable<TemasTableData> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? slug,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (slug != null) 'slug': slug,
    });
  }

  TemasTableCompanion copyWith(
      {Value<int>? id, Value<String>? nome, Value<String>? slug}) {
    return TemasTableCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      slug: slug ?? this.slug,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemasTableCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('slug: $slug')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HinosTableTable hinosTable = $HinosTableTable(this);
  late final $TemasTableTable temasTable = $TemasTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [hinosTable, temasTable];
}

typedef $$HinosTableTableCreateCompanionBuilder = HinosTableCompanion Function({
  Value<int> id,
  required int numero,
  required String titulo,
  required String secao,
  required String temasJson,
  required String hinoJson,
  Value<bool> isDetalhado,
});
typedef $$HinosTableTableUpdateCompanionBuilder = HinosTableCompanion Function({
  Value<int> id,
  Value<int> numero,
  Value<String> titulo,
  Value<String> secao,
  Value<String> temasJson,
  Value<String> hinoJson,
  Value<bool> isDetalhado,
});

class $$HinosTableTableFilterComposer
    extends Composer<_$AppDatabase, $HinosTableTable> {
  $$HinosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titulo => $composableBuilder(
      column: $table.titulo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get secao => $composableBuilder(
      column: $table.secao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get temasJson => $composableBuilder(
      column: $table.temasJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hinoJson => $composableBuilder(
      column: $table.hinoJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDetalhado => $composableBuilder(
      column: $table.isDetalhado, builder: (column) => ColumnFilters(column));
}

class $$HinosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HinosTableTable> {
  $$HinosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titulo => $composableBuilder(
      column: $table.titulo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secao => $composableBuilder(
      column: $table.secao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get temasJson => $composableBuilder(
      column: $table.temasJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hinoJson => $composableBuilder(
      column: $table.hinoJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDetalhado => $composableBuilder(
      column: $table.isDetalhado, builder: (column) => ColumnOrderings(column));
}

class $$HinosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HinosTableTable> {
  $$HinosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get secao =>
      $composableBuilder(column: $table.secao, builder: (column) => column);

  GeneratedColumn<String> get temasJson =>
      $composableBuilder(column: $table.temasJson, builder: (column) => column);

  GeneratedColumn<String> get hinoJson =>
      $composableBuilder(column: $table.hinoJson, builder: (column) => column);

  GeneratedColumn<bool> get isDetalhado => $composableBuilder(
      column: $table.isDetalhado, builder: (column) => column);
}

class $$HinosTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HinosTableTable,
    HinosTableData,
    $$HinosTableTableFilterComposer,
    $$HinosTableTableOrderingComposer,
    $$HinosTableTableAnnotationComposer,
    $$HinosTableTableCreateCompanionBuilder,
    $$HinosTableTableUpdateCompanionBuilder,
    (
      HinosTableData,
      BaseReferences<_$AppDatabase, $HinosTableTable, HinosTableData>
    ),
    HinosTableData,
    PrefetchHooks Function()> {
  $$HinosTableTableTableManager(_$AppDatabase db, $HinosTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HinosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HinosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HinosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> numero = const Value.absent(),
            Value<String> titulo = const Value.absent(),
            Value<String> secao = const Value.absent(),
            Value<String> temasJson = const Value.absent(),
            Value<String> hinoJson = const Value.absent(),
            Value<bool> isDetalhado = const Value.absent(),
          }) =>
              HinosTableCompanion(
            id: id,
            numero: numero,
            titulo: titulo,
            secao: secao,
            temasJson: temasJson,
            hinoJson: hinoJson,
            isDetalhado: isDetalhado,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int numero,
            required String titulo,
            required String secao,
            required String temasJson,
            required String hinoJson,
            Value<bool> isDetalhado = const Value.absent(),
          }) =>
              HinosTableCompanion.insert(
            id: id,
            numero: numero,
            titulo: titulo,
            secao: secao,
            temasJson: temasJson,
            hinoJson: hinoJson,
            isDetalhado: isDetalhado,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HinosTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HinosTableTable,
    HinosTableData,
    $$HinosTableTableFilterComposer,
    $$HinosTableTableOrderingComposer,
    $$HinosTableTableAnnotationComposer,
    $$HinosTableTableCreateCompanionBuilder,
    $$HinosTableTableUpdateCompanionBuilder,
    (
      HinosTableData,
      BaseReferences<_$AppDatabase, $HinosTableTable, HinosTableData>
    ),
    HinosTableData,
    PrefetchHooks Function()>;
typedef $$TemasTableTableCreateCompanionBuilder = TemasTableCompanion Function({
  Value<int> id,
  required String nome,
  required String slug,
});
typedef $$TemasTableTableUpdateCompanionBuilder = TemasTableCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String> slug,
});

class $$TemasTableTableFilterComposer
    extends Composer<_$AppDatabase, $TemasTableTable> {
  $$TemasTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));
}

class $$TemasTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TemasTableTable> {
  $$TemasTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));
}

class $$TemasTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemasTableTable> {
  $$TemasTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);
}

class $$TemasTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TemasTableTable,
    TemasTableData,
    $$TemasTableTableFilterComposer,
    $$TemasTableTableOrderingComposer,
    $$TemasTableTableAnnotationComposer,
    $$TemasTableTableCreateCompanionBuilder,
    $$TemasTableTableUpdateCompanionBuilder,
    (
      TemasTableData,
      BaseReferences<_$AppDatabase, $TemasTableTable, TemasTableData>
    ),
    TemasTableData,
    PrefetchHooks Function()> {
  $$TemasTableTableTableManager(_$AppDatabase db, $TemasTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemasTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemasTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemasTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> slug = const Value.absent(),
          }) =>
              TemasTableCompanion(
            id: id,
            nome: nome,
            slug: slug,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            required String slug,
          }) =>
              TemasTableCompanion.insert(
            id: id,
            nome: nome,
            slug: slug,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TemasTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TemasTableTable,
    TemasTableData,
    $$TemasTableTableFilterComposer,
    $$TemasTableTableOrderingComposer,
    $$TemasTableTableAnnotationComposer,
    $$TemasTableTableCreateCompanionBuilder,
    $$TemasTableTableUpdateCompanionBuilder,
    (
      TemasTableData,
      BaseReferences<_$AppDatabase, $TemasTableTable, TemasTableData>
    ),
    TemasTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HinosTableTableTableManager get hinosTable =>
      $$HinosTableTableTableManager(_db, _db.hinosTable);
  $$TemasTableTableTableManager get temasTable =>
      $$TemasTableTableTableManager(_db, _db.temasTable);
}
