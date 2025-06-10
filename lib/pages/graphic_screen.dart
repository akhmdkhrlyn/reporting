// lib/screens/graphic_screen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class GraphicScreen extends StatelessWidget {
  const GraphicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Graphic", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildPriorityChartCard(),
          const SizedBox(height: 30),
          _buildActivityChartCard(),
        ],
      ),
      // PERBAIKAN: Menggunakan Bottom App Bar dengan navigasi
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: const Color(0xFF4A3780),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildPriorityChartCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dan Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Priority",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text("Task Perday", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    _buildLegendItem(Colors.red.shade300, "Personal"),
                    const SizedBox(width: 10),
                    _buildLegendItem(Colors.purple.shade300, "Private"),
                    const SizedBox(width: 10),
                    _buildLegendItem(Colors.cyan.shade300, "Secret"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Scatter Plot Chart
            SizedBox(
              height: 200,
              child: Consumer<TaskProvider>(
                builder: (context, provider, child) {
                  return ScatterChart(
                    ScatterChartData(
                      scatterSpots: provider.priorityChartData,
                      minX: 1,
                      maxX: 7,
                      minY: 0,
                      maxY: 10,
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: false,
                        getDrawingVerticalLine:
                            (value) => const FlLine(
                              color: Colors.black12,
                              strokeWidth: 1,
                              dashArray: [3, 3],
                            ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            getTitlesWidget:
                                (value, meta) =>
                                    Text("${value.toInt()}".padLeft(2, '0')),
                            reservedSize: 30,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = [
                                'Mo',
                                'Tu',
                                'We',
                                'Th',
                                'Fr',
                                'Sa',
                                'Su',
                              ];
                              return Text(days[value.toInt() - 1]);
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChartCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<TaskProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Activity",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 15),
                // Navigasi Bulan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: provider.previousMonth,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(provider.displayedMonth),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: provider.nextMonth,
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Bar Chart
                SizedBox(
                  height: 150,
                  child: BarChart(
                    BarChartData(
                      barGroups: provider.activityChartData,
                      alignment: BarChartAlignment.spaceAround,
                      titlesData: const FlTitlesData(
                        show: false,
                      ), // Sembunyikan semua label
                      borderData: FlBorderData(
                        show: false,
                      ), // Sembunyikan border
                      gridData: const FlGridData(
                        show: false,
                      ), // Sembunyikan grid
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // PERBAIKAN: Fungsi BottomAppBar dengan navigasi yang benar
  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      elevation: 5,
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
            icon: const Icon(Icons.list_alt_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.pushNamed(context, '/task');
            },
          ),
          const SizedBox(width: 40),
          IconButton(
            icon: const Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFF4A3780), // Halaman aktif
            ),
            onPressed: () {
              // Tidak melakukan apa-apa
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
