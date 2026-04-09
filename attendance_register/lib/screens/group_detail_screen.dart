import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group.dart' as app_models;
import '../models/participant.dart';
import '../providers/app_provider.dart';
import 'participant_detail_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final app_models.Group group;

  const GroupDetailScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadParticipants(widget.group.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.group.name)),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final participants = provider.groupParticipants[widget.group.id] ?? [];
          if (participants.isEmpty) {
            return const Center(child: Text('Nessun partecipante in questo gruppo. Clicca + per aggiungere.'));
          }
          return ListView.builder(
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final participant = participants[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    '${participant.lastName} ${participant.firstName}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditParticipantDialog(context, participant),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteParticipant(context, participant),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParticipantDetailScreen(participant: participant),
                    ),
                  );
                },
              ),
            );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddParticipantDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddParticipantDialog(BuildContext context) {
    _showParticipantForm(context: context);
  }

  void _showEditParticipantDialog(BuildContext context, Participant participant) {
    _showParticipantForm(context: context, participant: participant);
  }

  void _showParticipantForm({required BuildContext context, Participant? participant}) {
    final isEditing = participant != null;
    final firstNameController = TextEditingController(text: isEditing ? participant.firstName : '');
    final lastNameController = TextEditingController(text: isEditing ? participant.lastName : '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Modifica Partecipante' : 'Aggiungi Partecipante'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(hintText: 'Cognome'),
              textCapitalization: TextCapitalization.words,
              autofocus: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(hintText: 'Nome'),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULLA'),
          ),
          ElevatedButton(
            onPressed: () {
              final first = firstNameController.text.trim();
              final last = lastNameController.text.trim();
              if (first.isNotEmpty && last.isNotEmpty) {
                if (isEditing) {
                  final updatedParticipant = Participant(
                    id: participant.id,
                    groupId: participant.groupId,
                    firstName: first,
                    lastName: last,
                  );
                  Provider.of<AppProvider>(context, listen: false).updateParticipant(updatedParticipant);
                } else {
                  Provider.of<AppProvider>(context, listen: false)
                      .addParticipant(widget.group.id, first, last);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('SALVA'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteParticipant(BuildContext context, Participant participant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina Partecipante'),
        content: Text('Sei sicuro di voler eliminare ${participant.lastName} ${participant.firstName}? Verranno eliminate anche le sue registrazioni di presenza.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULLA'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false)
                  .deleteParticipant(participant.id, participant.groupId);
              Navigator.pop(context);
            },
            child: const Text('ELIMINA', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
