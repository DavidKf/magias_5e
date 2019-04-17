import 'package:dnd_spells/layout/spell_card.dart';
import 'package:dnd_spells/model/class.dart';
import 'package:dnd_spells/model/spell.dart';

import 'package:flutter/material.dart';

class SpellList extends StatelessWidget {
  final Class classeData;
  final List<Spell> spellsData;

  const SpellList({this.classeData, @required this.spellsData});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Magias 5e',
      theme: ThemeData(
          brightness: Brightness.dark, accentColor: classeData.accentColor),
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

  final Class classe;

  final List<Spell> spells;

  @override
  _SpellListLayoutState createState() => _SpellListLayoutState();
}

class _SpellListLayoutState extends State<SpellListLayout> {
  TextEditingController controller = new TextEditingController();

  List<Spell> searchSpellList = new List();

  Widget appBarTitle = new Text('');

  Icon actionIcon = new Icon(Icons.search);

  var contentrationIcon = Image.asset(
    'assets/dndicon/concentration.png',
    semanticLabel: 'Concentration',
    height: 20.0,
    width: 20.0,
    color: Colors.white,
  );

  var ritualIcon = Image.asset(
    'assets/dndicon/ritual.png',
    semanticLabel: 'Ritual',
    height: 20.0,
    width: 20.0,
    color: Colors.white,
  );

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

  // App bar parent
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

  // search element for the search bar
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

  // create a filtered spellList
  onSearchTextChanged(String text) async {
    searchSpellList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.spells.forEach(
      (spell) {
        if (spell.nome.toLowerCase().contains(text) ||
            spell.nivel.toLowerCase().contains(text))
          searchSpellList.add(spell);
      },
    );

    setState(() {});
  }

  //   SliverPersistentHeader makeHeader(String headerText) {
  //   return SliverPersistentHeader(
  //     pinned: true,
  //     delegate: _SliverAppBarDelegate(
  //       minHeight: 60.0,
  //       maxHeight: 200.0,
  //       child: Container(
  //           color: Colors.lightBlue, child: Center(child:
  //               Text(headerText))),
  //     ),
  //   );
  // }

  // builds the spell lists
  SliverList spellList() {
    return SliverList(
      delegate: searchSpellList.length != 0 || controller.text.isNotEmpty
          ? SliverChildBuilderDelegate(
              // If user is searching, use the filtered list
              (context, index) => new SpellCard(
                    spells: searchSpellList,
                    index: index,
                    contentrationIcon: contentrationIcon,
                    ritualIcon: ritualIcon,
                  ),
              childCount: searchSpellList.length,
            )
          : SliverChildBuilderDelegate(
              // else, use the original list
              (context, index) => new SpellCard(
                    spells: widget.spells,
                    index: index,
                    contentrationIcon: contentrationIcon,
                    ritualIcon: ritualIcon,
                    classeData: widget.classe,
                  ),
              childCount: widget.spells.length,
            ),
    );
  }
}
