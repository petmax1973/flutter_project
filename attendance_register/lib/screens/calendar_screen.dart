import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'attendance_group_selection_screen.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Column(
        children: [
          TableCalendar(
            locale: 'it_IT',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; 
              });
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceGroupSelectionScreen(date: selectedDay),
                ),
              ).then((_) {
                setState(() {}); // refresh event dots
              });
            },
            eventLoader: (day) {
               final dateStr = DateFormat('yyyy-MM-dd').format(day);
               if (Provider.of<AppProvider>(context, listen: false).lessonDates.contains(dateStr)) {
                 return const ['lesson'];
               }
               return const [];
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Seleziona una data per registrare o visualizzare le presenze.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
