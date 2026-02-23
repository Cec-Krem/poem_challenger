import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poem_challenger/data/poem_data.dart';
import 'package:poem_challenger/util/word_item.dart';

class PoemDatabase {

  late Box<PoemData> poemBox;

  Future<void> init() async {
    poemBox = Hive.box<PoemData>('poems');
  }

  void createNewData() {
    String newId = UniqueKey().toString();

    PoemData poem = PoemData(
      id: newId,
      date: DateTime.now(),
      title: "Poème",
      content: "Un exemple coloré",
      timer: null,
      wordCount: 3,
      challengeWordCount: 2,
      challengeWords: [
        WordItem(word: "exemple", colorValue: Colors.redAccent.toARGB32()),
        WordItem(word: "coloré", colorValue: Colors.greenAccent.toARGB32()),
      ],
    );

    poemBox.put(newId, poem);
  }

  void updatePoem(PoemData poem) {
    poemBox.put(poem.id, poem);
  }

  void deletePoem(String id) {
    poemBox.delete(id);
  }

  PoemData? getPoem(String id) {
    return poemBox.get(id);
  }

  String getLastId() {
    List<PoemData> newList = poemBox.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    return newList.first.id;
  }
}