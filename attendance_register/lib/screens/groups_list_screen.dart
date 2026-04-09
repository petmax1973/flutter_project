import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'group_detail_screen.dart';

class GroupsListScreen extends StatelessWidget {
  const GroupsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gruppi')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final groups = provider.groups;
          if (groups.isEmpty) {
            return const Center(child: Text('Nessun gruppo disponibile. Clicca + per crearne uno.'));
          }
          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                title: Text(group.name),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupDetailScreen(group: group),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGroupDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGroupDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuovo Gruppo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome Gruppo'),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULLA'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Provider.of<AppProvider>(context, listen: false).addGroup(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('SALVA'),
          ),
        ],
      ),
    );
  }
}
