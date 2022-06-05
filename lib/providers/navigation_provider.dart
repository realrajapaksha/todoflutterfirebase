import 'package:flutter/foundation.dart';

class NavigationData extends ChangeNotifier{

  int _selectedIndex = 0;

  void changeIndex(int data) {
    _selectedIndex = data;
    notifyListeners();
  }

  int get getIndex => _selectedIndex;
}