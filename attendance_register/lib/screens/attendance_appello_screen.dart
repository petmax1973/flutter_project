import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/group.dart' as app_models;
import '../models/participant.dart';
import '../providers/app_provider.dart';
import 'package:intl/intl.dart';

class AttendanceAppelloScreen extends StatefulWidget {
  final app_models.Group group;
  final DateTime date;

  const AttendanceAppelloScreen({Key? key, required this.group, required this.date}) : super(key: key);

  @override
  State<AttendanceAppelloScreen> createState() => _AttendanceAppelloScreenState();
}

class _AttendanceAppelloScreenState extends State<AttendanceAppelloScreen> {
  List<Participant> participants = [];
  Map<String, bool> attendanceMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    
    await provider.loadParticipants(widget.group.id);
    participants = provider.groupParticipants[widget.group.id] ?? [];
    
    final attendances = await provider.getAttendancesForGroupAndDate(widget.group.id, widget.date);
    
    for (var p in participants) {
      attendanceMap[p.id] = false;
    }
    
    for (var att in attendances) {
      attendanceMap[att.participantId] = att.isPresent;
    }
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy').format(widget.date);

    return Scaffold(
      appBar: AppBar(title: Text('Appello ${widget.group.name}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : participants.isEmpty
              ? const Center(child: Text('Nessun partecipante nel gruppo.'))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Data: $dateStr',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: participants.length,
                        itemBuilder: (context, index) {
                          final p = participants[index];
                          final isPresent = attendanceMap[p.id] ?? false;

                          return CheckboxListTile(
                            title: Text('${p.lastName} ${p.firstName}'),
                            value: isPresent,
                            activeColor: Colors.green,
                            onChanged: (bool? value) async {
                              final newValue = value ?? false;
                              setState(() {
                                attendanceMap[p.id] = newValue;
                              });
                              // Auto-salvataggio come richiesto (Q2)
                              await Provider.of<AppProvider>(context, listen: false)
                                  .toggleAttendance(p.id, widget.date, newValue);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
