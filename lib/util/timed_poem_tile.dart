import 'package:poem_challenger/util/abstract_poem_tile.dart';

class TimedPoemTile extends AbstractPoemTile {

  const TimedPoemTile({
    super.key,
    required super.id,
    required super.poemName,
    required super.date,
    required super.wordCount,
    required super.challengeWords,
    super.deleteFunction,
    required super.time,
    super.selectFunction,
  });
}