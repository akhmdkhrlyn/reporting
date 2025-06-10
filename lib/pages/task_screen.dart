import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';
import './home_screen.dart'; // Tambahkan import ini

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
              child: _buildSearchBar(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  _buildHeader(),
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
      // Anda bisa menggunakan bottom app bar yang sama dari layar sebelumnya
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF4A3780),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for task',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.close, size: 18),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Task",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        TextButton.icon(
          onPressed: () {
            /* Logika untuk membuka date picker */
          },
          icon: const Icon(Icons.calendar_today, size: 16),
          label: Text(DateFormat('MMMM yyyy').format(DateTime.now())),
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
              final isSelected =
                  date.day == taskProvider.selectedDate.day &&
                  date.month == taskProvider.selectedDate.month;

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
                        DateFormat('E')
                            .format(date)
                            .substring(0, 2)
                            .toUpperCase(), // MO, TU, WE
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('d').format(date), // 12, 13, 14
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
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 5, // Tampilkan jadwal dari jam 7 pagi sampai jam 11
          itemBuilder: (context, index) {
            final hour = 7 + index;
            final tasksForHour = taskProvider.getTasksForHour(hour);

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 50,
                    child: Text(
                      "${hour.toString().padLeft(2, '0')}:00",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child:
                        tasksForHour.isEmpty
                            ? _buildEmptySlot(hour)
                            : Column(
                              children:
                                  tasksForHour
                                      .map(
                                        (task) => _TaskListItem(task: task),
                                      ) // Widget dari layar sebelumnya
                                      .toList(),
                            ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptySlot(int hour) {
    if (hour != 9)
      return const SizedBox.shrink(); // Hanya tampilkan di jam 9 sesuai desain
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        children: [
          Text(
            "You don't have any schedule",
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const Text(" or "),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "+ Add",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Widget ini bisa di-copy paste dari file home_screen.dart
  Widget _buildBottomAppBar(BuildContext context) {
    // Tambah parameter context
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home_filled, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list_alt, color: Color(0xFF4A3780)),
            onPressed: () {},
          ),

          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.archive_outlined, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// Widget ini bisa diletakkan di file terpisah atau di bawah.
// Sebaiknya, import dari file yang sama dengan home_screen agar tidak duplikat.
class _TaskListItem extends StatelessWidget {
  final Task task;
  const _TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    // ... (Kode untuk _TaskListItem sama persis dengan jawaban sebelumnya)
    return Card(/* ... */);
  }
}
