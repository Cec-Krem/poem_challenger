import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poem_challenger/data/database.dart';
import 'package:poem_challenger/data/poem_data.dart';
import 'package:poem_challenger/util/stylable_text_field_controller.dart';
import 'package:poem_challenger/util/text_part_style_definition.dart';
import 'package:poem_challenger/util/text_part_style_definitions.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WritingTab extends StatefulWidget {

  const WritingTab({super.key});

  @override
  State<WritingTab> createState() => _WritingTabState();
}

class _WritingTabState extends State<WritingTab> {

  PoemDatabase db = PoemDatabase();

  late StyleableTextFieldController _controller;
  late String poemId;

  final RegExp exp = RegExp(r"[A-Za-zÀ-ÖØ-öø-ÿ]+", unicode: true);
  
  @override
  void initState() {
    super.initState();
    db.init().then((_) {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    poemId = ModalRoute.of(context)!.settings.arguments as String;

    final poem = db.getPoem(poemId)!;

    // On transforme les mots en Set, et minuscule
    challengeSet = poem.challengeWords
      .map((e) => e.word.toLowerCase())
      .toSet();

    _controller = StyleableTextFieldController(
      styles: TextPartStyleDefinitions(
        definitionList: List<TextPartStyleDefinition>.generate(
          poem.challengeWords.length,
          (index) {
            return TextPartStyleDefinition(
              style: TextStyle(
                color: Color(poem.challengeWords[index].colorValue),
              ),
              pattern: "(\\s|^|[.,!?;:'()*-])(${poem.challengeWords[index].word})(?=\\s|\$|[.,!?;:'()*-])"
            );
          },
        ),
      ),
    );

    _controller.text = poem.content;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _debounceWordsStats?.cancel();

    final poemId = (ModalRoute.of(context)?.settings.arguments) as String;
    final poem = db.getPoem(poemId);
    poem?.save();

    _controller.dispose();

    super.dispose();
  }

  Set? challengeSet;
  Timer? _debounce;
  Timer? _debounceWordsStats;
  bool runningChrono = false;
  late DateTime startTime;

  void switchTabWords() {
    if (runningChrono) {
      toggleChrono();
    }

    Navigator.pushNamed(
      context,
      '/wordstab',
      // on donne l'argument reçu
      arguments: (ModalRoute.of(context)?.settings.arguments) as String
    ).then((_) {
      _rebuildController();
    });
  }

  void _rebuildController() {
    final poemId = (ModalRoute.of(context)?.settings.arguments) as String;
    final poem = db.getPoem(poemId)!;

    // On transforme les mots en Set, et minuscule
    challengeSet = poem.challengeWords
      .map((e) => e.word.toLowerCase())
      .toSet();

    final newController = StyleableTextFieldController(
      styles: TextPartStyleDefinitions(
        definitionList:
        List<TextPartStyleDefinition>.generate(poem.challengeWords.length, (index) {
            return TextPartStyleDefinition(
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(poem.challengeWords[index].colorValue)
              ),
              pattern: "(\\s|^|[.,!?;:'()*-])(${poem.challengeWords[index].word})(?=\\s|\$|[.,!?;:'()*-])"
            );
          }, growable: true)
      ),
    );

    newController.text = _controller.text;

    _controller.dispose();

    setState(() {
      _controller = newController;
    });
  }

  void toggleChrono() {
    setState(() {
      runningChrono = !runningChrono;
      final poem = db.getPoem(poemId)!;

      if (runningChrono) {
        if (poem.timer != 0 && poem.timer != null) {
          // Ne pas reset, mais reprendre depuis là où on en était :
          // pour cela, on prend le temps actuel, et soustrait le temps déjà
          // écoulé pour avoir une plus grande différence par la suite.
          startTime = DateTime.now().subtract(Duration(seconds: poem.timer!));
        }
        else {
          // Sinon on commence à maintenant.
          startTime = DateTime.now();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Le chrono est désormais actif.",
            textAlign: TextAlign.center,
            )
          )
        );
      } else {
        poem.timer = DateTime.now().difference(startTime).inSeconds;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Le chrono est désormais inactif.",
            textAlign: TextAlign.center,
            )
          )
        );
      }
      poem.save();
    });
  }

  Future<void> updateTitle(String value, String poemId) async {
    final poem = db.getPoem(poemId);
    if (poem == null) return;

    poem.title = value;
    await poem.save();
  }

  Future<void> updateContent(String value, String poemId) async {
    final poem = db.getPoem(poemId);
    if (poem == null) return;

    poem.content = value;

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 800), () async {
      await poem.save();
    });

    if (_debounceWordsStats?.isActive ?? false) {
      _debounceWordsStats!.cancel();
    }

    _debounceWordsStats = Timer(const Duration(milliseconds: 2300), () async {
      await _computeWordsStats(poem, value);
    });
  }

  Future<void> _computeWordsStats(PoemData poem, String value) async {
    // Ne prend uniquement en compte les mots, séparés par des caractères blancs
    // (retour à la ligne, tabulation, espace...). Ignore toute ponctuation isolée.

    poem.wordCount = value.trim().isEmpty
      ? 0
      : value.trim().split(exp).length - 1;

    poem.challengeWordCount = 0;

    for (final match in exp.allMatches(value)) {

      if (challengeSet != null && challengeSet!.contains(match[0]!.toLowerCase())) {
        poem.challengeWordCount++;
      }
    }

    await poem.save();
  }

  @override
  Widget build(BuildContext context) {
    // on récupère l'Id passé en arguments
    final poemId = (ModalRoute.of(context)?.settings.arguments) as String;

    return Scaffold(

      appBar: AppBar(
        title: Text("Poème"),
        automaticallyImplyLeading: false,

        actions: [
          PopupMenuButton(
            icon: Icon(Icons.share_outlined, color: Color.fromARGB(255, 50, 120, 230)),
            tooltip: "Partager au format...",
            position: PopupMenuPosition.under,
            elevation: 16.0,
            popUpAnimationStyle: AnimationStyle(
              curve: Curves.ease,
              duration: Duration(milliseconds: 750),
            ),
            color: Color.fromARGB(227, 25, 25, 25),
            onSelected: (value) async {
              final poem = db.getPoem(poemId)!;
              final String divider = "-" * poem.title.length;
              switch (value) {
                case "texte":
                  // si texte -> copier sous format Titre\n--------\nContenu
                  await Clipboard.setData(ClipboardData(text: "${poem.title}\n$divider\n${poem.content}")).then((_) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Poème copié dans le presse-papier.",
                        textAlign: TextAlign.center,
                        )
                      )
                    );
                  });
                  break;
                case "discord":
                  // si texte -> copier sous format Titre\n--------\nContenu
                  await Clipboard.setData(ClipboardData(text: "```md\n${poem.title}\n$divider\n${poem.content}\n```")).then((_) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Poème copié dans le presse-papier.\nLe texte sera collé proprement sur discord.",
                        textAlign: TextAlign.center,
                        )
                      )
                    );
                  });
                  break;
                case "secret":
                  // si secret -> ouvrir lien YouTube d'une vidéo célèbre
                  const url = 'https://www.youtube.com/watch?v=xvFZjo5PgG0';
                  await launchUrlString(url);
                  break;
                default:
                  // sinon?
              }
            },
            itemBuilder: (context) {
              // 1 chance sur 100 d'avoir l'option secrète
              bool odd = Random().nextInt(100) == 32;

              return <PopupMenuEntry<String>>[
                // serait mieux avec un enum mais pas grave pour deux options
                const PopupMenuItem(
                  value: "texte",
                  child: ListTile(
                    leading: Icon(Icons.text_snippet_outlined),
                    title: Text("Texte"),
                  ),
                ),
                const PopupMenuItem(
                  value: "discord",
                  child: ListTile(
                    leading: Icon(Icons.discord_outlined),
                    title: Text("Discord"),
                  ),
                ),
                if (odd) const PopupMenuDivider(),
                if (odd) const PopupMenuItem(
                  value: "secret",
                  child: ListTile(
                    leading: Icon(Icons.event_outlined),
                    title: Text("Autre"),
                  )
                )
              ];
            }
          ),

          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Revenir au menu principal",
            color:Color(0xFFF5F5F5),
            onPressed: () {
              if (runningChrono) {
                toggleChrono();
              }

              Navigator.pushNamed(context, '/homemenu');
            },
          ),
        ],

        leading:
          // Reset du chrono
          IconButton(onPressed: () {
            setState(() {
              final poem = db.getPoem(poemId)!;
              if (poem.timer != 0 && poem.timer != null) {
                poem.timer = 0;
                poem.save();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Le chrono a été réinitialisé.",
                    textAlign: TextAlign.center,
                    )
                  )
                );
              }
            });
          },
          icon: Icon(Icons.timer_off_outlined, color:Color(0xFFA82A2A), ),
          tooltip: "Réinitialiser le chrono",
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: switchTabWords,
        backgroundColor: Color(0x65C0C0C0),
        child: Icon(Icons.keyboard_double_arrow_right_sharp, color: Color(0xFF000000)),
      ),

      body:
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 8.0,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextFormField(
                    initialValue: db.getPoem(poemId)!.title,
                    onChanged: (value) => updateTitle(value, poemId),
                    minLines: 1,
                    maxLines: 1,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    maxLength: 64,
                    autofocus: false,
                    
                    expands: false,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Titre",
                      hintStyle: TextStyle(color: Color(0x7AF5F5F5))
                    ),
                  ),
                ),

                IconButton(
                  onPressed: toggleChrono,
                  icon: Icon(Icons.timer_outlined),
                  tooltip: "Activer / Pauser le chrono",
                  color: runningChrono ? Colors.blue : Color(0xFFF5F5F5),
                  iconSize: 40,
                ),
              ]
            ),
            Expanded(
              child: TextField(
                onChanged: (value) => updateContent(value, poemId),
                autofocus: false,
                
                controller: _controller,

                expands: true,
                minLines: null,
                maxLines: null,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                maxLength: -1,

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1.4,
                ),

                decoration: InputDecoration(
                  hintText: "Écrire le poème ici...",
                  hintStyle: TextStyle(color: Color(0x7AF5F5F5)),
                ),
              )
            ),
            SizedBox(
              height: 75.0,
            )
          ]
        ),
      )
    );
  }
}
