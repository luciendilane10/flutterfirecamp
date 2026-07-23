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
  void delete(int id) {
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
  if (!file.existsSync()) {
    _tasks = [];
    return;
  }

  try {
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) {
      _tasks = [];
      return;
    }

    final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
    _tasks = jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      // On vérifie la présence de 'reason' pour différencier UrgentTask de SimpleTask
      if (map.containsKey('reason') && map['reason'] != null) {
        return UrgentTask.fromJson(map);
      } else {
        return SimpleTask.fromJson(map);
      }
    }).toList();
  } catch (e) {
    // Si le fichier est corrompu, on réinitialise proprement sans faire planter l'app
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
