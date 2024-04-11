import 'package:appgestiontache/class/gestionTache.dart';
import 'package:appgestiontache/add_tache.dart';
import 'package:appgestiontache/detail_tache.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_tache.dart';

class MyTacheList extends StatelessWidget {
  const MyTacheList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListTache(),
    );
  }
}

class ListTache extends StatefulWidget {
  const ListTache({super.key});

  @override
  State<StatefulWidget> createState() => _ListTacheState();
}

class _ListTacheState extends State<ListTache> {
  List<Tache> taches = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ma Liste de tâches"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: taches.length,
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                return buildTacheItem(taches[index]);
              },
            ),
          ),
          // const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: _navigateToTacheAdd,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: const Text(
                  "Ajouter Tâche",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.indigo.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTacheItem(Tache tache) {
    // cotrole du delais d'execution de la tache
    DateTime dateEcheance = DateTime.parse(tache.dateEcheant);
    bool dateDepasse = DateTime.now().isAfter(dateEcheance);
    Color cardColor = dateDepasse ? Colors.orangeAccent.shade400 : Colors.blue.shade800;

    // Vérifier si la tâche est complétée
    if (tache.isComplete) {
      cardColor = Colors.greenAccent.shade400;
    }

    return Dismissible(
      key: Key(tache.title), // Clé unique pour chaque élément
      direction: DismissDirection.startToEnd, // Sens du glissement
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 15.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (direction) async {
        // Boîte de dialogue de confirmation
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirmer la suppression"),
              content: Text("Voulez-vous vraiment supprimer cette tâche ?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Annuler"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text("Supprimer"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Supprimer la tâche de la liste
        setState(() {
          taches.remove(tache);
        });
        // Afficher une notification de suppression
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Tâche supprimée"),
            action: SnackBarAction(
              label: "Annuler",
              onPressed: () {
                // Annuler la suppression en réinsérant la tâche dans la liste
                setState(() {
                  taches.insert(taches.indexOf(tache), tache);
                });
              },
            ),
          ),
        );
      },
      child: Card(
        color: cardColor,
        margin: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(
            tache.title,
            style: GoogleFonts.b612(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Date d\'échéance: ${tache.dateEcheant}',
            style: GoogleFonts.b612(
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              _navigateToTacheedit(tache);
            },
          ),
          onTap: () {
            _navigateToTacheDetail(tache);
          },
        ),
      ),
    );
  }


  Future<void> _navigateToTacheAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TacheAdd()),
    );

    if (result != null) {
      setState(() {
        taches.add(result);
      });
    }
  }

  void _navigateToTacheedit(Tache tache) async {
    final Tache? result_update = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TacheEdit(tache: tache)),
    );

    if (result_update != null) {
      setState(() {
        final index = taches.indexWhere((element) => element.title == result_update.title);
        if (index != -1) {
          taches[index] = result_update;
        }
      });
    }
  }

  void _navigateToTacheDetail(Tache tache) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailTache(tache: tache)),
    );
  }
}
