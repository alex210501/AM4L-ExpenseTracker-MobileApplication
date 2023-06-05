import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/tools/provider_tools.dart';

/// Create a card to display the collaborator information
class CollaboratorCard extends StatelessWidget {
  final Space space;
  final String collaborator;
  final void Function(BuildContext, String, String) onDelete;

  /// Default constructor
  const CollaboratorCard({
    super.key,
    required this.space,
    required this.collaborator,
    required this.onDelete,
  });

  /// Override build
  @override
  Widget build(BuildContext context) {
    /// Get username from credentials
    bool isAdmin = getCredentialsModel(context).username == space.admin;

    return Card(
      child: ListTile(
        title: Text(collaborator),
        trailing: isAdmin
            ? IconButton(
                onPressed: () => onDelete(context, space.id, collaborator),
                icon: const Icon(Icons.delete),
              )
            : null,
      ),
    );
  }
}
