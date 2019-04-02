import 'dart:async';
import 'dart:convert';

import 'package:dnd_spells/model/class.dart';
import 'package:dnd_spells/model/spell.dart';

import 'package:dnd_spells/layout/spell_list.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  bool _buildingSpellList = false;

  List<Spell> spellList = new List<Spell>();

  //get the spell assets
  Future<String> loadAssets() async {
    return await rootBundle.loadString('assets/magias.json');
  }

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

    var spells =
        this.spellList.where((s) => s.classes.contains(classe.name)).toList();

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
              onPressed: () {
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

  // async call to build the json file into a real list of spells
  Future<List<Spell>> _getSpells() async {
    var data =
        await DefaultAssetBundle.of(context).loadString('assets/magias.json');

    var jsonData = json.decode(data);

    List<Spell> spells = [];

    for (var i in jsonData) {
      Spell spell = Spell(
          i["nivel"],
          i["nome"],
          i["duracao"],
          i["concentracao"],
          i["escola"],
          i["ritual"],
          i["classes"],
          i["tempoConjuracao"],
          i["alcance"],
          i["componentes"],
          i["desc"],
          i["nivelSuperior"]);

      spells.add(spell);
    }

    spellList = spells;

    setState(() {
      _buildingSpellList = false;
    });

    return spells;
  }
}
