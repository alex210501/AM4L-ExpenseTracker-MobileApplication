import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/category.dart';
import 'package:am4l_expensetracker_mobileapplication/models/provider_models/categories_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/collaborator_card.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/error_dialog.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/qrcode.dart';

/// Screen that show the information of a [Space]
class SpaceInformationScreen extends StatefulWidget {
  /// Default constructor
  const SpaceInformationScreen({super.key});

  /// Override createState
  @override
  State<SpaceInformationScreen> createState() => _SpaceInformationScreenState();
}

/// State for SpaceInformationScreen
class _SpaceInformationScreenState extends State<SpaceInformationScreen> {
  bool _isNewSpace = false;
  bool _showQrCode = false;
  late ExpensesTrackerApi _expensesTrackerApi;
  late Space _space;
  late TextEditingController _descriptionController;
  late TextEditingController _nameController;

  /// Load space from the route argument
  void _loadSpaceFromRouteArgument(BuildContext context) {
    final spaceArg = ModalRoute.of(context)!.settings.arguments;

    // If the space is not passed to the function, go back to the last screen
    if (spaceArg == null) {
      _isNewSpace = true;
      _space = Space.defaultValue();
    } else {
      _isNewSpace = false;
      _space = spaceArg as Space;
    }

    // Initialise controllers
    _descriptionController = TextEditingController(text: _space.description);
    _nameController = TextEditingController(text: _space.name);
  }

  /// Callback used when you want to save the space information
  void _saveSpace(BuildContext context) {
    // Load data from input into space
    _space.name = _nameController.text;
    _space.description = _descriptionController.text;

    // Create or update the space
    if (_isNewSpace) {
      _expensesTrackerApi.spaceApi.createSpace(_space).then((newSpace) {
        // Go to previous page
        Navigator.pop(context);

        // Get and update SpacesListModel space
        getSpacesListModel(context).addSpace(newSpace);
      });
    } else {
      _expensesTrackerApi.spaceApi.updateSpace(_space).then((_) {
        // Update the space
        getSpacesListModel(context).updateSpace(_space);

        // Close the keyboard
        FocusScope.of(context).unfocus();

        // Show SnackBar
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Space information updated!')));
      });
    }
  }

  /// Callback to add a collaborator to a space
  void _addCollaboratorToSpace(BuildContext context, String spaceId, String collaborator) {
    _expensesTrackerApi.userSpaceApi.addUser(spaceId, collaborator).then((_) {
      _space.collaborators.add(collaborator);
      setState(() {});
    });
  }

  /// Callback to a collaborator from a space
  void _deleteCollaboratorFromSpace(BuildContext context, String spaceId, String collaborator) {
    _expensesTrackerApi.userSpaceApi.deleteUser(spaceId, collaborator).then((_) {
      _space.collaborators.remove(collaborator);
      setState(() {});
    });
  }

  /// Callback to copy the space ID to the clipboard
  void _copySpaceIdToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _space.id));

    // Show a SnackBar
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Space ID copied to the clipboard!')));
  }

  /// Callback to add a new category
  void _addCategoryToSpace(BuildContext context, String spaceId, String categoryTitle) {
    _expensesTrackerApi.categoryApi.createCategory(spaceId, categoryTitle).then((category) {
      getCategoriesListModel(context).addCategory(category);
    });
  }

  /// Callback to delete a category
  void _deleteCategoryFromSpace(BuildContext context, String spaceId, String categoryId) {
    _expensesTrackerApi.categoryApi.removeCategory(spaceId, categoryId).then((_) {
      getCategoriesListModel(context).removeCategoryById(categoryId);
    });
  }

  /// Callback to quit a space
  void _onQuitSpace(BuildContext context, String spaceId) {
    _expensesTrackerApi.userSpaceApi.quitSpace(spaceId).then((_) {
      getSpacesListModel(context).removeSpaceBySpaceID(spaceId);
      Navigator.pop(context);
    }).catchError((err) => showErrorDialog(context, err));
  }

  /// Get the text to display the ID line
  Widget _getIdText() {
    return Row(children: [
      const Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
      Text(': ${_space.id}', overflow: TextOverflow.ellipsis),
    ]);
  }

  /// Override build
  @override
  Widget build(BuildContext context) {
    _loadSpaceFromRouteArgument(context);

    // Get ExpensesTrackerApi from context
    _expensesTrackerApi = getExpensesTrackerApiModel(context).expensesTrackerApi;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Space"),
        actions: [
          if (!_isNewSpace)
            IconButton(
                onPressed: () => setState(() => _showQrCode = true),
                icon: const Icon(Icons.qr_code_rounded, color: Colors.white)),
          TextButton(
            onPressed: () => _saveSpace(context),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Stack(children: [
          Column(
            children: [
              !_isNewSpace
                  ? Row(
                      children: [
                        Expanded(
                          child: _getIdText(),
                        ),
                        IconButton(
                          onPressed: () => _copySpaceIdToClipboard(context),
                          icon: const Icon(Icons.content_copy),
                        ),
                      ],
                    )
                  : Container(),
              _SpaceInfoTextForm(
                title: 'Name',
                controller: _nameController,
              ),
              _SpaceInfoTextForm(
                title: 'Description',
                controller: _descriptionController,
              ),
              if (!_isNewSpace)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _ListViewCollaborator(
                    space: _space,
                    onDeleteCollaborator: _deleteCollaboratorFromSpace,
                    onAddCollaborator: _addCollaboratorToSpace,
                  ),
                ),
              Consumer<CategoriesListModel>(builder: (context, card, child) {
                return _ListViewCategories(
                  space: _space,
                  onAddCategory: _addCategoryToSpace,
                  onDeleteCategory: _deleteCategoryFromSpace,
                );
              }),
              if (!_isNewSpace)
                ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.red),
                    ), // Set the red border color
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey[50]), // Transparent background color
                    foregroundColor: MaterialStateProperty.all(Colors.red), // Text color
                  ),
                  onPressed: () => _onQuitSpace(context, _space.id),
                  child: const Text('QUIT SPACE'),
                )
            ],
          ),
          if (_showQrCode)
            QrCode(qrCodeMessage: _space.id, onPressed: (_) => setState(() => _showQrCode = false))
        ]),
      ),
    );
  }
}

