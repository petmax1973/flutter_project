import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access localhost of the machine
  // Use localhost for Web and macOS
  // For simplicity, we can use a configurable base URL
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<List<Task>> getTasks({List<String>? statuses, String? query}) async {
    final Map<String, String> queryParams = {};
    if (statuses != null && statuses.isNotEmpty) {
      queryParams['status'] = statuses.join(',');
    }
    // Note: Simple search implementation if backend supports it via filter/expand
    // For now, filtering only by status as implemented in controller

    final uri = Uri.parse(
      '$baseUrl/tasks',
    ).replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));

    if (response.statusCode != 204) {
      // Yii rest delete returns 204 No Content
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task');
      }
    }
  }
}
