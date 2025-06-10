import 'package:flutter/material.dart';

enum TaskStatus { completed, pending, canceled, onGoing }

class TaskTag {
  final String name;
  final Color color;
  TaskTag({required this.name, required this.color});
}

class Task {
  // 1. TAMBAHKAN properti 'id'
  final String id;
  final String title;
  final String time;
  final DateTime date;
  final TaskStatus status;
  final List<TaskTag> tags;
  final String? type;

  Task({
    // 2. TAMBAHKAN 'id' ke dalam constructor
    required this.id,
    required this.title,
    required this.time,
    DateTime? date,
    required this.status,
    required this.tags,
    this.type,
    // Menggunakan default value jika date null, ini sudah bagus
  }) : date = date ?? DateTime.now();
}
