import 'dart:io';
import 'dart:convert';

import 'package:todolist/models/simple_task.dart';

import '../models/task.dart';
import '../models/urgent_task.dart';
import '../exceptions/task_exception.dart';
import 'repository.dart';

class JsonTaskRepo implements Repository<Task> {
  final String filePath;
  List<Task> _tasks = [];

  JsonTaskRepo(this.filePath) {
    _loadFromFile();
  }

  @override
  void add(Task item) {
    _tasks.add(item);
    _saveTofile();
  }

  @override
  List<Task> getAll() {
    return _tasks;
  }

  @override
  void remove(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks.removeAt(index);
      _saveTofile();
    } else {
      throw TaskNotFound(id);
    }
  }

  @override
  void update(Task item) {
    //recherche de la tache
    final index = _tasks.indexWhere((task) => task.id == item.id);

    //On remplace si elle existe
    if (index != -1) {
      _tasks[index] = item;
      _saveTofile();
    } else {
      throw TaskNotFound(item.id);
    }
  }

  // Méthodes privés pour gérer le fichier json
  void _saveTofile() {
    final file = File(filePath);

    //Transformation en Map(json)
    final jsonlist = _tasks.map((t) => t.toJson()).toList();
    //Ecriture dans le fichier
    file.writeAsStringSync(jsonEncode(jsonlist));
  }

 void _loadFromFile() {
  final file = File(filePath);
  if (!file.existsSync()) return;

  final content = file.readAsStringSync();
  if (content.trim().isEmpty) return;

  try {
    final List<dynamic> jsonList = jsonDecode(content);

    _tasks = jsonList.map((item) {
      final map = item as Map<String, dynamic>;

      // On extrait l'ID en toute sécurité vers un int
      final id = (map['id'] as num?)?.toInt() ?? 0;
      final title = map['title']?.toString() ?? 'Tâche sans titre';
      final reason = map['reason']?.toString() ?? 'Urgence non spécifiée';
      final isCompleted = map['isCompleted'] == true;

      //Extraction de la date en toute sécurité
      final dueDateString = map['date']?.toString();
      final dueDate = dueDateString != null ? DateTime.tryParse(dueDateString) : null;

      // Conversion de la priorité en enum
      final priorityString = map['priority']?.toString();
      final priority = Priority.values.firstWhere(
        (p) => p.name == priorityString,
        orElse: () => Priority.low,
      );
      
      // Création de la tâche en fonction du type
      final type = map['type']?.toString(); 
      if (type == 'urgent') {
        return UrgentTask(
          id: id,
          title: title,
          reason: reason,
          isCompleted: isCompleted,
          dueDate: dueDate,
        );
      } else {
        return SimpleTask(
          id: id,
          title: title,
          priority: priority,
          isCompleted: isCompleted,
          dueDate: dueDate,
        );
      }
    }).toList();
  } catch (e) {
    _tasks = [];
  }
  }

  List<Task> getAllSortedByDate() {
    final sortedTasks = List<Task>.from(_tasks);
    sortedTasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sortedTasks;
  }

  List<Task> getAllSortedByPriority() {
    final sortedTasks = List<Task>.from(_tasks);
    sortedTasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    return sortedTasks;
  }

}