/// Create a form text
@immutable
class _SpaceInfoTextForm extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  /// Constructor
  const _SpaceInfoTextForm({required this.title, required this.controller, this.validator});

  /// Override build
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Expanded(
          flex: 7,
          child: TextFormField(
            controller: controller,
            validator: validator,
          ),
        ),
      ],
    );
  }
}

/// Show a view of the collaborators of the space
@immutable
class _ListViewCollaborator extends StatelessWidget {
  final Space space;
  final void Function(BuildContext, String, String) onDeleteCollaborator;
  final void Function(BuildContext, String, String) onAddCollaborator;

  /// Default constructor
  const _ListViewCollaborator({
    required this.space,
    required this.onDeleteCollaborator,
    required this.onAddCollaborator,
  });

  /// Override build
  @override
  Widget build(BuildContext context) {
    final collaborators = space.collaborators;

    /// Check if it is the admin
    bool isAdmin = getCredentialsModel(context).username == space.admin;

    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Members',
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: collaborators.length + 1,
              itemBuilder: (context, index) {
                if (index != collaborators.length) {
                  return CollaboratorCard(
                    space: space,
                    collaborator: collaborators[index],
                    onDelete: onDeleteCollaborator,
                  );
                }

                // Can add new user if it is the admin of the space
                if (isAdmin) {
                  return _AddTile(space: space, onAdd: onAddCollaborator);
                }

                return null;
              }),
        )
      ],
    ));
  }
}

/// Tile to add a new Collaborator or Category to the Space
class _AddTile extends StatelessWidget {
  final Space space;
  final void Function(BuildContext, String, String) onAdd;
  final TextEditingController _userToAddController = TextEditingController();

  /// Default constructor
  _AddTile({
    required this.space,
    required this.onAdd,
  });

  /// Override build
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(controller: _userToAddController),
      trailing: IconButton(
        onPressed: () => onAdd(context, space.id, _userToAddController.text),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

/// Display the categories using a [ListView]
class _ListViewCategories extends StatelessWidget {
  final Space space;
  final void Function(BuildContext, String, String) onAddCategory;
  final void Function(BuildContext, String, String) onDeleteCategory;

  /// Constructor
  const _ListViewCategories({
    required this.space,
    required this.onAddCategory,
    required this.onDeleteCategory,
  });

  /// Override build
  @override
  Widget build(BuildContext context) {
    final categories = getCategoriesListModel(context).categories;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categories',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  return (index != categories.length)
                      ? CategoryCard(
                          space: space,
                          category: categories[index],
                          onDelete: onDeleteCategory,
                        )
                      : _AddTile(space: space, onAdd: onAddCategory);
                }),
          ),
        ],
      ),
    );
  }
}

/// Card to display a [Category]
class CategoryCard extends StatelessWidget {
  final Space space;
  final Category category;
  final void Function(BuildContext, String, String) onDelete;

  /// Constructor
  const CategoryCard({
    super.key,
    required this.space,
    required this.category,
    required this.onDelete,
  });

  /// Override build
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(category.title),
        trailing: IconButton(
          onPressed: () => onDelete(
            context,
            space.id,
            category.id,
          ),
          icon: const Icon(Icons.delete),
        ),
      ),
    );
  }
}
