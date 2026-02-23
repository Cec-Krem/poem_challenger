import 'package:poem_challenger/util/abstract_poem_tile.dart';

class UntimedPoemTile extends AbstractPoemTile {

  const UntimedPoemTile({
    super.key,
    required super.id,
    required super.poemName,
    required super.date,
    required super.wordCount,
    required super.challengeWords,
    super.deleteFunction,
    super.time,
    super.selectFunction,
  });
}