enum Priority { low, medium, high }

abstract class Task {
  int id;
  String title;
  Priority priority;
  bool isCompleted;
  DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.isCompleted = false,
    this.dueDate,
  });

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }



  Map<String, dynamic> toJson();
}
