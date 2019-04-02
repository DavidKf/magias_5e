  import 'package:flutter/material.dart';

Color correctForegroundComplementaryColor(Color color) {
    HSVColor current = HSVColor.fromColor(color);
    num newH = current.hue + 180;
    if (newH > 360) newH -= 360;

    return HSVColor.fromAHSV(
            current.alpha, newH, current.saturation, current.value)
        .toColor();
  }