import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';
import 'package:am4l_expensetracker_mobileapplication/services/data_service.dart';

class SpacesScreen extends StatefulWidget {
  final ExpensesTrackerApi expensesTrackerApi;

  const SpacesScreen({super.key, required this.expensesTrackerApi});

  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
  Future<List<Space>> _getSpaces() async {
    return await widget.expensesTrackerApi.spaceApi.getSpaces();
  }

  _deleteSpace(BuildContext context, Space space) {
    widget.expensesTrackerApi.spaceApi
        .deleteSpace(space.id)
        .then((_) {
          // Get and update the DataService
          Provider.of<DataService>(context, listen: false).removeSpaceBySpaceID(space.id);
        });
  }

  _goToSpaceInfo(BuildContext context) {
    Navigator.pushNamed(context, '/space/info', arguments: null);
  }

  @override
  Widget build(BuildContext context) {
    final dataService = Provider.of<DataService>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Spaces'),
        ),
        floatingActionButton: IconButton(
          onPressed: () => _goToSpaceInfo(context),
          icon: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<Space>>(
            future: _getSpaces(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Space>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.done) {
                dataService.setSpaces(snapshot.data ?? [], notify: false);

                return Consumer<DataService>(
                    builder: (context, cart,child) {
                      return _SpaceListView(
                        onDelete: (arg) => _deleteSpace(context, arg),
                      );
                    });
              }

              return const Center(child: Text('Empty Data'));
            }));
  }
}

@immutable
class _SpaceListView extends StatefulWidget {
  final void Function(Space) onDelete;

  const _SpaceListView({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    final spaces = Provider.of<DataService>(context, listen: false).spaces;

    return Center(
        child: ListView.builder(
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey<Space>(spaces[index]),
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
                          IconButton(
                              onPressed: () => widget.onDelete(spaces[index]),
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ),
              );
            })
    );
  }
}
