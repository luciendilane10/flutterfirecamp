# 📋 Application de Gestion de Tâches CLI en Dart (ToDo List)

Une application en ligne de commande (CLI) développée en **Dart** permettant de gérer une liste de tâches avec persistance de données locale (format JSON). Ce projet met en pratique la programmation orientée objet avancée, la gestion des génériques, la persistance de données et les tests unitaires.

---

## 🎯 Objectifs & Fonctionnalités

* **Gestion des Tâches :** Création, affichage, modification du statut (terminée / non terminée) et suppression.
* **Typage & Héritage :** Support des tâches urgentes (`UrgentTask`) héritant d'une classe abstraite (`Task`).
* **Persistance locale :** Sauvegarde et chargement automatique de l'état dans un fichier local `tasks.json`.
* **Interface CLI :** Menu interactif en boucle pour manipuler facilement les tâches depuis le terminal.
* **Gestion Robuste des Erreurs :** Le levage d'exceptions personnalisées évite les plantages inattendus.
* **Tests Unitaires :** Suite complète de tests automatisés validant la logique métier et le dépôt de données.

---

## 🛠️ Architecture du Projet & Concepts Dart Appliqués

### 1. Programmation Orientée Objet (POO)
* **Classe Abstraite (`Task`) :** Définit le modèle de base avec des propriétés comme `id`, `title`, `isCompleted`, `priority` et `date`, ainsi que la méthode abstraite `toJson()`.
* **Héritage (`UrgentTask`) :** Étend `Task` en y ajoutant le motif d'urgence (`reason`) et en fixant automatiquement la priorité à `Priority.high`.

### 2. Interface & Génériques
* **Interface Abstraite (`Repository<T>`) :** Contrat générique définissant les opérations CRUD :
  * `void add(T item)`
  * `List<T> getAll()`
  * `void remove(int id)`
  * `void update(T item)`
* **Implémentation Concrète (`JsonTaskRepo`) :** Respecte le contrat `Repository<Task>` et gère les entrées/sorties avec le fichier `tasks.json` via les packages `dart:io` et `dart:convert`.

### 3. Exceptions Personnalisées
* **`TaskNotFoundException` :** Levée lorsque l'utilisateur tente d'interagir avec une tâche (suppression ou mise à jour) dont l'identifiant n'existe pas.

---

## 📂 Structure du Projet

```text
todolist/
├── bin/
│   └── main.dart                 # Point d'entrée de l'application (Interface CLI)
├── lib/
│   ├── exceptions/
│   │   └── task_exceptions.dart  # Définition des exceptions personnalisées
│   ├── models/
│   │   ├── task.dart             # Classe abstraite parent (Task)
│   │   └── urgent_task.dart      # Classe fille (UrgentTask)
│   └── repository/
│       ├── repository.dart       # Interface générique Repository<T>
│       └── json_task_repo.dart   # Implémentation de la persistance JSON
├── test/
│   └── task_test.dart            # Tests unitaires avec le package 'test'
├── pubspec.yaml                  # Configuration du projet et dépendances
└── README.md                     # Documentation du projet