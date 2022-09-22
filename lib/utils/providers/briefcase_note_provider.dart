import 'package:flutter/material.dart';

class BriefcaseNoteProvider with ChangeNotifier {
  int _currentBriefcase = -1;

  int get currentBriefcase => _currentBriefcase;

  set currentBriefcase(int value) {
    _currentBriefcase = value;
    notifyListeners();
  }
}
