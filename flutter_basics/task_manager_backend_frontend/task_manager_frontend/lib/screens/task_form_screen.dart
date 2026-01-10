import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  String? _assignedTo;
  late String _status;
  late int _priority;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _isEditing = true;
      _title = widget.task!.title;
      _description = widget.task!.description;
      _assignedTo = widget.task!.assignedTo;
      _status = widget.task!.status;
      _priority = widget.task!.priority;
    } else {
      _title = '';
      _status = 'pending';
      _priority = 1;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isSaving = true);

      final task = Task(
        id: widget.task?.id,
        title: _title,
        description: _description,
        assignedTo: _assignedTo,
        status: _status,
        priority: _priority,
      );

      try {
        final provider = Provider.of<TaskProvider>(context, listen: false);
        if (_isEditing) {
          await provider.updateTask(task);
        } else {
          await provider.addTask(task);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving task: $e')));
      } finally {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Task' : 'New Task')),
      body: _isSaving
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(labelText: 'Title *'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value!,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      onSaved: (value) => _description = value,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: _assignedTo,
                      decoration: InputDecoration(labelText: 'Assigned To'),
                      onSaved: (value) => _assignedTo = value,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      value: _status,
                      items: [
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'in_progress',
                          child: Text('In Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'suspended',
                          child: Text('Suspended'),
                        ),
                        DropdownMenuItem(
                          value: 'to_release',
                          child: Text('To Release'),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text('Completed'),
                        ),
                      ],
                      onChanged: (value) => setState(() => _status = value!),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Priority: $_priority',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _priority.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _priority.toString(),
                      onChanged: (value) =>
                          setState(() => _priority = value.round()),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        child: Text(_isEditing ? 'UPDATE TASK' : 'CREATE TASK'),
                        onPressed: _saveForm,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
