import 'package:flutter/material.dart';
import 'package:sensor_mapping/Constants/color_palettes.dart';

// Light Theme
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    background: Palettes.backgroundColorLight,
    primary: Palettes.textColor2,
    secondary: Palettes.secondaryColor,
  ),
  iconTheme: const IconThemeData(
    color: Palettes.userIconLight,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Palettes.textColor6),
  ),
);

// Dark Theme
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background: Palettes.backgroundColorDark,
    primary: Palettes.textColor2,
    secondary: Palettes.secondaryColor,
  ),
  iconTheme: const IconThemeData(
    color: Palettes.userIconDark,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Palettes.textColor4),
  ),
);
