import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'word_item.g.dart';

@HiveType(typeId: 1)
class WordItem {

  @HiveField(0)
  String id;

  @HiveField(1)
  String word;

  @HiveField(2)
  int colorValue;

  WordItem({
    required this.word,
    required this.colorValue,
  })  : id = UniqueKey().toString();

}