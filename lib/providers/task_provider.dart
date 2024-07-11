import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks;
  final List<Task> _completedTasks;
  final String _tasksKey = 'tasks';
  final String _completedTasksKey = 'completed_tasks';
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  TaskProvider({
    required List<Task> tasks,
    required List<Task> completedTasks,
  })  : _tasks = tasks,
        _completedTasks = completedTasks {
    _initNotifications();
    _loadTasks(); // Carregar as tarefas salvas ao inicializar o provider
    _startPeriodicTaskUpdate(); // Iniciar o update periódico
  }

  List<Task> get completedTasks => _completedTasks;

  List<Task> get tasks => _tasks;

  // Inicializar o plugin de notificações locais
  void _initNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Carregar as tarefas salvas do SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? tasksJson = prefs.getStringList(_tasksKey);
    final List<String>? completedTasksJson =
        prefs.getStringList(_completedTasksKey);

    if (tasksJson != null) {
      _tasks.clear();
      _tasks.addAll(tasksJson.map((json) => Task.fromJson(jsonDecode(json))));
    }

    if (completedTasksJson != null) {
      _completedTasks.clear();
      _completedTasks.addAll(
          completedTasksJson.map((json) => Task.fromJson(jsonDecode(json))));
    }

    notifyListeners(); // Notificar os ouvintes após carregar as tarefas
  }

  // Salvar as tarefas no SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    // Convertendo lista de tasks para lista de JSON (String)
    List<String> tasksJson =
        _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);

    // Convertendo lista de tarefas concluídas para JSON
    List<String> completedTasksJson =
        _completedTasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_completedTasksKey, completedTasksJson);
  }

  // Adicionar uma nova tarefa
  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  // Alternar pausa de uma tarefa
  void togglePauseTask(Task task) {
    task.isPaused = !task.isPaused;
    _saveTasks();
    notifyListeners();
  }

  // Exibir notificação de conclusão de tarefa
  Future<void> _showTaskCompletionNotification(Task task) async {
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
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Tarefa Concluída',
      '${task.name} foi concluída!',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  // Atualizar tempo da tarefa
  void updateTaskTime(Task task) {
    if (!task.isPaused && !task.isCompleted) {
      const oneSecond = Duration(seconds: 1);
      task.remainingTime -= oneSecond;
      if (task.remainingTime <= Duration.zero) {
        task.isCompleted = true;
        _completedTasks.add(task);
        _tasks.remove(task); // Remover da lista de tarefas ativas
        _showTaskCompletionNotification(task);
        _saveTasks();
      }
      notifyListeners();
    }
  }

  void removeTask(Task task) {
    if (_tasks.contains(task)) {
      _tasks.remove(task); // Remover da lista de tarefas ativas
    } else if (_completedTasks.contains(task)) {
      _completedTasks.remove(task); // Remover da lista de tarefas concluídas
    }
    _saveTasks();
    notifyListeners();
  }

  // Método para iniciar a atualização periódica das tarefas
  void _startPeriodicTaskUpdate() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      for (var task in _tasks) {
        if (!task.isPaused && !task.isCompleted) {
          updateTaskTime(task);
        }
      }
    });
  }
}
