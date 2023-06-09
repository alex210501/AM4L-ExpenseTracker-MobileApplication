import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/category.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/services/fab_controller.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/api_loading_indicator.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/error_dialog.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/expandable_vertical_fab.dart';

/// Show the spaces of a user
class SpacesScreen extends StatefulWidget {
  /// Constructor
  const SpacesScreen({super.key});

  /// Override createState
  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

/// State for [SpacesScreen]
class _SpacesScreenState extends State<SpacesScreen> {
  late ExpensesTrackerApi _expensesTrackerApi;
  final FabController _fabController = FabController();

  /// Callback used when you join a [Space]
  void _joinSpace(BuildContext context, String spaceId, {bool popContext = false}) {
    _expensesTrackerApi.userSpaceApi.joinSpace(spaceId).then((_) {
      // Get information from the space joined
      _expensesTrackerApi.spaceApi.getSpace(spaceId).then((newSpace) {
        getSpacesListModel(context).addSpace(newSpace);

        // Close the dialog if variable popContext set
        if (popContext) {
          Navigator.pop(context);
        }
      });
    }).catchError((err) => showErrorDialog(context, err));
  }

  /// Join a space using a [Dialog]
  _onJoinSpaceDialog(BuildContext context, String spaceId) {
    _joinSpace(context, spaceId, popContext: true);

    // Close the FAB
    if (_fabController.close != null) {
      _fabController.close!();
    }
  }

  /// Open a [Dialog] to join a [Space]
  void _openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String spaceId = '';

        return AlertDialog(
          title: const Text('Join space'),
          content: TextField(
            onChanged: (value) => spaceId = value,
            decoration: const InputDecoration(hintText: 'Enter a space ID'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => _onJoinSpaceDialog(context, spaceId),
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }

  /// Callback used to delete a [Space]
  _deleteSpace(BuildContext context, Space space) {
    _expensesTrackerApi.spaceApi.deleteSpace(space.id).then((_) {
      // Get and update the SpacesListModel
      getSpacesListModel(context).removeSpaceBySpaceID(space.id);
    }).catchError((err) => showErrorDialog(context, err));
  }

  /// Callback used to show the information of a [Space]
  _goToSpaceInfo(BuildContext context) {
    Navigator.pushNamed(context, '/space/info', arguments: null);

    // Delete the categories and expenses memorized
    getExpensesListModel(context).clearExpenses();
    getCategoriesListModel(context).clearCategories();

    // Close the FAB
    if (_fabController.close != null) {
      _fabController.close!();
    }
  }

  /// Callback used to scan a QR Code
  _goToQrScanner(BuildContext context) {
    Navigator.pushNamed(context, '/space/qrcode').then((spaceId) {
      if (spaceId != null) {
        _joinSpace(context, spaceId as String);
      }
    });

    // Close the FAB
    if (_fabController.close != null) {
      _fabController.close!();
    }
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    // Get ExpensesTrackerApi from context
    _expensesTrackerApi = getExpensesTrackerApiModel(context).expensesTrackerApi;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaces'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: const Icon(Icons.settings))
        ],
      ),
      floatingActionButton: ExpandableVerticalFAB(
        fabController: _fabController,
        distance: 50.0,
        offsetY: 10.0,
        onOpen: (context) => setState(() {}),
        onClose: (context) => setState(() {}),
        children: [
          TextButton(onPressed: () => _goToSpaceInfo(context), child: const Text('Create')),
          TextButton(onPressed: () => _openDialog(context), child: const Text('Join')),
          TextButton(onPressed: () => _goToQrScanner(context), child: const Text('Scan QR')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Consumer<SpacesListModel>(builder: (context, cart, child) {
          return IgnorePointer(
            ignoring: _fabController.getState != null ? _fabController.getState!() : false,
            child: _SpaceListView(onDelete: (arg) => _deleteSpace(context, arg)),
          );
        }),
      ),
    );
  }
}

/// Show the space in the form of a [ListView]
class _SpaceListView extends StatefulWidget {
  final void Function(Space) onDelete;

  /// Constructor
  const _SpaceListView({required this.onDelete});

  /// Override createState
  @override
  State<_SpaceListView> createState() => _SpaceListViewState();
}

/// State for [_SpaceListView]
class _SpaceListViewState extends State<_SpaceListView> {
  late ExpensesTrackerApi _expensesTrackerApi;
  bool _isLoading = false;

  /// Set [_isLoading]
  void _setLoading(bool loadingMode) => setState(() => _isLoading = loadingMode);

  /// Load categories from API
  Future<List<Category>> _loadCategories(BuildContext context, Space space) {
    // Make request to get the categories
    return _expensesTrackerApi.categoryApi.getCategories(space.id);
  }

  /// Callback used to show the informations of a [Space]
  void _goToSpaceInfo(BuildContext context, Space space) {
    // Load the categories from the API
    _loadCategories(context, space).then((categories) {
      getCategoriesListModel(context).setCategories(categories);

      // Go to SpaceInformationScreen
      Navigator.pushNamed(context, '/space/info', arguments: space);
    });
  }

  /// Callback used to show the expenses of a [Space]
  void _goToExpensesScreen(BuildContext context, Space space) {
    _setLoading(true);
    // Get expenses from the space
    _expensesTrackerApi.expenseApi.getExpenses(space.id).then((expenses) {
      _setLoading(false);

      // Set the expenses
      getExpensesListModel(context).setExpenses(expenses);

      // Load the categories from the API
      _loadCategories(context, space).then((categories) {
        getCategoriesListModel(context).setCategories(categories);

        // Go to ExpensesScreen
        Navigator.pushNamed(context, '/space/expenses', arguments: space);
      });
    });
  }

  /// Function to refresh the spaces
  Future<void> _onRefresh(BuildContext context) async {
    // Get SpacesListModel from context
    final spacesListModel = getSpacesListModel(context);

    // Add spaces to SpacesListModel
    spacesListModel.setSpaces(await _expensesTrackerApi.spaceApi.getSpaces());
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    final spaces = getSpacesListModel(context).spaces;

    // Get ExpensesTrackerApi from context
    _expensesTrackerApi = getExpensesTrackerApiModel(context).expensesTrackerApi;

    return Center(
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: Stack(children: [
          ListView.builder(
              itemCount: spaces.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey<Space>(spaces[index]),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => widget.onDelete(spaces[index]),
                  child: Card(
                    child: ListTile(
                      onTap: () => _goToExpensesScreen(context, spaces[index]),
                      title: Text(spaces[index].name),
                      subtitle: Text(spaces[index].description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _goToSpaceInfo(context, spaces[index]),
                            icon: const Icon(Icons.edit),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          if (_isLoading) const ApiLoadingIndicator(),
        ]),
      ),
    );
  }
}
