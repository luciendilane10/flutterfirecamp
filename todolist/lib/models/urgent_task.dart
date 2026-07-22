import 'task.dart';

class UrgentTask extends Task {
  String reason;

  UrgentTask({
    required int id,
    required String title,
    required Priority priority,
    required this.reason,
    bool isCompleted = false,
    DateTime? date,
  }) : super(
         id: id,
         title: title,
         priority: Priority.high, // Priorité élevée pour les tâches urgentes
         isCompleted: isCompleted,
         date: date,
       );

  @override
  Map<String, dynamic> toJson() {
    return{
      'id':id,
      'title':title,
      'priority':priority.toString(),
      'date':date?.toIso8601String(),
      'isCompleted':isCompleted
    };
  }

  @override
  void create() {
    print('Urgent task created: $title (Reason: $reason) at $date');
  }
}
