import 'package:flutter/material.dart';

enum ThemeColor {
  blue(color: Color.fromARGB(255, 34, 118, 229)),
  green(color: Color.fromARGB(255, 229, 158, 221)),
  pink(color: Color.fromARGB(255, 156, 202, 8));

  const ThemeColor({required this.color});

  final Color color;
  Color get backgroundColor => color.withAlpha(100);
}

/// Provider class for managing theme color changes
class ThemeColorProvider extends ChangeNotifier {
  ThemeColor _currentThemeColor = ThemeColor.blue;

  ThemeColor get currentThemeColor => _currentThemeColor;
  Color get color => _currentThemeColor.color;
  Color get backgroundColor => _currentThemeColor.backgroundColor;

  void setThemeColor(ThemeColor themeColor) {
    _currentThemeColor = themeColor;
    notifyListeners();
  }
}

ThemeColor currentThemeColor = ThemeColor.blue;
