import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
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
  late Space space;

  /// Load space from the route argument
  _loadSpaceFromRouteArgument(BuildContext context) {
    final spaceArg = ModalRoute.of(context)!.settings.arguments;

    // If the space is not passed to the function, go back to the last screen
    if (spaceArg == null) {
      Navigator.pop(context);
    } else {
      space = spaceArg as Space;
    }
  }

  /// Add a collaborator to a space
  _addCollaboratorToSpace(BuildContext context, String spaceId, String collaborator) {
    widget.expensesTrackerApi.userSpaceApi.addUser(spaceId, collaborator)
        .then((_) {
          space.collaborators.add(collaborator);
          setState(() {});
        });
  }

  /// Delete a collaborator from a space
  _deleteCollaboratorFromSpace(BuildContext context, String spaceId, String collaborator) {
    widget.expensesTrackerApi.userSpaceApi.deleteUser(spaceId, collaborator)
        .then((_) {
          space.collaborators.remove(collaborator);
          setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadSpaceFromRouteArgument(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(space.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text('ID: ${space.id}'),
            Text('Description: ${space.description}'),
            _ListViewCollaborator(
              space: space,
              onDeleteCollaborator: _deleteCollaboratorFromSpace,
              onAddCollaborator: _addCollaboratorToSpace,
            )
          ],
        ),
      ),
    );
  }
}

@immutable
class _ListViewCollaborator extends StatelessWidget {
  final Space space;
  final void Function(BuildContext, String, String) onDeleteCollaborator;
  final void Function(BuildContext, String, String) onAddCollaborator;

  /// Default constructor
  _ListViewCollaborator({
    super.key,
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
                    : _AddCollaboratorTile(
                    space: space,
                    onAdd: onAddCollaborator,
                );
              }),
        )
      ],
    ));
  }
}

class _AddCollaboratorTile extends StatelessWidget {
  final Space space;
  final void Function(BuildContext, String, String) onAdd;
  final TextEditingController _userToAddController = TextEditingController();


  /// Default constructor
  _AddCollaboratorTile({
    super.key,
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