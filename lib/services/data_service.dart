import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/space.dart';


/// Store the global data of the application
class DataService extends ChangeNotifier {
  List<Space> _spaces = [];

  /// Getter for the spaces
  List<Space> get spaces {
    return List.from(_spaces);
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