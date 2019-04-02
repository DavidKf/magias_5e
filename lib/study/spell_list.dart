import 'package:dnd_spells/model/data.dart';

import 'package:dnd_spells/study/spell.dart';

import 'package:flutter/material.dart';

class SpellList extends StatelessWidget {
  final SpellClass classeData;
  final List<Spell> spellsData;

  const SpellList({this.classeData, @required this.spellsData});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: SpellListLayout(
        classe: classeData,
        spells: spellsData,
      ),
    );
  }
}

class SpellListLayout extends StatefulWidget {
  const SpellListLayout({
    @required this.classe,
    this.spells,
  });

  final SpellClass classe;
  final List<Spell> spells;

  @override
  _SpellListLayoutState createState() => _SpellListLayoutState();
}

class _SpellListLayoutState extends State<SpellListLayout> {
  TextEditingController controller = new TextEditingController();

  List<Spell> searchSpellList = new List();

  Widget appBarTitle = new Text('');
  Icon actionIcon = new Icon(Icons.search);

  var contentration = Image.asset(
    'assets/dndicon/concentration.png',
    semanticLabel: 'Concentration',
    height: 20.0,
    width: 20.0,
    color: Colors.white,
  );

  var padding = EdgeInsets.only(left: 5);

  var ritual = Image.asset(
    'assets/dndicon/ritual.png',
    semanticLabel: 'Ritual',
    height: 20.0,
    width: 20.0,
    color: Colors.white,
  );

  var marginIcons = EdgeInsetsDirectional.only(start: 5.0);
  var height = 200.0;

  @override
  void initState() {
    super.initState();
    appBarTitle = new Text(widget.classe.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: CustomScrollView(
          slivers: <Widget>[
            appBar(context),
            spellList(),
          ],
        ),
      ),
    );
  }

  SliverList spellList() {
    return SliverList(
      delegate: searchSpellList.length != 0 || controller.text.isNotEmpty
          ? SliverChildBuilderDelegate(
              (context, index) => Card(
                    elevation: 2.0,
                    child: Container(
                      child: spellTile(index, searchSpellList),
                    ),
                  ),
              childCount: searchSpellList.length,
            )
          : SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  elevation: 2.0,
                  child: Container(
                    child: spellTile(index, widget.spells),
                  ),
                );
              },
              childCount: widget.spells.length,
            ),
    );
  }

  ExpansionTile spellTile(int index, List<Spell> lista) {
    var isConcentracao = lista[index].concentracao;
    var isRitual = lista[index].ritual;
    var spell = lista[index];

    const marginTop = const EdgeInsets.only(top: 12.0);
    bool notNull(Object o) => o != null;

    return ExpansionTile(
      trailing: Text(
        spell.nivel,
      ),
      title: Row(
        children: <Widget>[
          Text(
            spell.nome,
            style: TextStyle(
              fontSize: 16.0,
              letterSpacing: 0.5,
            ),
          ),
          (isConcentracao)
              ? Container(
                  child: contentration,
                  margin: marginIcons,
                )
              : Text(''),
          (isRitual)
              ? Container(
                  child: ritual,
                  margin: EdgeInsetsDirectional.only(start: 5.0),
                )
              : Text(''),
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              tileItem(const EdgeInsets.all(0.0), 'Tempo de Conjuração: ',
                  spell.tempoConjuracao),
              tileItem(marginTop, 'Alcance/Área: ', spell.alcance),
              tileItem(marginTop, 'Componentes: ', spell.componentes),
              tileItem(marginTop, 'Duração: ', spell.duracao),
              tileItem(marginTop, '', spell.desc),
              (spell.nivelSuperior != null)
                  ? tileItem(marginTop, '', spell.nivelSuperior)
                  : null,
            ].where(notNull).toList(),
          ),
        ),
      ],
    );
  }

  Container tileItem(EdgeInsets margin, String label, String text) {
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

  SliverAppBar appBar(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      title: appBarTitle,
      backgroundColor: widget.classe.color.withOpacity(0.8),
      expandedHeight: height,
      pinned: true,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          widget.classe.image,
          fit: BoxFit.cover,
        ),
      ),
      actions: <Widget>[
        searchbar(theme),
      ],
    );
  }

  IconButton searchbar(ThemeData theme) {
    return new IconButton(
      icon: actionIcon,
      splashColor: widget.classe.color,
      highlightColor: widget.classe.color,
      onPressed: () {
        setState(
          () {
            if (this.actionIcon.icon == Icons.search) {
              this.height = 50;
              this.actionIcon = new Icon(Icons.close);
              this.appBarTitle = new TextField(
                controller: controller,
                autofocus: true,
                onChanged: onSearchTextChanged,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search, color: Colors.white),
                  hintText: "Procurar...",
                  hintStyle: new TextStyle(color: Colors.white),
                  fillColor: widget.classe.color.withOpacity(0.8),
                  filled: true,
                  labelStyle: theme.textTheme.caption
                      .copyWith(color: theme.primaryColor),
                ),
              );
            } else {
              this.actionIcon = new Icon(Icons.search);
              this.appBarTitle = new Text(widget.classe.name);
              controller.clear();
              onSearchTextChanged('');
              height = 200.0;
            }
          },
        );
      },
    );
  }

  onSearchTextChanged(String text) async {
    searchSpellList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.spells.forEach((spell) {
      if (spell.nome.toLowerCase().contains(text) |
          spell.nivel.toLowerCase().contains(text)) searchSpellList.add(spell);
    });

    setState(() {});
    print('Qtd Magias: ${searchSpellList.length}');
  }
}
