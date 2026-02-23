import 'package:flutter/material.dart';

class WordTile extends StatefulWidget {
  final String word;
  final Color color;
  final VoidCallback deleteWord;
  final VoidCallback changeColor;
  final Function(String) updateText;

  const WordTile({
    super.key,
    required this.word,
    required this.color,
    required this.deleteWord,
    required this.changeColor,
    required this.updateText,
  });

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {

  final wordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    wordController.text = widget.word;

    wordController.addListener(() {
      widget.updateText(wordController.text);
    });
  }

  @override
  void dispose() {
    wordController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WordTile oldWidget) {
    // important de remettre à jour les mots
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word != widget.word) {
      wordController.text = widget.word;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0),
      child: Row(
        spacing: 8.0,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: widget.deleteWord,
            icon: Icon(
              Icons.close_rounded,
              color: Color(0xFFA82A2A),
            )
          ),
          Flexible(
            child: TextField(
              controller: wordController,
              onChanged: (text) => widget.updateText(text),
              onSubmitted: (text) => widget.updateText(text),
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              minLines: 1,
              maxLines: 1,
              expands: false,
              decoration: InputDecoration(
                hintText: "Entrez un mot...",
                hintStyle: TextStyle(
                  color: Color(0x7AF5F5F5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:25.0),
            child: IconButton(
              onPressed: widget.changeColor,
              icon: Icon(Icons.square),
              iconSize: 26,
              color: widget.color,
            ),
          )
        ],
      ),
    );
  }
}