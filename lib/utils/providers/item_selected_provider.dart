import 'package:flutter/material.dart';

class ItemSelectedProvider with ChangeNotifier {
  bool _isSelected = false;
  bool _isSelectionMode = false;

  bool get isSelected => _isSelected;
  bool get isSelectionMode => _isSelectionMode;

  set isSelected(bool value) {
    _isSelected = value;
    notifyListeners();
  }

  set isSelectionMode(bool value) {
    _isSelectionMode = value;
    notifyListeners();
  }
}
