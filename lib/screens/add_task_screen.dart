import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  Duration _selectedDuration = const Duration(minutes: 30);

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
            Text("Duração: ${_selectedDuration.inMinutes} minutos"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Duration? pickedDuration = await showDurationPicker(
                    context: context,
                    initialTime: _selectedDuration,
                  );
                  if (pickedDuration != null) {
                    setState(() {
                      _selectedDuration = pickedDuration;
                    });
                  }
                },
                child: const Text('Selecionar Duração'),
              ),
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
