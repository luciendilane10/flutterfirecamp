import 'dart:io';
import 'package:todolist/models/task.dart';
import 'package:todolist/models/simple_task.dart';
import 'package:todolist/models/urgent_task.dart';
import 'package:todolist/repository/json_task_repo.dart';
import 'package:todolist/exceptions/task_exception.dart';

void main() {
  final repo = JsonTaskRepo('tasks.json');
  bool isRunning = true;

  print('=== GESTIONNAIRE DE TÂCHES CLI ===');

  while (isRunning) {
    print('\nMENU :');
    print('1. Lister les tâches');
    print('2. Ajouter une tâche');
    print('3. Marquer une tâche comme terminée');
    print('4. Supprimer une tâche');
    print('5. Quitter');
    stdout.write('Votre choix : ');

    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        _handleListTasks(repo);
        break;
      case '2':
        _handleAddTask(repo);
        break;
      case '3':
        _handleCompleteTask(repo);
        break;
      case '4':
        _handleDeleteTask(repo);
        break;
      case '5':
        isRunning = false;
        print('Au revoir !');
        break;
      default:
        print('Choix invalide, veuillez réessayer.');
    }
  }
}

void _handleListTasks(JsonTaskRepo repo) {
  final allTasks = repo.getAll();

  // 1. Vérification dès le départ
  if (allTasks.isEmpty) {
    print('\nAucune tâche enregistrée.');
    return;
  }

  print('\nComment voulez-vous afficher les tâches ?');
  print('1. Par priorité');
  print('2. Par date d\'échéance');
  print('3. Par ordre d\'ajout (défaut)');
  stdout.write('Votre choix : ');

  // 2. Sélection de la liste
  final List<Task> tasksToShow;
  switch (stdin.readLineSync()?.trim()) {
    case '1':
      tasksToShow = repo.getAllSortedByPriority();
      break;
    case '2':
      tasksToShow = repo.getAllSortedByDate();
      break;
    default:
      tasksToShow = allTasks;
  }

  print('\n=== LISTE DES TÂCHES ===');

  // 3. Boucle d'affichage unique
  for (var task in tasksToShow) {
    final status = task.isCompleted ? '[X]' : '[ ]';
    final dateStr = task.dueDate != null 
        ? task.dueDate.toString().split(' ')[0] 
        : 'Pas de date';

    if (task is UrgentTask) {
      print('$status #${task.id} - ${task.title} [URGENT: ${task.reason}] | Priorité: HIGH | Échéance: $dateStr');
    } else {
      print('$status #${task.id} - ${task.title} | Priorité: ${task.priority.name.toUpperCase()} | Échéance: $dateStr');
    }
  }
}

void _handleAddTask(JsonTaskRepo repo) {

  final allTasks = repo.getAll();

final int nextId;
if (allTasks.isEmpty) {
  nextId = 1; // Si la liste est vide, on commence à 1
} else {
  // On cherche l'ID le plus élevé et on ajoute 1
  final maxId = allTasks.map((t) => t.id).reduce((a, b) => a > b ? a : b);
  nextId = maxId + 1;
}
  stdout.write('Titre de la tâche : ');
  final title = stdin.readLineSync()?.trim() ?? '';

  stdout.write('Type de tâche (simple/urgent) : ');
  final type = stdin.readLineSync()?.trim().toLowerCase() ?? '';

  DateTime? dueDate;
  stdout.write('Date d\'échéance (YYYY-MM-DD) ou laisser vide : ');
  final dueDateInput = stdin.readLineSync()?.trim();
  if (dueDateInput != null && dueDateInput.isNotEmpty) {
    try {
      dueDate = DateTime.parse(dueDateInput);
    } catch (e) {
      print('Format de date invalide. La date d\'échéance sera ignorée.');
    }
  }

  Task newTask;
  if (type == 'urgent') {
    stdout.write('Raison de l\'urgence : ');
    final reason = stdin.readLineSync()?.trim() ?? '';
    newTask = UrgentTask(
      id: nextId,
      title: title,
      reason: reason,
      dueDate: dueDate,
    );
  } else {
      stdout.write('Priorité (low/medium/high) : ');
    final priorityInput = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    final priority = Priority.values.firstWhere(
      (p) => p.name == priorityInput,
      orElse: () => Priority.low);
    newTask = SimpleTask(
      id: nextId,
      title: title,
      priority: priority,
      dueDate: dueDate,
    );
  }

  repo.add(newTask);
  newTask.create();
}

void _handleCompleteTask(JsonTaskRepo repo) {
  stdout.write('Entrez l\'ID de la tâche à marquer comme terminée/incomplète : ');
  final input = stdin.readLineSync()?.trim();
  final id = int.tryParse(input ?? '');

  if (id == null) {
    print('ID invalide.');
    return;
  }

  try {
    final tasks = repo.getAll();
    final task = tasks.firstWhere((t) => t.id == id);
    task.toggleCompleted();
    repo.update(task);
    
    final statusStr = task.isCompleted ? 'terminée' : 'en cours';
    print('La tâche #${task.id} est maintenant $statusStr !');
  } catch (e) {
    print('Erreur : Aucune tâche trouvée avec l\'ID $id.');
  }
}

void _handleDeleteTask(JsonTaskRepo repo) {
  stdout.write('Entrez l\'ID de la tâche à supprimer : ');
  final input = stdin.readLineSync()?.trim();
  final id = int.tryParse(input ?? '');

  if (id == null) {
    print('ID invalide.');
    return;
  }

  try {
    repo.delete(id);
    print('Tâche #$id supprimée avec succès !');
  } on TaskNotFound catch (e) {
    print('Erreur : ${e.message}');
  } catch (e) {
    print('Erreur lors de la suppression de la tâche #$id.');
  }
}