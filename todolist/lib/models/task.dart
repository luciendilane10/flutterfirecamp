enum Priority { low, medium, high }

abstract class Task {
  int id;
  String title;
  Priority priority;
  bool isCompleted;
  DateTime? date;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.isCompleted = false,
    this.date,
  });

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  void create() {
    print('Task created: $title');
  }

  Map<String, dynamic> toJson();
}
