import 'package:shield/Database/Database_Model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:uuid/uuid.dart';

class Database {
  // Database Connection
  static Future<sql.Database> setDatabase() async {
    return await sql.openDatabase("safe.db", version: 1,
        onCreate: (db, version) {
      db.execute("CREATE TABLE IF NOT EXISTS USER ("
          "NAME TEXT PRIMARY KEY,"
          "MOBILE TEXT,"
          "MESSAGE TEXT);");

      db.execute("CREATE TABLE IF NOT EXISTS CONTACTS ("
          "USER TEXT,"
          "CONTACTNAME TEXT,"
          "CONTACT TEXT PRIMARY KEY);");

      db.execute("CREATE TABLE IF NOT EXISTS HISTORY ("
          "ID TEXT PRIMARY KEY,"
          "USER TEXT,"
          "CONTACTNAME TEXT,"
          "MOBILE TEXT,"
          "MESSAGE TEXT,"
          "SENT TEXT);");
    });
  }

  // Insert User data to Database
  static Future<bool> insertUser(UserModel user) async {
    bool result = false;

    try {
      final db = await setDatabase();
      await db.insert("USER", user.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      result = true;
      return result;
    } catch (e) {
      print("Error ${e.toString()}");
      return result;
    }
  }

  // Update User data to Database
  static Future<bool> updateUser(UserModel userModel) async {
    bool result = false;
    try {
      final db = await setDatabase();
      await db.update("USER", userModel.toJson());
      result = true;
      return result;
    } catch (e) {
      return result;
    }
  }

  // Get User data from Database
  static Future<List<UserModel>> getUser() async {
    final db = await setDatabase();
    List<Map<String, Object?>> user =
        await db.rawQuery("SELECT * FROM USER ");
    return user.map((data) => UserModel.fromJson(data)).toList();
  }

  // Delete User From Database
  static Future<void> deleteUser(String FullName) async {
    final db = await setDatabase();
    await db.delete("USER", where: "NAME", whereArgs: [FullName]);
  }

  // Insert Contact data to Database
  static Future<bool> insertContact(ContactsModel contacts) async {
    bool result = false;

    try {
      final db = await setDatabase();
      await db.insert("CONTACTS", contacts.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
      result = true;
      return result;
    } catch (e) {
      print("Error ${e.toString()}");
      return result;
    }
  }

  // Delete data to Database
  static Future<bool> deleteContact(String mobile, String name) async {
    bool result = false;
    try {
      final db = await setDatabase();
      await db.rawDelete(
          "DELETE FROM CONTACTS WHERE CONTACT = ? AND CONTACTNAME = ?;",
          [mobile, name]);
      result = true;
      return true;
    } catch (e) {
      print("Error ${e.toString()}");
      return result;
    }
  }

  // Get Contact Data from Database
  static Future<List<ContactsModel>> getContact() async {
    final db = await setDatabase();
    List<Map<String, Object?>> contact = await db.query("CONTACTS");
    return contact.map((data) => ContactsModel.fromJson(data)).toList();
  }
}
