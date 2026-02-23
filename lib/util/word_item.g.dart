// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordItemAdapter extends TypeAdapter<WordItem> {
  @override
  final int typeId = 1;

  @override
  WordItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordItem(
      word: fields[1] as String,
      colorValue: fields[2] as int,
    )..id = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, WordItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.word)
      ..writeByte(2)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
