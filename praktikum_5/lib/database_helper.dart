import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = kIsWeb
        ? 'expense_tracker.db'
        : join(await getDatabasesPath(), 'expense_tracker.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT, email TEXT UNIQUE, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE transactions('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'user_id INTEGER, title TEXT, amount INTEGER, '
          'category TEXT, date TEXT)',
        );
      },
    );
  }

  static Future<bool> register(String name, String email, String password) async {
    final db = await database;
    final existing = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (existing.isNotEmpty) return false;

    await db.insert('users', {'name': name, 'email': email, 'password': password});
    return true;
  }

  static Future<User?> login(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isEmpty) return null;
    return User.fromMap(result.first);
  }

  static Future<void> insertTransaction(TransactionItem transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
  }

  static Future<List<TransactionItem>> getTransactions(int userId) async {
    final db = await database;
    final result = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
    return result.map((map) => TransactionItem.fromMap(map)).toList();
  }

  static Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
