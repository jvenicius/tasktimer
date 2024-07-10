import 'dart:async';

class Task {
  String name;
  Duration duration;
  Duration remainingTime;
  bool isPaused;
  bool isCompleted;
  Timer? timer; // Adicionando o campo timer

  Task({
    required this.name,
    required this.duration,
  })  : remainingTime = duration,
        isPaused = true,
        isCompleted = false;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      duration: Duration(seconds: json['duration']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration.inSeconds,
    };
  }
}
