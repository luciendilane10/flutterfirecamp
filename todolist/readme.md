# Gestionnaire de Tâches CLI - Dart

Projet de gestion de tâches en ligne de commande développé en Dart.

## Fonctionnalités
- Gestion des tâches simples et urgentes (`SimpleTask`, `UrgentTask`).
- Sauvegarde et chargement automatique via persistance JSON (`JsonTaskRepo`).
- Tri des tâches par priorité et par date d'échéance.
- Gestion robuste des erreurs via des exceptions personnalisées.

## Lancement de l'application
```bash
dart run bin/main.dart