import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:reporting/models/task_model.dart';

class ApiService {
  final String baseUrl = "http://localhost:3000";

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
          tags: [], // Tags need separate handling
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
      body: jsonEncode(<String, String>{
        'id': task.id,
        'title': task.title,
        'time': task.time,
        'date': task.date.toIso8601String(),
        'status': task.status.toString().split('.').last,
        'type': task.type ?? '',
      }),
    );
  }
}
