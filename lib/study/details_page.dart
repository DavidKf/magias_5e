import 'package:dnd_spells/study/spell.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final Spell spell;

  DetailPage(this.spell);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(        
        appBar: AppBar(
          title: Text(spell.nome),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: new Text(
                'SAVE',
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
