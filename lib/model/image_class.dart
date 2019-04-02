import 'package:flutter/material.dart';

class ClassIcon extends StatelessWidget {
  final icon;
  
  const ClassIcon({
    Key key, @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      AssetImage(icon),
      color: Colors.white,
      size: 40.0,
    );
  }
}