import 'dart:async';
import 'dart:io';

import 'package:dnd_spells/model/spell.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    initDB() async {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "spells.db");
      return await openDatabase(
        path,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              'CREATE TABLE Spell ( id INTEGER PRIMARY KEY, nivel TEXT, nome TEXT, duracao TEXT, concentracao BIT, escola TEXT, ritual BIT, classes TEXT, tempoConjuracao TEXT, alcance TEXT, componentes TEXT, desc TEXT, nivelSuperior TEXT, favorito BIT )');
        },
      );
    }

    // if _database is null we instantiate it
    _database = await initDB();

    return _database;
  }

  // CREATE
  newSpell(Spell newSpell) async {
    final db = await database;

    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Spell");

    newSpell.id = table.first["id"];

    //insert to the table using the new id
    var res = await db.insert("Spell", newSpell.toJson());
    return res;
  }

  // CREATE MANY
  newSpellList(List<Spell> newSpellList) async {
    final db = await database;

    for (Spell spell in newSpellList) {
      //get the biggest id in the table
      var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Spell");

      spell.id = table.first["id"];

      //insert to the table using the new id
      await db.insert("Spell", spell.toJson());
    }
  }

  // READ
  selectAll() async {
    final db = await database;
    // var a = db.query('Spell');
    List<Map> res = await db.rawQuery('SELECT * FROM Spell');

    return res.isNotEmpty ? dbSpellsToJson(res) : Null;
  }

  getSpellById(int id) async {
    final db = await database;
    var res = await db.query("Spell", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Spell.fromJson(res.first) : Null;
  }

  getSpellByFavoritoAndClasse(int favorito, String classe) async {
    final db = await database;
    var res = await db.query("Spell",
        where: "favorito = ? AND classes LIKE ?",
        whereArgs: [favorito, '%$classe%']);
    return res.isNotEmpty ? dbSpellsToJson(res) : Null;
  }

  getSpellByClasse(String classe) async {
    final db = await database;
    var res = await db
        .query("Spell", where: "classes LIKE ?", whereArgs: ['%$classe%']);
    return res.isNotEmpty ? dbSpellsToJson(res) : Null;
  }

  // UPDATE
  updateSpell(Spell newSpell) async {
    final db = await database;
    var res = await db.update("Spell", newSpell.toJson(),
        where: "id = ?", whereArgs: [newSpell.id]);
    return res;
  }

  updateFavoritarSpell(Spell spell) async {
    final db = await database;
    int updateFavorito = spell.favorito == 0 ? 1 : 0;
    spell.favorito = updateFavorito;

    await db.update("Spell", spell.toJson(),
        where: "id = ?", whereArgs: [spell.id]);

    return updateFavorito;
  }

  // DELETE
  deleteSpell(int id) async {
    final db = await database;
    db.delete("Spell", where: "id = ?", whereArgs: [id]);
  }

  deleteAllFromClasse(String classe) async {
    final db = await database;
    db.rawDelete("DELETE * FROM Spell WHERE classes IN $classe");
  }
}
