# Gestionnaire de Tâches CLI en Dart

Application en ligne de commande (CLI) permettant de gérer des tâches simples et urgentes avec persistance des données au format JSON.

## Fonctionnalités

- **Gestion des tâches** : Ajout, affichage, modification du statut et suppression.
- **Polymorphisme** : Support des `SimpleTask` et `UrgentTask`.
- **Tris avancés** : Tri par priorité et par date d'échéance.
- **Persistance** : Sauvegarde et chargement automatique dans un fichier JSON via `JsonTaskRepo`.
- **Gestion des erreurs** : Exceptions personnalisées (`TaskException`, `TaskNotFoundException`, `InvalidTaskException`).

## Structure du Projet

```text
lib/
  ├── exceptions/      # Exceptions personnalisées
  ├── models/          # Task, SimpleTask, UrgentTask
  └── repository/      # Repository interface & JsonTaskRepo
bin/
  └── main.dart        # Point d'entrée de la CLI
test/
  └── task_test.dart   # Tests unitaires