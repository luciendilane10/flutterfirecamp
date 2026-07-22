import 'dart:io';
import 'package:test/test.dart';

import 'package:todolist/exceptions/task_exception.dart';
import 'package:todolist/repository/json_task_repo.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/urgent_task.dart';

void main() {

  setUp(() {
    final file = File('test_tasks.json');
    if (file.existsSync()) {
      file.deleteSync();
    }
  });
  
  group("tests sur les taches", () {
    //1. Verification de la bascule de statut
    test('toogleComplete doit changer isComplete de false à true', () {
      final task = UrgentTask(
        id: 1,
        title: "Test 1",
        priority: Priority.high,
        reason: "Urgence",
      );

      expect(task.isCompleted, false);
      task.toggleCompleted();
      expect(task.isCompleted, true);
    });

    //2. Ajout d'une tache
    test("On ajoute à la liste", () {
      final task2 = UrgentTask(
          id: 2,
          title: "Verification",
          priority: Priority.high,
          reason: "Tache primordiale",
          date: DateTime.now()
          );
          
      task2.create();
      JsonTaskRepo("D:/Projets/Certification/dart/todolist/task.json")
          .add(task2);

      final task3 = UrgentTask(
          id: 3,
          title: "Production",
          priority: Priority.high,
          reason: "Urgence déclenchée",
          date: DateTime.now());
      task3.create();
      JsonTaskRepo("D:/Projets/Certification/dart/todolist/task.json")
          .add(task3);
    });

    //3. Affichage des tâches
    test("Affichage des tâches", () {
      JsonTaskRepo("D:/Projets/Certification/dart/todolist/task.json").getAll();
    });

    //4.Suppression d'une tâche existente
    test("Suppression d'une tâche existente", () {
      JsonTaskRepo("D:/Projets/Certification/dart/todolist/task.json")
          .remove(3);
    });

    //5. Déclenchement d'une erreur
    test("Déclenchement d'une erreur", (){
      final repo = JsonTaskRepo('test_tasks.json');

  // 💡 Note la syntaxe () => repo.remove('8')
  expect(
    () => repo.remove(8), 
    throwsA(isA<TaskNotFound>()),
  );
    });
  });
}
