import 'package:flutter/material.dart';
import 'dart:math';
// import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final List<Map<String, dynamic>> _checklists = [
    {'id': '1', 'title': 'Checklist Boiler', 'file': null},
    {'id': '2', 'title': 'Checklist Compressor', 'file': null},
    {'id': '3', 'title': 'Checklist HVAC', 'file': null},
    {'id': '4', 'title': 'Checklist Workshop', 'file': null},
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  File? _selectedFile;

  // Future<void> _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null) {
  //     setState(() {
  //       _selectedFile = File(result.files.single.path!);
  //     });
  //   }
  // }

  void _showAddChecklistDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Tambah Checklist Baru'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Checklist',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama checklist tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // ElevatedButton.icon(
                  //   onPressed: _pickFile,
                  //   icon: const Icon(Icons.upload_file),
                  //   label: Text(
                  //     _selectedFile == null
                  //         ? 'Pilih File'
                  //         : 'File: ${_selectedFile!.path.split('/').last}',
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: const Color(0xFF4A3780),
                  //   ),
                  // ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () {
                  _titleController.clear();
                  _selectedFile = null;
                  Navigator.of(ctx).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Simpan'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      final newId = Random().nextDouble().toString();
                      _checklists.add({
                        'id': newId,
                        'title': _titleController.text,
                        'file': _selectedFile,
                      });
                    });
                    _titleController.clear();
                    _selectedFile = null;
                    Navigator.of(ctx).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A3780),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _deleteChecklist(String id) {
    setState(() {
      _checklists.removeWhere((checklist) => checklist['id'] == id);
    });
  }

  // void _addChecklist(String title) {
  //   setState(() {
  //     final newId = Random().nextDouble().toString();
  //     _checklists.add({'id': newId, 'title': title});
  //   });
  // }

  void _showDeleteConfirmation(BuildContext context, String checklistId) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Hapus Checklist'),
            content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
              TextButton(
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  _deleteChecklist(checklistId);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const CircleAvatar(
              backgroundColor: Color(0xFFF0F0F0),
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
        title: const Text(
          "Pratinjau Checklist", // Fixed spelling
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        itemCount: _checklists.length,
        separatorBuilder:
            (context, index) =>
                const Divider(color: Colors.transparent, height: 10),
        itemBuilder: (context, index) {
          final checklist = _checklists[index];
          return ListTile(
            title: Text(
              checklist['title']!,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Pratinjau", style: TextStyle(color: Colors.grey)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A3780),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.show_chart,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap:
                      () => _showDeleteConfirmation(context, checklist['id']!),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddChecklistDialog, // Changed to use dialog
        backgroundColor: const Color(0xFF4A3780),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
