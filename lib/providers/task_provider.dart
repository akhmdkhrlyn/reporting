import 'package:flutter/material.dart';
import 'package:reporting/models/task_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class TaskProvider with ChangeNotifier {
  // Data dummy dengan ID unik
  final List<Task> _tasks = [
    Task(
      id: 'task-1',
      title: "Mencuci Pakaian",
      time: "07:00 - 07:15",
      date: DateTime.now(),
      status: TaskStatus.onGoing,
      tags: [
        TaskTag(name: "Urgent", color: Colors.purple.shade100),
        TaskTag(name: "Home", color: Colors.orange.shade100),
      ],
      type: 'Personal',
    ),
    Task(
      id: 'task-2',
      title: "Rapat dengan Tim",
      time: "09:00 - 10:00",
      date: DateTime.now(),
      status: TaskStatus.onGoing,
      tags: [TaskTag(name: "Work", color: Colors.blue.shade100)],
      type: 'Private',
    ),
    Task(
      id: 'task-3',
      title: "Pergi ke Gym",
      time: "17:00 - 18:00",
      date: DateTime.now().add(const Duration(days: 1)),
      status: TaskStatus.pending,
      tags: [TaskTag(name: "Personal", color: Colors.green.shade100)],
      type: 'Personal',
    ),
    Task(
      id: 'task-4',
      title: "Selesaikan Laporan Bulanan",
      time: "13:00 - 15:00",
      date: DateTime.now(),
      status: TaskStatus.completed,
      tags: [TaskTag(name: "Work", color: Colors.blue.shade100)],
      type: 'Secret',
    ),
  ];

  DateTime _selectedDate = DateTime.now();
  DateTime _displayedMonth = DateTime(2025, 4);
  String _searchQuery = ""; // Tambahkan properti untuk pencarian

  // Getters
  List<Task> get allTasks => _tasks;
  DateTime get selectedDate => _selectedDate;
  DateTime get displayedMonth => _displayedMonth;
  String get searchQuery => _searchQuery; // Getter untuk pencarian

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

  // CRUD Methods
  void addTask(Task task) {
    final newTask = Task(
      id: Random().nextDouble().toString(),
      title: task.title,
      time: task.time,
      date: task.date,
      status: task.status,
      tags: task.tags,
      type: task.type,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final taskIndex = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex >= 0) {
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query; // Setter untuk pencarian
    notifyListeners();
  }

  List<Task> getTasksForHour(int hour) {
    return _tasks.where((task) {
      final taskStartHour = int.tryParse(task.time.split('-')[0].split(':')[0]);
      return taskStartHour == hour &&
          DateUtils.isSameDay(task.date, _selectedDate);
    }).toList();
  }

  void nextMonth() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    notifyListeners();
  }

  // Chart Data Methods
  // Chart Data Methods
  List<ScatterSpot> get priorityChartData {
    // KODE YANG DIPERBAIKI:
    // Argumen posisi: x dan y dimasukkan langsung di awal.
    return [
      ScatterSpot(
        1.0, // Nilai X
        4.0, // Nilai Y
        dotPainter: FlDotCirclePainter(
          radius: 6,
          color: _getColorForType('Personal'),
        ),
      ),
      ScatterSpot(
        2.0, // Nilai X
        2.0, // Nilai Y
        dotPainter: FlDotCirclePainter(
          radius: 6,
          color: _getColorForType('Secret'),
        ),
      ),
      ScatterSpot(
        3.0, // Nilai X
        8.0, // Nilai Y
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

  // Helper untuk warna grafik
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
