
import 'package:todolist/models/task.dart';

class SimpleTask extends Task {
  SimpleTask({
    required int id,
    required String title,
    required Priority priority,
    bool isCompleted = false,
    DateTime? dueDate,
  }) : super(
         id: id,
         title: title,
         priority: priority,
         isCompleted: isCompleted,
         dueDate: dueDate,
       );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': 'simple',
      'priority': priority.name,
      'date': dueDate?.toIso8601String(),
      'isCompleted': isCompleted
    };
  }
}