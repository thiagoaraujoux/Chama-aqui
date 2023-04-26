import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/usuario.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('usuarios.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT,
        senha TEXT
      )
    ''');
  }

  Future<int> createUser(Usuario usuario) async {
    final db = await instance.database;

    return await db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> getUser(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      'usuarios',
      columns: ['id', 'nome', 'email', 'senha'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Usuario>> getAllUsers() async {
    final db = await instance.database;

    final orderBy = 'nome ASC';
    final result = await db.query('usuarios', orderBy: orderBy);

    return result.map((map) => Usuario.fromMap(map)).toList();
  }

  Future<int> updateUser(Usuario usuario) async {
    final db = await instance.database;

    return db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;

    return await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Usuario?> loginUser(String email, String senha) async {
    final db = await instance.database;

    final maps = await db.query(
      'usuarios',
      columns: ['id', 'nome', 'email', 'senha'],
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    } else {
      return null;
    }
  }
}