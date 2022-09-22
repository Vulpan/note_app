import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  List<Color> firstColors = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color(0xFFFF1744),
    const Color(0xFFE91E63),
    const Color(0xFF9C27B0),
    const Color(0xFF3F51B5),
    const Color(0xFF2196F3),
    const Color(0xFF03A9F4),
    const Color(0xFF00BCD4),
    const Color(0xFF009688),
    const Color(0xFF4CAF50),
    const Color(0xFF8BC34A),
    const Color(0xFFCDDC39),
    const Color(0xFFFFEB3B),
    const Color(0xFFFFC107),
    const Color(0xFFFF9800),
    const Color(0xFF795548),
    const Color(0xFF607D8B),
    const Color(0xFFFF9800),
  ];

  List<Color> secondColors = [
    const Color.fromARGB(255, 0, 0, 0),
    const Color(0xFFFF5252),
    const Color(0xFFFF4081),
    const Color(0xFFE040FB),
    const Color(0xFF7C4DFF),
    const Color(0xFF7C4DFF),
    const Color(0xFF536DFE),
    const Color(0xFF448AFF),
    const Color(0xFF40C4FF),
    const Color(0xFF18FFFF),
    const Color(0xFF64FFDA),
    const Color(0xFF69F0AE),
    const Color(0xFFB2FF59),
    const Color(0xFFEEFF41),
    const Color(0xFFFFFF00),
    const Color(0xFFFFD740),
    const Color(0xFFFFAB40),
    const Color(0xFFFF6E40),
  ];

  List<Color> textColors = [
    const Color.fromARGB(255, 255, 255, 255),
    const Color(0xFF9E9E9E),
    const Color.fromARGB(255, 0, 0, 0),
  ];

  int generateId(List<dynamic> list) {
    int id = -1;
    if (list.isEmpty) {
      id = 0;
    } else {
      for (int i = 0; i < list.length; i++) {
        if (list[i].id == i) {
          id = i;
          continue;
        } else {
          id = i;
          return id;
        }
      }
    }
    return id + 1;
  }

  DateFormat dateFormat(int whichFormat) {
    DateFormat dateFormat;
    switch (whichFormat) {
      case 1:
        dateFormat = DateFormat.yMd();
        break;
      case 2:
        dateFormat = DateFormat.yMMMd();
        break;
      case 3:
        dateFormat = DateFormat.yMMMMd();
        break;
      default:
        dateFormat = DateFormat();
    }
    return dateFormat;
  }

  void closeKeyboard(BuildContext context) {
    FocusScopeNode cf = FocusScope.of(context);
    if (!cf.hasPrimaryFocus) {
      cf.unfocus();
    }
  }
}
