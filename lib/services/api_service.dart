import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:reporting/models/task_model.dart';

class ApiService {
  // Gunakan IP ini untuk emulator Android, ganti jika perlu
  final String baseUrl = "http://10.0.2.2:3000";

  // --- Auth Services ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> register(String username, String email, String password) async {
    await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );
  }

  // --- Task Services ---
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) {
        return Task(
          id: model['id'],
          title: model['title'],
          time: model['time'],
          date: DateTime.parse(model['date']),
          status: TaskStatus.values.firstWhere(
            (e) => e.toString().split('.').last == model['status'],
          ),
          tags: [], // Tags perlu penanganan terpisah jika disimpan di DB
          type: model['type'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(Task task) async {
    await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': task.id,
        'title': task.title,
        'time': task.time,
        'date': task.date.toIso8601String(),
        'status': task.status.toString().split('.').last,
        'type': task.type ?? '',
      }),
    );
  }

  Future<void> updateTask(String id, String title, TaskStatus status) async {
    await http.put(
      Uri.parse('$baseUrl/tasks/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'status': status.toString().split('.').last,
      }),
    );
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task.');
    }
  }
}
