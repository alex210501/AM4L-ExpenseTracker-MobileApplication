import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/space.dart';


/// Store the global data of the application
class SpacesListModel extends ChangeNotifier {
  List<Space> _spaces = [];

  /// Getter for the spaces
  List<Space> get spaces {
    return UnmodifiableListView(_spaces);
  }

  /// Set new spaces
  void setSpaces(List<Space> newSpaces, { bool notify = true }) {
    _spaces = List.from(newSpaces);

    if (notify) {
      notifyListeners();
    }
  }

  /// Clear spaces
  void clearSpaces() {
    _spaces.clear();
  }

  /// Get space by its ID
  Space? getSpaceByID(String spaceId) {
    return _spaces.firstWhere((space) => space.id == spaceId);
  }

  /// Add a new space to the list
  void addSpace(Space newSpace, { bool notify = true }) {
    _spaces.add(newSpace);

    if (notify) {
      notifyListeners();
    }
  }

  /// Remove a space given its space ID
  void removeSpaceBySpaceID(String spaceId, { bool notify = true }) {
    _spaces.removeWhere((space) => space.id == spaceId);

    if (notify) {
      notifyListeners();
    }
  }
}