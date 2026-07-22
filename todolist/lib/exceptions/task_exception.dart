class TaskException implements Exception {
  final String message;
  TaskException(this.message);

  @override
  String toString() => "Erreur: $message";
}

//1. Tache introuvable
class TaskNotFound extends TaskException {
  TaskNotFound( int id) : super("Tâche $id introuvable");
}
//2. Donnee invalide

class InvalidTask extends TaskException {
  InvalidTask(String message) : super(message);
}
