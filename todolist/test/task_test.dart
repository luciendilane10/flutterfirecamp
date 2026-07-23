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

  setUp(() {
    repo = JsonTaskRepo(testFilePath);
  });

  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  group('Suite de tests unitaires - Gestionnaire de Tâches', () {
    test('1. Instanciation correcte de SimpleTask et UrgentTask', () {
      final simple = SimpleTask(
        id: 1,
        title: 'Tâche simple',
        priority: Priority.low,
      );
      final urgent = UrgentTask(
        id: 2,
        title: 'Tâche urgente',
        reason: 'Urgence médicale',
      );

      expect(simple.isCompleted, false);
      expect(simple.priority, Priority.low);
      expect(urgent.priority, Priority.high);
      expect(urgent.reason, 'Urgence médicale');
    });

    test('2. Ajout et persistance dans JsonTaskRepo', () {
      final task = SimpleTask(
        id: 1,
        title: 'Acheter du pain',
        priority: Priority.medium,
      );

      repo.add(task);
      final loadedTasks = repo.getAll();

      expect(loadedTasks.length, 1);
      expect(loadedTasks.first.title, 'Acheter du pain');
    });

    test('3. Tri des tâches par priorité (High -> Medium -> Low)', () {
      final t1 = SimpleTask(id: 1, title: 'Basse', priority: Priority.low);
      final t2 = UrgentTask(id: 2, title: 'Haute', reason: 'Urgente');
      final t3 = SimpleTask(id: 3, title: 'Moyenne', priority: Priority.medium);

      repo.add(t1);
      repo.add(t2);
      repo.add(t3);

      final sorted = repo.getAllSortedByPriority();

      expect(sorted[0].priority, Priority.high);
      expect(sorted[1].priority, Priority.medium);
      expect(sorted[2].priority, Priority.low);
    });

    test('4. Modification du statut et mise à jour', () {
      final task = SimpleTask(id: 1, title: 'Test Update', priority: Priority.medium);
      repo.add(task);

      task.toggleCompleted();
      repo.update(task);

      final updatedTask = repo.getAll().firstWhere((t) => t.id == 1);
      expect(updatedTask.isCompleted, true);
    });

    test('5. Suppression d\'une tâche et gestion d\'exception', () {
      final task = SimpleTask(id: 1, title: 'A supprimer', priority: Priority.low);
      repo.add(task);

      repo.delete(1);
      expect(repo.getAll().length, 0);

      expect(() => repo.delete(999), throwsA(isA<TaskNotFound>()));
    });
  });
}