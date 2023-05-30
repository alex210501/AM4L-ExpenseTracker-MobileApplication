import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/category.dart';
import 'package:am4l_expensetracker_mobileapplication/models/categories_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/collaborator_card.dart';

class SpaceInformationScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  /// Default constructor
  const SpaceInformationScreen({super.key, required this.expensesTrackerApi});

  @override
  State<SpaceInformationScreen> createState() => _SpaceInformationScreenState();
}

class _SpaceInformationScreenState extends State<SpaceInformationScreen> {
  bool isNewSpace = false;
  late Space _space;
  late TextEditingController _descriptionController;
  late TextEditingController _nameController;

  /// Load space from the route argument
  void _loadSpaceFromRouteArgument(BuildContext context) {
    final spaceArg = ModalRoute.of(context)!.settings.arguments;

    // If the space is not passed to the function, go back to the last screen
    if (spaceArg == null) {
      isNewSpace = true;
      _space = Space.defaultValue();
    } else {
      isNewSpace = false;
      _space = spaceArg as Space;
    }

    // Initialise controllers
    _descriptionController = TextEditingController(text: _space.description);
    _nameController = TextEditingController(text: _space.name);
  }

  /// Save space
  void _saveSpace(BuildContext context) {
    // Load data from input into space
    _space.name = _nameController.text;
    _space.description = _descriptionController.text;

    // Create or update the space
    if (isNewSpace) {
      widget.expensesTrackerApi.spaceApi
          .createSpace(_space)
          .then((newSpace) {
            // Go to previous page
            Navigator.pop(context);

            // Get and update SpacesListModel space
            Provider.of<SpacesListModel>(context, listen: false).addSpace(newSpace);
          });
    } else {
      widget.expensesTrackerApi.spaceApi.updateSpace(_space);
    }
  }

  /// Add a collaborator to a space
  void _addCollaboratorToSpace(
      BuildContext context, String spaceId, String collaborator) {
    widget.expensesTrackerApi.userSpaceApi
        .addUser(spaceId, collaborator)
        .then((_) {
      _space.collaborators.add(collaborator);
      setState(() {});
    });
  }

  /// Delete a collaborator from a space
  void _deleteCollaboratorFromSpace(
      BuildContext context, String spaceId, String collaborator) {
    widget.expensesTrackerApi.userSpaceApi
        .deleteUser(spaceId, collaborator)
        .then((_) {
      _space.collaborators.remove(collaborator);
      setState(() {});
    });
  }

  /// Copy the space ID to the clipboard
  void _copySpaceIdToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _space.id));

    // Show a SnackBar(BuildContext context) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Space ID copied to the clipboard!')));
  }

  /// Add a new category
  void _addCategoryToSpace(BuildContext context, String spaceId, String categoryTitle) {
    widget.expensesTrackerApi.categoryApi.createCategory(spaceId, categoryTitle)
        .then((category) {
          Provider.of<CategoriesListModel>(context, listen: false).addCategory(category);
        });
  }

  /// Delete a category
  void _deleteCategoryFromSpace(BuildContext context, String spaceId, String categoryId) {
    widget.expensesTrackerApi.categoryApi.removeCategory(spaceId, categoryId)
        .then((_) {
          Provider.of<CategoriesListModel>(context, listen: false).removeCategoryById(categoryId);
        });
  }

  @override
  Widget build(BuildContext context) {
    _loadSpaceFromRouteArgument(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Space"),
        actions: [
          TextButton(
            onPressed: () => _saveSpace(context),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            !isNewSpace ?
            Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: Text('ID: ${_space.id}', overflow: TextOverflow.ellipsis,),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      onPressed: () => _copySpaceIdToClipboard(context),
                      icon: const Icon(Icons.content_copy),
                  ),),
                ],
            ) : Container(),
            _SpaceInfoTextForm(
              title: 'Name',
              controller: _nameController,
            ),
            _SpaceInfoTextForm(
              title: 'Description',
              controller: _descriptionController,
            ),
            _ListViewCollaborator(
              space: _space,
              onDeleteCollaborator: _deleteCollaboratorFromSpace,
              onAddCollaborator: _addCollaboratorToSpace,
            ),
            Consumer<CategoriesListModel>(builder: (context, card, child) {
              return _ListViewCategories(
                space: _space,
                onAddCategory: _addCategoryToSpace,
                onDeleteCategory: _deleteCategoryFromSpace,
              );
            })
          ],
        ),
      ),
    );
  }
}

@immutable
class _SpaceInfoTextForm extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const _SpaceInfoTextForm(
      {required this.title, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
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

  @override
  Widget build(BuildContext context) {
    final collaborators = space.collaborators;

    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Members'),
        Flexible(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: collaborators.length + 1,
              itemBuilder: (context, index) {
                return (index != collaborators.length)
                    ? CollaboratorCard(
                        space: space,
                        collaborator: collaborators[index],
                        onDelete: onDeleteCollaborator,
                      )
                    : _AddTile(
                        space: space,
                        onAdd: onAddCollaborator,
                      );
              }),
        )
      ],
    ));
  }
}

class _AddTile extends StatelessWidget {
  final Space space;
  final void Function(BuildContext, String, String) onAdd;
  final TextEditingController _userToAddController = TextEditingController();

  /// Default constructor
  _AddTile({
    required this.space,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: _userToAddController,
      ),
      trailing: IconButton(
        onPressed: () => onAdd(context, space.id, _userToAddController.text),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

@immutable
class _ListViewCategories extends StatelessWidget {
  final Space space;
  final void Function(BuildContext, String, String) onAddCategory;
  final void Function(BuildContext, String, String) onDeleteCategory;

  _ListViewCategories({
    super.key,
    required this.space,
    required this.onAddCategory,
    required this.onDeleteCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategoriesListModel>(context, listen: false).categories;
    
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Categories'),
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
                        : _AddTile(
                      space: space,
                      onAdd: onAddCategory,
                    );
                  }),
            )
          ],
        ));
  }
}

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
