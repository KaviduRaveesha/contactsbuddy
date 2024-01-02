import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Contact {
  int? id;
  String name;
  String number;
  String email;

  Contact({this.id, required this.name, required this.number, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'email': email,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      number: map['number'],
      email: map['email'],
    );
  }

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, number: $number, email: $email}';
  }
}

class DatabaseHandler {
  late Database _database;

  Future<void> initializeDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'contacts.db');

    // open/create the database at a given path
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // create the Contacts table
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        number TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    await initializeDatabase();
    return await _database.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> retrieveContacts() async {
    await initializeDatabase();
    List<Map<String, dynamic>> maps = await _database.query('contacts');
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        number: maps[i]['number'],
        email: maps[i]['email'],
      );
    });
  }

  Future<void> updateContact(Contact contact) async {
    await initializeDatabase();
    await _database.update(
      'contacts',
      contact.toMap(),
      where: "id = ?",
      whereArgs: [contact.id],
    );
  }

  Future<void> deleteContact(int id) async {
    await initializeDatabase();
    await _database.delete(
      'contacts',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>> getDataById(int id) async {
    await initializeDatabase();
    List<Map<String, dynamic>> result = await _database.query(
      'contacts',
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {};
    }
  }
}
