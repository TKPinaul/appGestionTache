import 'package:appgestiontache/class/gestionTache.dart';
import 'package:flutter/material.dart';
import 'section/bouton_valider.dart';

class TacheAdd extends StatefulWidget {
  const TacheAdd({super.key});

  @override
  _TacheAddState createState() => _TacheAddState();
}

class _TacheAddState extends State<TacheAdd> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _autreInfoController = TextEditingController();
  final List<String> _sousTaches = [];
  final List<bool> _sousTachefait = [];
  bool _isComplete = false;
  DateTime _selectedDate = DateTime.now();
  late final Tache tache;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une tâche"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titreController,
                decoration:
                const InputDecoration(labelText: 'Titre de la tâche'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _autreInfoController,
                      decoration: const InputDecoration(
                        labelText: 'lister les sous tache a accomplir',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _addSousTache(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade600
                    ),
                    child: const Text("Ajouter une sous Tâche",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < _sousTaches.length; i++)
                CheckboxListTile(
                  title: Text(_sousTaches[i]),
                  value: _sousTachefait[i],
                  onChanged: (bool? value) {
                    setState(() {
                      _sousTachefait[i] = value ?? false;
                      _updateIsComplete();
                    });
                  },
                ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date d\'échéance',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_selectedDate.toLocal()}".split(' ')[0],
                      ),
                      const Icon(Icons.calendar_month_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BoutonValider(
                onPresseValidate: _validationAjout,
                texteValidate: "Valider",
                colorDeFont: Colors.indigo.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _validationAjout() {
    if (_titreController.text.isEmpty) {
      _showValidationError("Le titre est obligatoire.");
    } else if (_sousTaches.isEmpty) {
      _showValidationError("Au moins une sous-tâche doit être saisie.");
    } else if (_selectedDate.isBefore(DateTime.now())) {
      _showValidationError(
          "La date d'échéance doit être supérieure à la date d'aujourd'hui.");
    } else {
      // Valider les champs et enregistrer la tâche
      _saveTache();
    }
  }

  void _showValidationError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Erreur de validation"),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"))
            ],
          );
        });
  }

  void _addSousTache() {
    if (_autreInfoController.text.isEmpty) {
      _showValidationError(
          "Veuillez renseigner une sous tache valide a effectuer.");
    } else {
      if (_sousTaches.contains(_autreInfoController.text)) {
        _showValidationError(
            "Cette sous-tâche existe déjà.");
      } else {
        setState(() {
          _sousTaches.add(_autreInfoController.text);
          _sousTachefait.add(false);
          _updateIsComplete();
        });
      }
    }
    // Réinitialisation du TextField
    _autreInfoController.clear();
  }

  void _updateIsComplete() {
    setState(() {
      _isComplete = _sousTachefait.every((value) => value);
    });
    // Supprimer les sous-tâches cochées
    for (int i = _sousTaches.length - 1; i >= 0; i--) {
      if (_sousTachefait[i]) {
        _sousTaches.removeAt(i);
        _sousTachefait.removeAt(i);
      }
    }
    // Mise à jour de l'état
    setState(() {});
  }

  void _saveTache() {
    Tache task = Tache(
      title: _titreController.text,
      dateEcheant: _selectedDate.toLocal().toString().split(' ')[0],
      autreInfo: _autreInfoController.text,
      isComplete: _isComplete,
      sousTachefait: List.from(_sousTachefait),
      subTasks: List.from(_sousTaches),
    );

    // Retournez les données à la page précédente
    Navigator.pop(context, task);
  }
}
