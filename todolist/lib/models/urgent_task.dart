import 'task.dart';

class UrgentTask extends Task {
  String reason;

  UrgentTask({
    required int id,
    required String title,
    required this.reason,
    bool isCompleted = false,
    DateTime? dueDate,
  }) : super(
         id: id,
         title: title,
         priority: Priority.high, // Priorité élevée pour les tâches urgentes
         isCompleted: isCompleted,
         dueDate: dueDate,
       );

  @override
  Map<String, dynamic> toJson() {
    return{
      'id':id,
      'title':title,
      'type':'urgent',
      'priority':priority.name,
      'date':dueDate?.toIso8601String(),
      'isCompleted':isCompleted
    };
  }

  @override
  void create() {
    print('Urgent task created: $title (Reason: $reason) at $dueDate');
  }
}