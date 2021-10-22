import 'package:flutter/foundation.dart';

class TabManager extends ChangeNotifier {
  int selectedTab = 0;

  void goToTab(index) {
    selectedTab = index;
    notifyListeners();
  }

  void goToRecipes() {
    print('going to recipes');
    selectedTab = 1;
    notifyListeners();
  }
}