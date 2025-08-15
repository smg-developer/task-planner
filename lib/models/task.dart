//enum TaskPriority { Low, Medium, High }

class Task {
  final title;
  final description;
  //final priority;
  final id;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.id,
  });
}
