import 'package:flutter/material.dart';
import 'package:poem_challenger/app_ui/ui_colors.dart';
import 'package:poem_challenger/app_ui/ui_reset_words.dart';
import 'package:poem_challenger/data/database.dart';
import 'package:poem_challenger/util/word_item.dart';
import 'package:poem_challenger/util/word_tile.dart';

class WordsTab extends StatefulWidget {
  const WordsTab({super.key});

  @override
  State<WordsTab> createState() => _WordsTabState();
}

class _WordsTabState extends State<WordsTab> {

  PoemDatabase db = PoemDatabase();

  @override
  void initState() {
    super.initState();
    db.init().then((_) {
      setState(() {});
    });
  }

  void switchTabWrite() {
    savePoem((ModalRoute.of(context)?.settings.arguments) as String);

    Navigator.pushNamed(
      context,
      '/writingtab',
      // on donne l'argument reçu
      arguments: (ModalRoute.of(context)?.settings.arguments) as String
    );
  }

  Future<void> addWord(String poemId) async {
    final List<WordItem> wordList = db.getPoem(poemId)!.challengeWords;

    bool add = true;

    if (wordList.isNotEmpty) {
      for (int i = 0 ; i < wordList.length ; i++) {
        if (wordList[i].word == "") {
          add = false;
          break;
        }
      }
    }

    if (!add) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Entrez le dernier mot avant d'en rajouter.",
          textAlign: TextAlign.center,
          )
        )
      );
      return;
    }
    setState(() {
      wordList.add(WordItem(word: "", colorValue: Colors.accents[0].toARGB32()));
    });

    await db.getPoem(poemId)!.save();
  }

  void openResetUI(String poemId) {
    final List<WordItem> wordList = db.getPoem(poemId)!.challengeWords;

    showDialog(
      context: context,
      builder: (context) {
        return ResetWordsUI(
          message: "Réinitialiser la liste ?",
          onReset: () async {
            setState(() {
              wordList.removeRange(0, wordList.length);
            });
            await db.getPoem(poemId)!.save();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      }
    );
  }

  Future<void> deleteWord(int index, String poemId) async {
    setState(() {
      db.getPoem(poemId)!.challengeWords.removeAt(index);
    });
    await db.getPoem(poemId)!.save();
}

  void openColorUI(int index, String poemId) {
    final List<WordItem> wordList = db.getPoem(poemId)!.challengeWords;

    showDialog(
      context: context,
      builder: (context) {
        return ColorsUI(
          onSelectColor: (color) async {
            setState(() {
              wordList[index].colorValue = color.toARGB32();
            });
            await db.getPoem(poemId)!.save();
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      }
    );
  }

  Future<void> updateList(int index, String text, String poemId) async {
    /* pas de setState car il re-build en
    même temps et rale dans la console */
    db.getPoem(poemId)!.challengeWords[index].word = text;
    await db.getPoem(poemId)!.save();
  }

  Future<void> savePoem(String poemId) async {
    await db.getPoem(poemId)!.save();
  }

  @override
  Widget build(BuildContext context) {
    final poemId = (ModalRoute.of(context)?.settings.arguments) as String;
    final List<WordItem> wordList = db.getPoem(poemId)!.challengeWords;

    return Scaffold(

      appBar: AppBar(
        title: Text("Mots",),
        automaticallyImplyLeading: false,

        actions: [
          IconButton(
            onPressed: () {
              if (wordList.isNotEmpty) openResetUI(poemId);
            },
            icon: Icon(Icons.delete_forever_rounded),
            tooltip: "Effacer la liste de mots",
            color:Color(0xFFA82A2A)
          ),

          IconButton(
            onPressed: () {
              savePoem(poemId);

              Navigator.pushNamed(context, '/homemenu');
            },
            icon: Icon(Icons.logout),
            tooltip: "Revenir au menu principal",
            color:Color(0xFFF5F5F5)
          ),
        ],
      ),

      floatingActionButton:
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8.0,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () => addWord(poemId),
              backgroundColor: Color(0x97D49331),
              heroTag: null,
              child: Icon(Icons.add, color: Color(0xFF000000)),
            ),
            FloatingActionButton(
              onPressed: switchTabWrite,
              backgroundColor: Color(0x65C0C0C0),
              heroTag: null,
              child: Icon(Icons.keyboard_double_arrow_left_sharp, color: Color(0xFF000000)),
            ),
          ],
        ),

      body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          Column(
            spacing: 1.0,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom:6.0),
                child: SizedBox(
                  height: 30,
                  child: Text(
                    "Note : les caractères spéciaux ne sont pas détectés.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: wordList.length + 1,
                  itemBuilder: (context, index) {
                    return (index < wordList.length)
                    ?
                    WordTile(
                      key: ValueKey(wordList[index].id),
                      word: wordList[index].word,
                      color: Color(wordList[index].colorValue),
                      deleteWord: () => deleteWord(index, poemId),
                      changeColor: () => openColorUI(index, poemId),
                      updateText: (text) => updateList(index, text, poemId),
                    )
                    :
                    SizedBox(
                      height: 150,
                      child: null
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
