// lib/pages/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reporting/pages/add_task_screen.dart';
import 'package:reporting/pages/checklist_screen.dart';
import 'package:reporting/pages/graphic_screen.dart';
import 'package:reporting/pages/task_screen.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengakses provider
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildMyTaskSection(context, taskProvider),
            const SizedBox(height: 30),
            _buildTodayTaskSection(context, taskProvider),
          ],
        ),
      ),
      // PENYESUAIAN: Widget BottomAppBar sekarang terhubung dengan navigasi
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah tugas
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: const Color(0xFF4A3780),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, Yani",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              "Let's make this day productive",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
        ),
      ],
    );
  }

  Widget _buildMyTaskSection(BuildContext context, TaskProvider taskProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Task",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _TaskSummaryCard(
              title: "Completed",
              taskCount: taskProvider.completedTasks.length,
              iconData: Icons.check_circle_outline,
              gradientColors: const [Color(0xFF89F7FE), Color(0xFF66A6FF)],
            ),
            _TaskSummaryCard(
              title: "Pending",
              taskCount: taskProvider.pendingTasks.length,
              iconData: Icons.access_time_filled_rounded,
              gradientColors: const [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
            ),
            _TaskSummaryCard(
              title: "Canceled",
              taskCount: taskProvider.canceledTasks.length,
              iconData: Icons.cancel_outlined,
              gradientColors: const [Color(0xFFff9a9e), Color(0xFFfad0c4)],
            ),
            _TaskSummaryCard(
              title: "On Going",
              taskCount: taskProvider.onGoingTasks.length,
              iconData: Icons.directions_run,
              gradientColors: const [Color(0xFFa8e063), Color(0xFF56ab2f)],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayTaskSection(
    BuildContext context,
    TaskProvider taskProvider,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Today Task",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task');
              },
              child: const Text("View all"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        taskProvider.todayTasks.isEmpty
            ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Text(
                  "Tidak ada tugas untuk hari ini.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
            : ListView.builder(
              itemCount: taskProvider.todayTasks.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final task = taskProvider.todayTasks[index];
                // Hapus `taskProvider` dari sini karena sudah bisa diakses di dalam _TaskListItem
                return _TaskListItem(task: task);
              },
            ),
      ],
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_filled, color: Color(0xFF4A3780)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.list_alt, color: Colors.grey),
            onPressed: () {
              Navigator.pushNamed(context, '/task');
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

class _TaskSummaryCard extends StatelessWidget {
  final String title;
  final int taskCount;
  final IconData iconData;
  final List<Color> gradientColors;

  const _TaskSummaryCard({
    required this.title,
    required this.taskCount,
    required this.iconData,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(iconData, color: Colors.white, size: 30),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "$taskCount Task",
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

enum _TaskAction { edit, delete }

class _TaskListItem extends StatelessWidget {
  final Task task;

  const _TaskListItem({required this.task});

  // Dialog untuk konfirmasi hapus
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah Anda yakin ingin menghapus tugas "${task.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).deleteTask(task.id);
                Navigator.of(ctx).pop();
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ** INI FUNGSI YANG DIPERBAIKI DAN DIPINDAH KE DALAM CLASS **
  void _showEditTaskDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    TaskStatus status = task.status;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Task Title'),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<TaskStatus>(
                    value: status,
                    onChanged: (TaskStatus? newValue) {
                      setState(() {
                        status = newValue!;
                      });
                    },
                    items:
                        TaskStatus.values.map((TaskStatus status) {
                          return DropdownMenuItem<TaskStatus>(
                            value: status,
                            child: Text(status.toString().split('.').last),
                          );
                        }).toList(),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<TaskProvider>(
                  context,
                  listen: false,
                ).updateTask(task.id, titleController.text, status);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color:
                    task.status == TaskStatus.onGoing
                        ? Colors.red.shade200
                        : Colors.blue.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    task.time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children:
                        task.tags
                            .map(
                              (tag) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: tag.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  tag.name,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
            PopupMenuButton<_TaskAction>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              // ** INI LOGIKA onSelected YANG DIPERBAIKI **
              onSelected: (_TaskAction action) {
                switch (action) {
                  case _TaskAction.edit:
                    _showEditTaskDialog(context, task); // Panggil dialog
                    break;
                  case _TaskAction.delete:
                    _showDeleteConfirmation(context);
                    break;
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<_TaskAction>>[
                    const PopupMenuItem<_TaskAction>(
                      value: _TaskAction.edit,
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<_TaskAction>(
                      value: _TaskAction.delete,
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text('Hapus', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
      ),
    );
  }
}
