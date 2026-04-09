import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/participant.dart';
import '../providers/app_provider.dart';
import 'package:intl/intl.dart';

class ParticipantDetailScreen extends StatefulWidget {
  final Participant participant;

  const ParticipantDetailScreen({super.key, required this.participant});

  @override
  State<ParticipantDetailScreen> createState() => _ParticipantDetailScreenState();
}

class _ParticipantDetailScreenState extends State<ParticipantDetailScreen> {
  List<Map<String, dynamic>> attendances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    final list = await Provider.of<AppProvider>(context, listen: false)
        .getParticipantAttendanceHistory(widget.participant);
    setState(() {
      attendances = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.participant.lastName} ${widget.participant.firstName}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : attendances.isEmpty
              ? const Center(child: Text('Nessuna lezione registrata per questo gruppo.'))
              : ListView.builder(
                  itemCount: attendances.length,
                  itemBuilder: (context, index) {
                    final att = attendances[index];
                    final dateStr = att['date'] as String;
                    final isPresent = (att['is_present'] as int) == 1;
                    
                    final date = DateTime.tryParse(dateStr);
                    final formattedDate = date != null
                        ? DateFormat('dd MMM yyyy').format(date)
                        : dateStr;

                    return ListTile(
                      title: Text('Lezione del $formattedDate'),
                      trailing: isPresent
                          ? const Icon(Icons.check_box, color: Colors.green)
                          : const Icon(Icons.close, color: Colors.red),
                      tileColor: isPresent ? Colors.green.withAlpha(25) : Colors.red.withAlpha(15),
                    );
                  },
                ),
    );
  }
}
