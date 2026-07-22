import 'dart:io';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/urgent_task.dart';
import 'package:todolist/repository/json_task_repo.dart';
import 'package:todolist/exceptions/task_exception.dart';

void main() {
  // On instancie le repository avec le fichier JSON principal
  final repo = JsonTaskRepo('tasks.json');
  bool isRunning = true;

  print('====================================');
  print('    📋 GESTIONNAIRE DE TÂCHES CLI    ');
  print('====================================\n');

  while (isRunning) {
    print('\n--- MENU PRINCIPAL ---');
    print('1. Lister les tâches');
    print('2. Ajouter une tâche urgente');
    print('3. Changer le statut d\'une tâche');
    print('4. Supprimer une tâche');
    print('5. Quitter');
    stdout.write('Faites votre choix (1-5) : ');

    final input = stdin.readLineSync();

    switch (input) {
      case '1':
        print('\n--- LISTE DES TÂCHES ---');
        final tasks = repo.getAll();
        if (tasks.isEmpty) {
          print('Aucune tâche enregistrée.');
        } else {
          for (var task in tasks) {
            final status = task.isCompleted ? '[X]' : '[ ]';
            print('$status ID: ${task.id} | ${task.title}');
          }
        }
        break;

      case '2':
        print('\n--- AJOUT D\'UNE TÂCHE URGENTE ---');
        stdout.write('ID (nombre entier) : ');
        final idStr = stdin.readLineSync();
        final id = int.tryParse(idStr ?? '') ?? DateTime.now().millisecondsSinceEpoch;

        stdout.write('Titre de la tâche : ');
        final title = stdin.readLineSync() ?? 'Sans titre';

        stdout.write('Raison de l\'urgence : ');
        final reason = stdin.readLineSync() ?? 'Urgence non précisée';

        final newTask = UrgentTask(
          id: id,
          title: title,
          reason: reason,
          priority: Priority.high
        );

        repo.add(newTask);
        print('✅ Tâche urgente ajoutée avec succès !');
        break;

      case '3':
        stdout.write('Entrez l\'ID de la tâche à modifier : ');
        final idToToggle = int.tryParse(stdin.readLineSync() ?? '');
        if (idToToggle != null) {
          try {
            final tasks = repo.getAll();
            final task = tasks.firstWhere((t) => t.id == idToToggle);
            task.toggleCompleted();
            repo.update(task);
            print('✅ Statut de la tâche mis à jour !');
          } catch (e) {
            print('🚨 Tâche introuvable.');
          }
        }
        break;

      case '4':
        stdout.write('Entrez l\'ID de la tâche à supprimer : ');
        final idToRemove = int.tryParse(stdin.readLineSync() ?? '');
        if (idToRemove != null) {
          try {
            repo.remove(idToRemove);
            print('🗑️ Tâche supprimée avec succès !');
          } on TaskNotFound catch (e) {
            print(e); // Affiche le message de notre exception personnalisée
          }
        }
        break;

      case '5':
        print('Au revoir ! 👋');
        isRunning = false;
        break;

      default:
        print('❌ Option invalide, veuillez réessayer.');
    }
  }
}