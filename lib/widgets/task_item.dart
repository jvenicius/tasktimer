import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_timer/widgets/custom_linear_progress_bar.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final bool isCompleted;

  const TaskItem({super.key, required this.task, this.isCompleted = false});

  @override
  // ignore: library_private_types_in_public_api
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.task.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(!widget.isCompleted)
          AnimatedBuilder(
            animation: Provider.of<TaskProvider>(context, listen: false),
            builder: (context, child) {
              return CustomLinearProgressBar(
                value: widget.task.remainingTime.inSeconds /
                    widget.task.duration.inSeconds,
              );
            },
          ),
          Text(
            widget.isCompleted
                ? 'Tarefa concluída'
                : 'Tempo restante: ${widget.task.remainingTime.inHours.remainder(60)}:${widget.task.remainingTime.inMinutes.remainder(60)}:${(widget.task.remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(!widget.isCompleted)
          IconButton(
            icon: Icon(widget.task.isPaused ? Icons.play_arrow : Icons.pause, color: Colors.green),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .togglePauseTask(widget.task);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .removeTask(widget.task);
            },
          ),
        ],
      ),
    );
  }
}
