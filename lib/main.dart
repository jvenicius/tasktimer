import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minhas_tarefas/models/task.dart';
import 'package:minhas_tarefas/providers/task_provider.dart';
import 'package:minhas_tarefas/screens/task_list_screen.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
import 'package:minhas_tarefas/screens/add_task_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request notification permission
  if (await Permission.notification.request().isGranted) {
    log('Notification permission granted.');
  } else {
    log('Notification permission denied.');
  }

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
        primaryColor: Colors.black, // Cor principal
        hintColor: Colors.blueAccent, // Cor secundária
        scaffoldBackgroundColor: Colors.white, // Cor de fundo
        appBarTheme: const AppBarTheme(
          color: Colors.black, // Cor da AppBar
          iconTheme:
              IconThemeData(color: Colors.white), // Cor dos ícones na AppBar
          titleTextStyle: TextStyle(
            color: Colors.white, // Cor do texto na AppBar
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // Cor do texto principal
          bodyMedium: TextStyle(color: Colors.black), // Cor do texto secundário
          headlineLarge: TextStyle(
              color: Colors.black), // Cor do texto principal em títulos
          headlineMedium: TextStyle(
              color: Colors.black), // Cor do texto secundário em títulos
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blueAccent, // Cor do botão
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: const IconThemeData(
          color: Colors.blueAccent, // Cor dos ícones
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blueAccent, // Cor do FAB
          foregroundColor: Colors.white, // Cor do ícone no FAB
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

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
