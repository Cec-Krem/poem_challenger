import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poem_challenger/app_ui/ui_delete.dart';
import 'package:poem_challenger/app_ui/ui_reset_words.dart';
import 'package:poem_challenger/data/database.dart';
import 'package:poem_challenger/util/timed_poem_tile.dart';
import 'package:poem_challenger/util/untimed_poem_tile.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  PoemDatabase db = PoemDatabase();

 @override
  void initState() {
    super.initState();
    db.init().then((_) {
      setState(() {});
    });

    if (db.poemBox.isEmpty) {
      db.createNewData();
    }
  }

  // Création d'un poème : ajout de données pour le nouveau poème -> changement de page vers ce dernier
  void createNewPoem() {
    setState(() {
      db.createNewData();
    });

    // On donne l'ID du poème en argument pour pouvoir communiquer avec la base de données
    // une fois en train d'écrire le poème
    Navigator.pushNamed(
      context,
      '/writingtab',
      arguments: db.getLastId()
    );
  }

  void openDeleteUI(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteUI(
          poemName: db.poemBox.get(id)!.title,
          onDelete: () {
            setState(() {
              db.deletePoem(id);
              Navigator.of(context).pop();
            });
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      }
    );
  }

  void openResetUI(Type poemType) {
    showDialog(
      context: context,
      builder: (context) {
        return ResetWordsUI(
          message: "Supprimer cette liste ?",
          onReset: () {
            setState(() {
              if (poemType == TimedPoemTile) {
                final keysToDelete = db.poemBox.values
                  .where((poem) => poem.timer != null && poem.timer != 0)
                  .map((poem) => poem.key)
                  .toList();

                db.poemBox.deleteAll(keysToDelete);
              }
              if (poemType == UntimedPoemTile) {
                final keysToDelete = db.poemBox.values
                  .where((poem) => poem.timer == null || poem.timer == 0)
                  .map((poem) => poem.key)
                  .toList();

                db.poemBox.deleteAll(keysToDelete);
              }

              Navigator.of(context).pop();
            });
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      }
    );
  }

  int poemNumberType(Type nature) {
    int count = 0;
      for (var id in db.poemBox.keys) {
        // on get le timer dans chaque cas et incrémente en fonction de ce qu'on veut
        if ((nature == UntimedPoemTile) && (db.poemBox.get(id)!.timer == 0 || db.poemBox.get(id)!.timer == null)) {
          count++;
        }
        else if ((nature == TimedPoemTile) && (db.poemBox.get(id)!.timer != 0 && db.poemBox.get(id)!.timer != null)) {
          count++;
        }
      }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final poems = db.poemBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    
    final timedPoems = poems.where((p) => p.isTimed).toList();
    final untimedPoems = poems.where((p) => p.isUntimed).toList();

    return Scaffold(

      appBar: AppBar(
        title: Text("Poem Challenger",),
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
            onPressed: () {
              SystemNavigator.pop(animated: true);
            },
            icon: Icon(Icons.logout),
            tooltip: "Quitter l'application",
            color:Color(0xFFA82A2A)
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: createNewPoem,
        backgroundColor: Color(0x97D49331),
        child: Icon(Icons.add, color: Color(0xFF000000)),
      ),

      body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Avec chrono"),
                    IconButton(
                      onPressed: () {
                        if (poemNumberType(TimedPoemTile) != 0) openResetUI(TimedPoemTile);
                      },
                      icon: Icon(Icons.delete_forever_rounded),
                      tooltip: "Effacer la liste des poèmes chronométrés",
                      color:Color(0xFFA82A2A)
                    ),
                  ],
                ),
              ),

              // Poèmes avec chrono
              Expanded(
                child:
                ListView.builder(
                  itemCount: timedPoems.length,
                  itemBuilder: (context, index) {
                    final poemToPut = timedPoems[index];

                    return TimedPoemTile(
                      id: poemToPut.id,
                      poemName: poemToPut.title,
                      date: poemToPut.date,
                      time: poemToPut.timer,
                      wordCount: poemToPut.wordCount,
                      challengeWords: poemToPut.challengeWordCount,
                      deleteFunction: () => openDeleteUI(poemToPut.id),
                      selectFunction: () => 
                        Navigator.pushNamed(
                          context,
                          '/writingtab',
                          arguments: poemToPut.id
                        ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sans chrono"),
                    IconButton(
                      onPressed: () {
                        if (poemNumberType(UntimedPoemTile) != 0) openResetUI(UntimedPoemTile);
                      },
                      icon: Icon(Icons.delete_forever_rounded),
                      tooltip: "Effacer la liste des poèmes non chronométrés",
                      color:Color(0xFFA82A2A)
                    ),
                  ],
                ),
              ),

              // Poèmes sans chrono
              Expanded(
                child:
                ListView.builder(
                  itemCount: untimedPoems.length + 1, // + 1 pour pas encombrer le bas (voir return ci-dessous)
                  itemBuilder: (context, index) {
                    if (index >= untimedPoems.length) {
                      return const SizedBox(height: 75);
                    }
                    final poemToPut = untimedPoems[index];

                    return UntimedPoemTile(
                      id: poemToPut.id,
                      poemName: poemToPut.title,
                      date: poemToPut.date,
                      wordCount: poemToPut.wordCount,
                      challengeWords: poemToPut.challengeWordCount,
                      deleteFunction: () => openDeleteUI(poemToPut.id),
                      selectFunction: () => 
                        Navigator.pushNamed(
                          context,
                          '/writingtab',
                          arguments: poemToPut.id
                        ),
                    );
                  },
                ),
              ),

            ],
          ),
        )
      );
  }
}
