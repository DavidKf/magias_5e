// To parse this JSON data, do
//
//     final spell = spellFromJson(jsonString);

import 'dart:convert';

List<Spell> spellsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Spell>.from(jsonData.map((x) => Spell.fromJson(x)));
}

String spellsToJson(data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.row.toJson()));
  return json.encode(dyn);
}

String dbSpellsToJson(data) {
  final dyn = new List<Spell>.from(data.map((x) => Spell.fromJson(x)));
  return json.encode(dyn);
}

Spell spellFromJson(String str) {
  final jsonData = json.decode(str);
  return Spell.fromJson(jsonData);
}

String spellToJson(Spell data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Spell {
  int id;
  int favorito;
  String nome;
  String nivel;
  String duracao;
  int concentracao;
  String escola;
  int ritual;
  String classes;
  String tempoConjuracao;
  String alcance;
  String componentes;
  String desc;
  String nivelSuperior;

  Spell({
    this.id,
    this.favorito,
    this.nome,
    this.nivel,
    this.duracao,
    this.concentracao,
    this.escola,
    this.ritual,
    this.classes,
    this.tempoConjuracao,
    this.alcance,
    this.componentes,
    this.desc,
    this.nivelSuperior,
  });

  factory Spell.fromJson(Map<String, dynamic> json) => new Spell(
        id: json["id"],
        favorito: json["favorito"],
        nome: json["nome"],
        nivel: json["nivel"],
        duracao: json["duracao"],
        concentracao: json["concentracao"],
        escola: json["escola"],
        ritual: json["ritual"],
        classes: json["classes"],
        tempoConjuracao: json["tempoConjuracao"],
        alcance: json["alcance"],
        componentes: json["componentes"],
        desc: json["desc"],
        nivelSuperior:
            json["nivelSuperior"] == null ? null : json["nivelSuperior"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "favorito": favorito,
        "nome": nome,
        "nivel": nivel,
        "duracao": duracao,
        "concentracao": concentracao,
        "escola": escola,
        "ritual": ritual,
        "classes": classes,
        "tempoConjuracao": tempoConjuracao,
        "alcance": alcance,
        "componentes": componentes,
        "desc": desc,
        "nivelSuperior": nivelSuperior == null ? null : nivelSuperior,
      };
}
