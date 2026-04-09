import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'attendance_appello_screen.dart';
import 'package:intl/intl.dart';

class AttendanceGroupSelectionScreen extends StatelessWidget {
  final DateTime date;

  const AttendanceGroupSelectionScreen({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy').format(date);

    return Scaffold(
      appBar: AppBar(title: Text('Gruppi del $dateStr')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final groups = provider.groups;
          if (groups.isEmpty) {
            return const Center(child: Text('Nessun gruppo disponibile. Clicca + nella sezione Partecipanti per crearne uno.'));
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
                      builder: (context) => AttendanceAppelloScreen(
                        group: group,
                        date: date,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
