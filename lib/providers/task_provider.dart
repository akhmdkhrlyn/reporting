import 'package:flutter/material.dart';
import 'package:reporting/models/task_model.dart';
import 'package:reporting/services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];

  TaskProvider() {
    fetchTasks();
  }

  DateTime _selectedDate = DateTime.now();
  DateTime _displayedMonth = DateTime(2025, 4);
  String _searchQuery = "";

  // Getters
  List<Task> get allTasks => _tasks;
  DateTime get selectedDate => _selectedDate;
  DateTime get displayedMonth => _displayedMonth;
  String get searchQuery => _searchQuery;

  List<Task> get completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.completed).toList();
  List<Task> get pendingTasks =>
      _tasks.where((task) => task.status == TaskStatus.pending).toList();
  List<Task> get canceledTasks =>
      _tasks.where((task) => task.status == TaskStatus.canceled).toList();
  List<Task> get onGoingTasks =>
      _tasks.where((task) => task.status == TaskStatus.onGoing).toList();

  List<Task> get todayTasks =>
      _tasks
          .where((task) => DateUtils.isSameDay(task.date, DateTime.now()))
          .toList();

  List<Task> get tasksForSelectedDate {
    return _tasks
        .where(
          (task) =>
              DateUtils.isSameDay(task.date, _selectedDate) &&
              (task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  task.tags.any(
                    (tag) => tag.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
                  )),
        )
        .toList();
  }

  // --- API Methods ---
  Future<void> fetchTasks() async {
    try {
      _tasks = await _apiService.getTasks();
      notifyListeners();
    } catch (e) {
      print(e); // Di aplikasi nyata, tampilkan pesan error ke pengguna
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _apiService.addTask(task);
      await fetchTasks(); // Ambil ulang data dari server untuk sinkronisasi
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _apiService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId); // Update UI lebih cepat
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTask(String id, String title, TaskStatus status) async {
    try {
      await _apiService.updateTask(id, title, status);
      await fetchTasks(); // Ambil ulang data dari server untuk sinkronisasi
    } catch (e) {
      print(e);
    }
  }

  // --- UI State Methods ---
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void nextMonth() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    notifyListeners();
  }

  // --- Chart Data Methods (Contoh data dikembalikan agar tidak error) ---
  List<ScatterSpot> get priorityChartData {
    return [
      ScatterSpot(
        1.0,
        4.0,
        dotPainter: FlDotCirclePainter(
          radius: 6,
          color: _getColorForType('Personal'),
        ),
      ),
      ScatterSpot(
        2.0,
        2.0,
        dotPainter: FlDotCirclePainter(
          radius: 6,
          color: _getColorForType('Secret'),
        ),
      ),
      ScatterSpot(
        3.0,
        8.0,
        dotPainter: FlDotCirclePainter(
          radius: 8,
          color: _getColorForType('Personal'),
        ),
      ),
    ];
  }

  List<BarChartGroupData> get activityChartData {
    return [
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 5,
            color: _getColorForType("Personal"),
            width: 5,
          ),
          BarChartRodData(toY: 3, color: _getColorForType("Private"), width: 5),
        ],
      ),
    ];
  }

  Color _getColorForType(String? type) {
    switch (type) {
      case "Personal":
        return Colors.red.shade300;
      case "Private":
        return Colors.purple.shade300;
      case "Secret":
        return Colors.cyan.shade300;
      default:
        return Colors.grey;
    }
  }
}
