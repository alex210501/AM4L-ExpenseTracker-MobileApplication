import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/provider_models/categories_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/credentials_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/expenses_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/expenses_tracker_api_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/theme_selection.dart';

/// Get the CategoriesListModel
CategoriesListModel getCategoriesListModel(BuildContext context) {
  return Provider.of<CategoriesListModel>(context, listen: false);
}

/// Get CredentialsModels
CredentialsModel getCredentialsModel(BuildContext context) {
  return Provider.of<CredentialsModel>(context, listen: false);
}

/// Get ExpensesListModel
ExpensesListModel getExpensesListModel(BuildContext context) {
  return Provider.of<ExpensesListModel>(context, listen: false);
}

/// Get ExpensesTrackerApiModel
ExpensesTrackerApiModel getExpensesTrackerApiModel(BuildContext context) {
  return Provider.of<ExpensesTrackerApiModel>(context, listen: false);
}

/// Get SpacesListModel
SpacesListModel getSpacesListModel(BuildContext context) {
  return Provider.of<SpacesListModel>(context, listen: false);
}

/// Get ThemeSelection
ThemeSelection getThemeSelection(BuildContext context) {
  return Provider.of<ThemeSelection>(context, listen: false);
}
