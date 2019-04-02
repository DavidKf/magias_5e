import 'package:flutter/material.dart';

class Class {
  final String name;
  final String icon;
  final String image;
  final Color color;
  final double alignmentX;
  final double alignmentY;

  Class(
    this.name,
    this.icon,
    this.image,
    this.color, 
    this.alignmentX,
    this.alignmentY,
  );
}

final classList = <Class>[
 new Class('Bardo', 'assets/dndicon/bardIcon.png', 'assets/dndicon/bardCard.jpg', Color(0x66df5322), -0.8, 1.0),
 new Class('Clérigo', 'assets/dndicon/clericIcon.png', 'assets/dndicon/clericCard.jpg', Color(0x88B9B19C), 0.0, 1.0),
 new Class('Druida', 'assets/dndicon/druidIcon.png', 'assets/dndicon/druidCard.jpg', Color(0xaa418321), -0.4, 1.0),
 new Class('Paladino', 'assets/dndicon/paladinIcon.png', 'assets/dndicon/paladinCard.jpg', Color(0x88947441), -0.5, 1.0),
 new Class('Patrulheiro', 'assets/dndicon/rangerIcon.png', 'assets/dndicon/rangerCard.jpg', Color(0x88708d9b), 0.3, 1.0),
 new Class('Feiticeiro', 'assets/dndicon/sorcererIcon.png', 'assets/dndicon/sorcererCard.jpg', Color(0x8814756e), 0.3, 1.0),
 new Class('Bruxo', 'assets/dndicon/warlockIcon.png', 'assets/dndicon/warlockCard.jpg', Color(0x881b4714), 0.7, 1.0),
 new Class('Mago', 'assets/dndicon/wizardIcon.png', 'assets/dndicon/wizardCard.jpg', Color(0x9956398b), 0.5, 1.0),
];

getClassIcon(String icon) {
  return ImageIcon(
    AssetImage(icon),
    color: Colors.white,
    size: 40.0,
  );
}
