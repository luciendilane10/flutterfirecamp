import 'dart:io';
import 'package:test/test.dart';

import 'package:todolist/models/task.dart';
import 'package:todolist/models/simple_task.dart';
import 'package:todolist/models/urgent_task.dart';
import 'package:todolist/repository/json_task_repo.dart';
import 'package:todolist/exceptions/task_exception.dart';

void main() {

  late JsonTaskRepo repo;
  final testFilePath = 'test_tasks.json';

  // Avant chaque test, on initialise un repository propre
  setUp(() {
    repo = JsonTaskRepo(testFilePath);
  });

  // Après chaque test, on supprime le fichier de test temporaire s'il existe
  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });
  
  group('Tests du Gestionnaire de Tâches', () {
    // 1. Création d'une tâche simple
    test('Création d\'une tâche simple', () {
      final simpleTask = SimpleTask(
          id: 1,
          title: 'Faire les courses',
          priority: Priority.medium,
          dueDate: DateTime.now().add(Duration(days: 2)));
      repo.add(simpleTask);
      simpleTask.create();
      expect(simpleTask.id, 1);
      expect(simpleTask.title, 'Faire les courses');
      expect(simpleTask.priority, Priority.medium);
      expect(simpleTask.isCompleted, false);

      
    });

    // 2. Création d'une tâche urgente
    test('Création d\'une tâche urgente', () {
      final urgentTask = UrgentTask(
          id: 2,
          title: 'Appeler le médecin',
          reason: 'Rendez-vous important',
          dueDate: DateTime.now().add(Duration(hours: 5)));
      repo.add(urgentTask);
      urgentTask.create();
      expect(urgentTask.id, 2);
      expect(urgentTask.title, 'Appeler le médecin');
      expect(urgentTask.reason, 'Rendez-vous important');
      expect(urgentTask.priority, Priority.high);
      expect(urgentTask.isCompleted, false);
    });

    //3.Test de la récupération de toutes les tâches
    test('Récupération de toutes les tâches', () {
      final simpleTask = SimpleTask(
          id: 1,
          title: 'Faire les courses',
          priority: Priority.medium,
          dueDate: DateTime.now().add(Duration(days: 2)));
      final urgentTask = UrgentTask(
          id: 2,
          title: 'Appeler le médecin',
          reason: 'Rendez-vous important',
          dueDate: DateTime.now().add(Duration(hours: 5)));
      repo.add(simpleTask);
      repo.add(urgentTask);

      final allTasks = repo.getAll();
      expect(allTasks.length, 2);
    });

    //4.Test de la récupération des tâches triées par date
    test('Récupération des tâches triées par date', () {  
      final simpleTask = SimpleTask(
          id: 1,
          title: 'Faire les courses',
          priority: Priority.medium,
          dueDate: DateTime.now().add(Duration(days: 2)));
      final urgentTask = UrgentTask(
          id: 2,
          title: 'Appeler le médecin',
          reason: 'Rendez-vous important',
          dueDate: DateTime.now().add(Duration(hours: 5)));
      repo.add(simpleTask);
      repo.add(urgentTask);

      final sortedTasks = repo.getAllSortedByDate();
      expect(sortedTasks.first, urgentTask);
      expect(sortedTasks.last, simpleTask);
    });

    //5.Test de la récupération des tâches triées par priorité
    test('Récupération des tâches triées par priorité', () {
      final simpleTask = SimpleTask(
          id: 1,
          title: 'Faire les courses',
          priority: Priority.medium,
          dueDate: DateTime.now().add(Duration(days: 2)));
      final urgentTask = UrgentTask(
          id: 2,
          title: 'Appeler le médecin',
          reason: 'Rendez-vous important',
          dueDate: DateTime.now().add(Duration(hours: 5)));
      repo.add(simpleTask);
      repo.add(urgentTask);

      final sortedTasks = repo.getAllSortedByPriority();
      expect(sortedTasks.first, urgentTask);
      expect(sortedTasks.last, simpleTask);
    });
  });
}
