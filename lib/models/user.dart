import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String memberTable = "member";
final String idCol = "_id";
final String useridCol = "userid";
final String nameCol = "name";
final String ageCol = "age";
final String passwordCol = "password";
final String quoteCol = "quote";

class User {
  int id;
  String userid;
  String password;
  String name;
  String age;
  String quote;

  User({this.userid, this.password, this.name, this.age});
  User.formMap(Map<String, dynamic> map) {
    this.id = map[idCol];
    this.userid = map[useridCol];
    this.name = map[nameCol];
    this.age = map[ageCol];
    this.password = map[passwordCol];
    this.quote = map[quoteCol];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      useridCol: userid,
      nameCol: name,
      ageCol: age,
      passwordCol: password,
      quoteCol: quote,
    };
    if (id != null) {
      map[idCol] = id;
    }

    return map;
  }
}

class UserProvider {
  Database db;
  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $memberTable (
        $idCol integer primary key autoincrement,
        $useridCol text not null unique,
        $nameCol text not null,
        $ageCol text not null,
        $passwordCol text not null,
        $quoteCol text
      )
      ''');
    });
  }

  Future<List<User>> getUsers() async {
    var res = await db.query(memberTable,
        columns: [idCol, useridCol, nameCol, ageCol, passwordCol, quoteCol]);
    return res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
  }

  Future<List<User>> getUser(int id) async {
    var res = await db.query(memberTable,
        columns: [idCol, useridCol, nameCol, ageCol, passwordCol, quoteCol],
        where: '$idCol = ?',
        whereArgs: [id]);
    return res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
  }

  Future<User> insert(User user) async {
    await db.insert(memberTable, user.toMap());
  }

  Future<int> updateUser(User user) async {
    return await db.update(memberTable, user.toMap(),
        where: '$idCol = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUsers() async {
    return await db.delete(memberTable);
  }

  Future<int> deleteUser(int id) async {
    return await db.delete(memberTable, where: '$idCol = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}