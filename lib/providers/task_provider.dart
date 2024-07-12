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

    // Ativar temporizadores para tarefas em andamento
    for (var task in _tasks) {
      if (!task.isCompleted && !task.isPaused) {
        _startTaskTimer(task);
      }
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
    if (!task.isPaused && !task.isCompleted) {
      _startTaskTimer(task);
    }
    notifyListeners();
  }

  // Alternar pausa de uma tarefa
  void togglePauseTask(Task task) {
    task.isPaused = !task.isPaused;
    if (!task.isPaused && !task.isCompleted) {
      _startTaskTimer(task);
    } else {
      _cancelTaskTimer(task);
    }
    _saveTasks();
    notifyListeners();
  }

  void _startTaskTimer(Task task) {
    if (task.isCompleted || task.isPaused || task.timer != null) {
      return; // Não iniciar timer se a tarefa já estiver concluída, pausada ou se já houver um timer ativo
    }

    const oneSecond = Duration(seconds: 1);
    task.timer = Timer.periodic(oneSecond, (timer) {
      if (!task.isPaused) {
        task.remainingTime -= oneSecond;
        if (task.remainingTime <= Duration.zero) {
          task.isCompleted = true;
          _completedTasks.add(task);
          _tasks.remove(task); // Remover da lista de tarefas ativas
          _cancelTaskTimer(task);
          _showTaskCompletionNotification(task);
          _saveTasks();
          notifyListeners();
        } else {
          notifyListeners(); // Notificar mudanças no tempo restante
        }
      }
    });
  }

  // Cancelar temporizador de uma tarefa
  void _cancelTaskTimer(Task task) {
    task.timer?.cancel();
    task.timer = null;
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

  void removeTask(Task task) {
    if (_tasks.contains(task)) {
      _tasks.remove(task); // Remover da lista de tarefas ativas
    } else if (_completedTasks.contains(task)) {
      _completedTasks.remove(task); // Remover da lista de tarefas concluídas
    }
    _saveTasks();
    notifyListeners();
  }
}
