import 'package:dnd_spells/model/class.dart';
import 'package:dnd_spells/model/db.dart';
import 'package:dnd_spells/model/spell.dart';
import 'package:flutter/material.dart';

class SpellCard extends StatefulWidget {
  const SpellCard({
    Key key,
    @required this.spells,
    @required this.index,
    @required this.contentrationIcon,
    @required this.ritualIcon,
    this.classeData,
  }) : super(key: key);

  final List<Spell> spells;
  final index;
  final contentrationIcon;
  final ritualIcon;
  final Class classeData;

  @override
  _SpellCardState createState() => _SpellCardState();
}

class _SpellCardState extends State<SpellCard> {
  bool checkFavorito(int fav) {
    return fav == 1;
  }

  fav(Spell spell) async {
    return await DBProvider.db.updateFavoritarSpell(spell);
  }

  InkWell spellTile(int index, List<Spell> lista, BuildContext context) {
    Spell spell = lista[index];

    bool notNull(Object o) => o != null;
    bool isConcentracao = spell.concentracao == 1;
    bool isRitual = spell.ritual == 1;

    const marginTop = const EdgeInsets.only(top: 12.0);
    const iconMargin = EdgeInsetsDirectional.only(start: 5.0);

    var favoritoIcon = Icon(
      checkFavorito(spell.favorito) ? Icons.favorite : Icons.favorite_border,
      color: widget.classeData.accentColor,
      size: 16.0,
    );
    return InkWell(
      // onLongPress: () async {
      //   var a = await fav(spell);

      //   setState(() {
      //     spell.favorito = a;
      //   });

      //   // final snackBar = SnackBar(
      //   //   duration: Duration(milliseconds: 500),
      //   //   content: Text(checkFavorito(spell.favorito).toString()),
      //   // );
      //   // Scaffold.of(context).showSnackBar(snackBar);
      // },
      child: Card(
        shape: checkFavorito(spell.favorito)
            ? new RoundedRectangleBorder(
                side: new BorderSide(
                    color: widget.classeData.accentColor.withOpacity(0.5),
                    width: 1.0),
                borderRadius: BorderRadius.circular(4.0))
            : new RoundedRectangleBorder(
                side: new BorderSide(color: Colors.transparent, width: 1.0),
                borderRadius: BorderRadius.circular(4.0)),
        child: ExpansionTile(
          trailing: Container(
            child: FlatButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${spell.nivel}',
                  ),
                  Container(
                    child: favoritoIcon,
                    margin: iconMargin,
                    transform: Matrix4.translationValues(5.0, 0.0, 0.0),
                    width: 5,
                  )
                ],
              ),
              padding: EdgeInsets.all(0),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {},
            ),
          ),
          title: Container(
            child: Row(
              children: <Widget>[
                Text(
                  spell.nome,
                  style: TextStyle(
                    fontSize: spell.nome.length < 20 ? 16.0 : 14.0,
                    letterSpacing: 0.5,
                  ),
                ),
                (isConcentracao) // Adds the concentration icon
                    ? Container(
                        child: widget.contentrationIcon,
                        margin: iconMargin,
                      )
                    : null,
                (isRitual) // Adds the ritual icon
                    ? Container(
                        child: widget.ritualIcon,
                        margin: iconMargin,
                      )
                    : null,
              ].where(notNull).toList(),
            ),
          ),
          children: <Widget>[
            // Spell data to show, when the tile is expanded
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  expandedTileItem(const EdgeInsets.all(0.0),
                      'Tempo de Conjuração: ', spell.tempoConjuracao),
                  expandedTileItem(marginTop, 'Alcance/Área: ', spell.alcance),
                  expandedTileItem(
                      marginTop, 'Componentes: ', spell.componentes),
                  expandedTileItem(marginTop, 'Duração: ', spell.duracao),
                  expandedTileItem(marginTop, '', spell.desc),
                  (spell.nivelSuperior != null)
                      ? expandedTileItem(marginTop, '', spell.nivelSuperior)
                      : null,
                ].where(notNull).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container expandedTileItem(EdgeInsets margin, String label, String text) {
    return Container(
      margin: margin,
      alignment: Alignment.centerLeft,
      child: new RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$label',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            ),
            TextSpan(
              text: '$text',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return spellTile(widget.index, widget.spells, context);
  }
}
