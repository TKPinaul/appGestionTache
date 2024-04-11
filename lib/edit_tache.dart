import 'package:flutter/material.dart';
import 'package:appgestiontache/class/gestionTache.dart';

class TacheEdit extends StatefulWidget {
  const TacheEdit({super.key, required this.tache});
  final Tache tache;

  @override
  _TacheEditState createState() => _TacheEditState();
}

class _TacheEditState extends State<TacheEdit> {
  late bool complet;

  @override
  void initState() {
    super.initState();
    complet = widget.tache.isComplete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tache.title.toUpperCase()),
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
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.tache.subTasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(widget.tache.subTasks[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _modifierSousTache(context, index);
                            },
                            icon: Icon(Icons.abc),
                          ),
                          IconButton(
                            onPressed: () {
                              _supprimerSousTache(context, index);
                            },
                            icon: Icon(Icons.delete),
                          ),
                          Checkbox(
                            value: widget.tache.sousTachefait[index],
                            onChanged: (newValue) {
                              setState(() {
                                widget.tache.sousTachefait[index] = newValue ?? false;
                                complet = widget.tache.sousTachefait.every((value) => value);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _ajouterSousTache(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800
                ),
                child: const Text(
                    "+ Ajouter",
                    style: TextStyle(color: Colors.white)
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // setState(() {
          //   widget.tache.isComplete = complet;
          // });
          // // Fermer l'écran d'édition et renvoyer la tache
          // Navigator.pop(context, widget.tache);
        },
        child: Icon(
          Icons.save,
          color: Colors.white),
        backgroundColor: Colors.indigo.shade700,
      ),
    );
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

  void _modifierSousTache(BuildContext context, int index) async {
    final TextEditingController _InfoController = TextEditingController(text: widget.tache.subTasks[index]);

    final nouvelleSousTache = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier une sous-tâche'),
          content: TextField(
            // Stockage de la saisie de l'utilisateur avec controller...
            controller: _InfoController,
            decoration: const InputDecoration(labelText: 'Nom de la sous-tâche'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _InfoController.text);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (nouvelleSousTache != null) {
      setState(() {
        widget.tache.subTasks[index] = nouvelleSousTache;
      });
    }
  }

  void _ajouterSousTache(BuildContext context) async {
    final TextEditingController _InfoController = TextEditingController();

    final nouvelleSousTache = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une sous-tâche'),
          content: TextField(
            // Stockage de la saisie de l'utilisateur avec controller...
            controller: _InfoController,
            decoration: const InputDecoration(labelText: 'Nouvelle sous-tâche'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (_InfoController.text.isEmpty) {
                  _showValidationError("Veuillez renseigner une sous-tâche valide.");
                } else if (widget.tache.subTasks.contains(_InfoController.text)) {
                  _showValidationError("Cette sous-tâche existe déjà.");
                } else {
                  Navigator.pop(context, _InfoController.text);
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );

    if (_InfoController.text.isEmpty) {
      _showValidationError(
          "Veuillez renseigner une sous tache valide a effectuer.");
    } else {
      if (nouvelleSousTache != null) {
        setState(() {
          widget.tache.subTasks.add(nouvelleSousTache);
          widget.tache.sousTachefait.add(false);
          complet = widget.tache.sousTachefait.every((value) => value);
        });
      }
    }
  }

  void _supprimerSousTache(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer une sous-tâche'),
          content: const Text('Voulez-vous vraiment supprimer cette sous-tâche ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.tache.subTasks.removeAt(index);
                  widget.tache.sousTachefait.removeAt(index);
                  complet = widget.tache.sousTachefait.every((value) => value);
                });
                Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}

