import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:minhas_tarefas/models/task.dart';
import 'package:minhas_tarefas/screens/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minhas_tarefas/providers/task_provider.dart';
import 'package:minhas_tarefas/screens/task_list_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do plugin de notificações locais
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Inicialização do SharedPreferences para carregar as tarefas salvas
  final prefs = await SharedPreferences.getInstance();
  List<String>? tasksJson = prefs.getStringList('tasks');
  List<String>? completedTasksJson = prefs.getStringList('completed_tasks');

  List<Task> tasks = [];
  if (tasksJson != null) {
    tasks = tasksJson
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  List<Task> completedTasks = [];
  if (completedTasksJson != null) {
    completedTasks = completedTasksJson
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          TaskProvider(tasks: tasks, completedTasks: completedTasks),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Timer by Venícius.Dev',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Timer para atualização das tarefas e notificações
    Timer.periodic(const Duration(seconds: 1), (timer) {
      Provider.of<TaskProvider>(context, listen: false).tasks.forEach((task) {
        Provider.of<TaskProvider>(context, listen: false).updateTaskTime(task);
      });
      Provider.of<TaskProvider>(context, listen: false)
          .tasks
          .where((task) => task.isCompleted)
          .forEach((task) {
        _showNotification(task.name);
      });
    });
  }

  Future<void> _showNotification(String taskName) async {
    // Configuração da notificação local
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Tarefa Concluída',
      '$taskName foi concluída!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Timer by Venícius.Dev'),
      ),
      body: const TaskListScreen(),
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
