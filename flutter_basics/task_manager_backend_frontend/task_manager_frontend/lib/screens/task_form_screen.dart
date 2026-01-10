import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({super.key, this.task});

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? l10n.addTask : l10n.editTask),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _title,
                      decoration: InputDecoration(labelText: l10n.title),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                      onSaved: (value) => _title = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _description,
                      decoration: InputDecoration(labelText: l10n.description),
                      maxLines: 3,
                      onSaved: (value) => _description = value,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _assignedTo,
                      decoration: InputDecoration(labelText: l10n.assignedTo),
                      onSaved: (value) => _assignedTo = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _status,
                      decoration: InputDecoration(labelText: l10n.status),
                      items: [
                        DropdownMenuItem(
                          value: 'pending',
                          child: Text(l10n.statusPending),
                        ),
                        DropdownMenuItem(
                          value: 'in_progress',
                          child: Text(l10n.statusInProgress),
                        ),
                        DropdownMenuItem(
                          value: 'suspended',
                          child: Text(l10n.statusSuspended),
                        ),
                        DropdownMenuItem(
                          value: 'to_release',
                          child: Text(l10n.statusToRelease),
                        ),
                        DropdownMenuItem(
                          value: 'completed',
                          child: Text(l10n.statusCompleted),
                        ),
                      ],
                      onChanged: (value) => setState(() => _status = value!),
                    ),
                    const SizedBox(height: 16),
                    Text(l10n.priority),
                    Slider(
                      value: _priority.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _priority.toString(),
                      onChanged: (value) =>
                          setState(() => _priority = value.round()),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveForm,
                        child: Text(l10n.save),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
