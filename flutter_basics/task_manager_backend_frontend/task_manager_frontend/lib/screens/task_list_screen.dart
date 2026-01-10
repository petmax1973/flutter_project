import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'task_form_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () =>
                Provider.of<TaskProvider>(context, listen: false).fetchTasks(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).setSearchQuery(value);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ActionChip(
                    label: Text('Clear All'),
                    onPressed: () => Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).clearFilters(),
                  ),
                ),
                _FilterChip(label: 'Pending', status: 'pending'),
                _FilterChip(label: 'In Progress', status: 'in_progress'),
                _FilterChip(label: 'Suspended', status: 'suspended'),
                _FilterChip(label: 'To Release', status: 'to_release'),
                _FilterChip(label: 'Completed', status: 'completed'),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null) {
                  return Center(child: Text('Error: ${provider.errorMessage}'));
                }

                if (provider.tasks.isEmpty) {
                  return Center(child: Text('No tasks found.'));
                }

                return ListView.builder(
                  itemCount: provider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = provider.tasks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(task.status),
                          child: Text(
                            task.priority.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(task.title),
                        subtitle: Text(task.assignedTo ?? 'Unassigned'),
                        trailing: Chip(
                          label: Text(
                            _getStatusLabel(task.status),
                            style: TextStyle(fontSize: 12),
                          ),
                          backgroundColor: _getStatusColor(
                            task.status,
                          ).withOpacity(0.1),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TaskDetailScreen(task: task),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String status;

  _FilterChip({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final isSelected = provider.selectedStatuses.contains(status);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          provider.toggleStatusFilter(status);
        },
      ),
    );
  }
}
