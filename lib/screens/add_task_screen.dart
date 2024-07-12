import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _nameController = TextEditingController();
  Duration _selectedDuration = const Duration(minutes: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome da Tarefa'),
            ),
            const SizedBox(height: 20),
            const Text("Duração:"),
            TimePickerSpinner(
              is24HourMode: true,
              normalTextStyle:
                  const TextStyle(fontSize: 24, color: Colors.grey),
              highlightedTextStyle:
                  const TextStyle(fontSize: 24, color: Colors.black),
              spacing: 50,
              itemHeight: 60,
              isForce2Digits: true,
              minutesInterval: 1,
              onTimeChange: (time) {
                setState(() {
                  _selectedDuration = Duration(
                    hours: time.hour,
                    minutes: time.minute,
                  );
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _selectedDuration > Duration.zero) {
                    final task = Task(
                      name: _nameController.text,
                      duration: _selectedDuration,
                    );
                    Provider.of<TaskProvider>(context, listen: false)
                        .addTask(task);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Adicionar Tarefa'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
