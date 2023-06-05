import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/category.dart';

/// Categories model used in Provider
class CategoriesListModel extends ChangeNotifier {
  List<Category> _categories = [];

  /// Getter for the categories
  List<Category> get categories => UnmodifiableListView(_categories);

  /// Set new categories
  void setCategories(List<Category> newCategories, {bool notify = true}) {
    _categories = List.from(newCategories);

    if (notify) {
      notifyListeners();
    }
  }

  /// Clear categories
  void clearCategories() {
    _categories.clear();
  }

  /// Add a [newCategory] to the list
  void addCategory(Category newCategory, {bool notify = true}) {
    _categories.add(newCategory);

    if (notify) {
      notifyListeners();
    }
  }

  /// Remove a category given its [categoryId]
  void removeCategoryById(String categoryId, {bool notify = true}) {
    _categories.removeWhere((category) => category.id == categoryId);

    if (notify) {
      notifyListeners();
    }
  }

  /// Get category by ID
  Category? getCategoryById(String categoryId, {bool notify = true}) {
    try {
      return _categories.firstWhere((category) => category.id == categoryId);
    } on StateError {
      return null;
    }
  }

  /// Update a category
  void updateCategory(Category newCategory, {bool notify = true}) {
    _categories.forEach((category) {
      if (category.id == newCategory.id) {
        category.title = newCategory.title;
      }
    });

    if (notify) {
      notifyListeners();
    }
  }
}
