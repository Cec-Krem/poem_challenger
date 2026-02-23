import 'package:hive/hive.dart';
import 'package:poem_challenger/util/word_item.dart';

part 'poem_data.g.dart';

@HiveType(typeId: 0)
class PoemData extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String title;

  @HiveField(3)
  String content;

  /// Temps en secondes (s)
  @HiveField(4)
  int? timer;

  @HiveField(5)
  int wordCount;

  @HiveField(6)
  int challengeWordCount;

  @HiveField(7)
  List<WordItem> challengeWords;

  PoemData({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.timer,
    required this.wordCount,
    required this.challengeWordCount,
    required this.challengeWords,
  });
  
  bool get isTimed => timer != null && timer != 0;
  bool get isUntimed => timer == null || timer == 0;
}