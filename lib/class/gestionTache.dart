
class GestionTache {
  static const String title = 'title';
  static const String dateEcheant = 'dateEcheant';
  static const String autreInfo = 'additionalInfo';
  static const String isComplete = 'isComplete';
  static const String sousTachefait = 'sousTachefait';
  static const String subTasks = 'subTasks';  // Clé pour accéder aux sous-tâches
}

class Tache {
  String title;
  String dateEcheant;
  String autreInfo;
  bool isComplete;
  List<bool> sousTachefait;
  List<String> subTasks;  // Liste de sous-tâches associées à la tâche principale

  Tache({
    required this.title,
    required this.dateEcheant,
    required this.autreInfo,
    required this.isComplete,
    required this.sousTachefait,
    required this.subTasks,
  });
}
