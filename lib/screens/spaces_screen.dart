import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/models/spaces_list_model.dart';
import 'package:am4l_expensetracker_mobileapplication/widgets/expandable_vertical_fab.dart';

class SpacesScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const SpacesScreen({super.key, required this.expensesTrackerApi});

  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
  bool _isFabOpen = false;

  Future<List<Space>> _getSpaces() async {
    return await widget.expensesTrackerApi.spaceApi.getSpaces();
  }

  void _joinSpace(BuildContext context, String spaceId) {
    widget.expensesTrackerApi.userSpaceApi.joinSpace(spaceId).then((_) {
      // Get information from the space joined
      widget.expensesTrackerApi.spaceApi.getSpace(spaceId).then((newSpace) {
        Provider.of<SpacesListModel>(context, listen: false).addSpace(newSpace);
        Navigator.pop(context);
      });
    });
  }

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
                onPressed: () => _joinSpace(context, spaceId),
                child: const Text('Join'),
              ),
            ],
          );
        });
  }

  _deleteSpace(BuildContext context, Space space) {
    widget.expensesTrackerApi.spaceApi.deleteSpace(space.id).then((_) {
      // Get and update the SpacesListModel
      Provider.of<SpacesListModel>(context, listen: false).removeSpaceBySpaceID(space.id);
    });
  }

  _goToSpaceInfo(BuildContext context) {
    Navigator.pushNamed(context, '/space/info', arguments: null);
  }

  _onFabOpen(BuildContext context) {
    setState(() => _isFabOpen = true);
  }

  _onFabClose(BuildContext context) {
    setState(() => _isFabOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<SpacesListModel>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Spaces'),
        ),
        floatingActionButton: ExpandableVerticalFAB(
          distance: 50.0,
          offsetY: 0.0,
          onOpen: _onFabOpen,
          onClose: _onFabClose,
          children: [
            TextButton(onPressed: () => _goToSpaceInfo(context), child: const Text('Create')),
            TextButton(onPressed: () => _openDialog(context), child: const Text('Join')),
          ],
        ),
        body: Consumer<SpacesListModel>(builder: (context, cart, child) {
          return IgnorePointer(
              ignoring: _isFabOpen,
              child: _SpaceListView(
                expensesTrackerApi: widget.expensesTrackerApi,
                onDelete: (arg) => _deleteSpace(context, arg),
              ));
        }),
    );
  }
}

@immutable
class _SpaceListView extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;
  final void Function(Space) onDelete;

  const _SpaceListView({
    super.key,
    required this.expensesTrackerApi,
    required this.onDelete,
  });

  @override
  State<_SpaceListView> createState() => _SpaceListViewState();
}

class _SpaceListViewState extends State<_SpaceListView> {
  _goToSpaceInfo(BuildContext context, Space space) {
    Navigator.pushNamed(context, '/space/info', arguments: space);
  }

  _goToExpensesScreen(BuildContext context, Space space) {
    Navigator.pushNamed(context, '/space/expenses', arguments: space);
  }

  /// Function to refresh the spaces
  Future<void> _onRefresh(BuildContext context) async {
    // Get SpacesListModel from context
    final spacesListModel = Provider.of<SpacesListModel>(context, listen: false);

    // Add spaces to SpacesListModel
    spacesListModel.setSpaces(await widget.expensesTrackerApi.spaceApi.getSpaces());
  }

  @override
  Widget build(BuildContext context) {
    final spaces = Provider.of<SpacesListModel>(context, listen: false).spaces;

    return Center(
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: ListView.builder(
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
            })));
  }
}
