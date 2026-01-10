import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _selectedStatuses = [];
  String _searchQuery = '';

  List<Task> get tasks {
    if (_searchQuery.isEmpty) {
      return _tasks;
    }
    return _tasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (task.description?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get selectedStatuses => _selectedStatuses;

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _apiService.getTasks(statuses: _selectedStatuses);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleStatusFilter(String status) {
    if (_selectedStatuses.contains(status)) {
      _selectedStatuses.remove(status);
    } else {
      _selectedStatuses.add(status);
    }
    fetchTasks();
  }

  void clearFilters() {
    _selectedStatuses = [];
    fetchTasks();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    try {
      final newTask = await _apiService.createTask(task);
      _tasks.insert(0, newTask);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      final updatedTask = await _apiService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    }
  }
}
