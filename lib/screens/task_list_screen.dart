import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas')),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    return TaskItem(task: taskProvider.tasks[index]);
                  },
                ),
              ),
              const Divider(),
              const Text('Tarefas Concluídas', style: TextStyle(fontSize: 20)),
              Expanded(
                child: ListView.builder(
                  itemCount: taskProvider.completedTasks.length,
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: taskProvider.completedTasks[index],
                      isCompleted: true,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
