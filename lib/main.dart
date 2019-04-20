import 'dart:async';

import 'package:dnd_spells/layout/spell_list.dart';
import 'package:dnd_spells/model/class.dart';
import 'package:dnd_spells/model/db.dart';
import 'package:dnd_spells/model/spell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Magias 5e',
      home: SpellClassSlideShow(),
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.dark,
        primaryColor: Color(0xFFFFFFE5),
        accentColor: Color(0xFFFFECB3),
        appBarTheme: AppBarTheme(brightness: Brightness.light),
      ),
    );
  }
}

class SpellClassSlideShow extends StatefulWidget {
  createState() => SpellClassSlideShowState();
}

class SpellClassSlideShowState extends State<SpellClassSlideShow> {
  final PageController ctrl = PageController(viewportFraction: 0.8);

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;

  bool _buildingSpellList = true;

  String magiasJson = 'assets/magias.json';

  buildSpellList() {
    setState(() {
      _buildingSpellList = true;
    });
    _getSpells();
  }

  @override
  void initState() {
    super.initState();
    buildSpellList();
    // Set state when page changes
    ctrl.addListener(
      () {
        int next = ctrl.page.round();

        if (currentPage != next) {
          setState(
            () {
              currentPage = next;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, AsyncSnapshot snap) {
        List<Class> slideList = classList;
        return Scaffold(
          body: ModalProgressHUD(
            color: Colors.black,
            progressIndicator: new CircularProgressIndicator(
              backgroundColor: Colors.red,
            ),
            opacity: 1.0,
            inAsyncCall: _buildingSpellList,
            child: PageView.builder(
              controller: ctrl,
              itemCount: slideList.length,
              itemBuilder: (context, int currentIdx) {
                // Active page
                bool active = currentIdx == currentPage;
                return _buildStoryPage(slideList.elementAt(currentIdx), active);
              },
            ),
          ),
          // TODO: add class-specific functionality
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: classList[currentPage].accentColor,
          //   elevation: 4.0,
          //   onPressed: () {},
          //   child: const Icon(Icons.add),
          // ),
        );
      },
    );
  }

  // Builder Functions
  _buildStoryPage(Class classe, bool active) {
    // Animated Properties
    final double blur = active ? 30 : 5;
    final double offset = active ? 20 : 2;
    final double top = active ? 50 : 100;
    final double sides = active ? 0 : 30;

    // adds a colored gradient shade over the image
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            classe.color,
            const Color(0x00000000),
          ],
        ),
      ),
    );

    // create and animate the spell cards
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: top, right: sides, left: sides),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: new DecorationImage(
            image: new AssetImage(classe.image),
            fit: BoxFit.fitHeight,
            alignment: Alignment(classe.alignmentX, classe.alignmentY),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                blurRadius: blur,
                offset: Offset(offset, offset))
          ]),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageOverlayGradient,
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Text(
                classe.name,
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Center(
              child: getClassIcon(classe.icon),
            ),
          ),
          SizedBox.expand(
            child: FlatButton(
              onPressed: () async {
                List<Spell> spells = await getClassSpells(classe, false);

                if (active) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpellList(
                            classeData: classe,
                            spellsData: spells,
                          ),
                    ),
                  );
                }
              },
              child: new Text(''),
              splashColor: classe.color,
              highlightColor: classe.color,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Spell>> getClassSpells(Class classe, bool somenteFavorito) async {
    var list = somenteFavorito
        ? await DBProvider.db.getSpellByFavoritoAndClasse(1, classe.name)
        : await DBProvider.db.getSpellByClasse(classe.name);

    List<Spell> spells = new List<Spell>();

    if (list != Null) spells = spellsFromJson(list);

    // spells.sort((a, b) => b.favorito.compareTo(a.favorito));
    return spells;
  }

  // async call to build the json file into a real list of spells
  _getSpells() async {
    dynamic list = await DBProvider.db.selectAll();
    // print('List select all: ${list.toString()}');

    List<Spell> spells = new List<Spell>();

    if (list != Null) spells = spellsFromJson(list);

    // print('Spells select all: ${spells.toString()}');

    if (spells.length == 0) {
      var data = await rootBundle.loadString(magiasJson);

      spells = spellsFromJson(data);

      await DBProvider.db.newSpellList(spells);

      // print('List first time: ${spells.toString()}');
    }

    setState(() {
      _buildingSpellList = false;
    });
  }
}
