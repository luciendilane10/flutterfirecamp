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
  
  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as int,
      title: json['title'] as String,
      reason: json['reason'] as String,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
  

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

  
}