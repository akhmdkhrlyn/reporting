import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import 'package:reporting/pages/home_screen.dart'; // Diperlukan untuk _TaskListItem
import 'package:reporting/pages/graphic_screen.dart';
import 'package:reporting/pages/checklist_screen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: _buildSearchBar(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildDateSelector(),
                  const SizedBox(height: 30),
                  _buildTimeline(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // PERBAIKAN: Navigasi ke halaman tambah tugas
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: const Color(0xFF4A3780),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    // PERBAIKAN: Menghubungkan TextField dengan provider
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    return TextField(
      onChanged: (value) {
        taskProvider.setSearchQuery(value);
      },
      decoration: InputDecoration(
        hintText: 'Search for task',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () {
            // Logika untuk membersihkan pencarian bisa ditambahkan di sini
          },
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Task",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
          onPressed: () async {
            // PERBAIKAN: Logika untuk membuka date picker
            final taskProvider = Provider.of<TaskProvider>(
              context,
              listen: false,
            );
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: taskProvider.selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              taskProvider.selectDate(pickedDate);
            }
          },
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Consumer<TaskProvider>(
            builder:
                (context, provider, child) =>
                    Text(DateFormat('MMMM yyyy').format(provider.selectedDate)),
          ),
          style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return SizedBox(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 30, // Tampilkan 30 hari ke depan
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = DateUtils.isSameDay(
                date,
                taskProvider.selectedDate,
              );

              return GestureDetector(
                onTap: () => taskProvider.selectDate(date),
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xFF4A3780)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat(
                          'E',
                        ).format(date).substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeline() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // PERBAIKAN: Menggunakan tasksForSelectedDate yang sudah difilter
        final tasks = taskProvider.tasksForSelectedDate;
        if (tasks.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Column(
                children: [
                  const Text("You don't have any schedule"),
                  TextButton(
                    onPressed: () {
                      // PERBAIKAN: Navigasi ke halaman tambah tugas
                      Navigator.pushNamed(context, '/add');
                    },
                    child: const Text(
                      "+ Add Task",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      task.time.split('-')[0].trim(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(child: _TaskListItem(task: task)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // PERBAIKAN: Fungsi BottomAppBar dengan navigasi yang benar
  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          IconButton(
            icon: const Icon(Icons.list_alt, color: Color(0xFF4A3780)),
            onPressed: () {
              // Tidak melakukan apa-apa karena sudah di halaman ini
            },
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: Colors.grey),
            onPressed: () {
              Navigator.pushNamed(context, '/graphic');
            },
          ),
          IconButton(
            icon: const Icon(Icons.archive_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.pushNamed(context, '/checklist');
            },
          ),
        ],
      ),
    );
  }
}

// Menggunakan kembali widget _TaskListItem dari home_screen
class _TaskListItem extends StatelessWidget {
  final Task task;
  const _TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "Time: ${task.time}",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
