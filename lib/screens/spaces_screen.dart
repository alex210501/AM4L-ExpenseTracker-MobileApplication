import 'package:flutter/material.dart';

import 'package:am4l_expensetracker_mobileapplication/models/space.dart';
import 'package:am4l_expensetracker_mobileapplication/services/api/expenses_tracker_api.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spaces'),),
      body: FutureBuilder<List<Space>>(
          future: _getSpaces(),
          builder: (BuildContext context, AsyncSnapshot<List<Space>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return _SpaceListView(spaces: snapshot.data ?? []);
            }

            return const Center(child: Text('Empty Data'));
          }));
  }
}

@immutable
class _SpaceListView extends StatefulWidget {
  final List<Space> spaces;

  const _SpaceListView({super.key, required this.spaces});

  @override
  State<_SpaceListView> createState() => _SpaceListViewState();
}

class _SpaceListViewState extends State<_SpaceListView> {
  @override
  Widget build(BuildContext context) {
    final spaces = widget.spaces;

    return Center(
        child: ListView.builder(
          itemCount: spaces.length,
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                      title: Text(spaces[index].name),
                      subtitle: Text(spaces[index].description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => print('Edit'),
                              icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                              onPressed: () => print('Delete'),
                              icon: const Icon(Icons.delete)
                          ),
                        ],
                      ),
                  ),
              );
        }
        )
    );
  }
}
