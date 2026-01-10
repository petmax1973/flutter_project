import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.blue;
      case 'suspended':
        return Colors.orange;
      case 'to_release':
        return Colors.purple;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'suspended':
        return 'Suspended';
      case 'to_release':
        return 'To Release';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Task?'),
        content: Text('Are you sure you want to remove this task?'),
        actions: [
          TextButton(
            child: Text('CANCEL'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text('DELETE', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).deleteTask(task.id!);
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting task: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskFormScreen(task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(task.status)),
                  ),
                  child: Text(
                    _getStatusLabel(task.status),
                    style: TextStyle(
                      color: _getStatusColor(task.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _DetailItem(
              label: 'Assigned To',
              value: task.assignedTo ?? 'Unassigned',
            ),
            _DetailItem(label: 'Priority', value: 'Level ${task.priority}'),
            SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              task.description ?? 'No description provided.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
