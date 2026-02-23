// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poem_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoemDataAdapter extends TypeAdapter<PoemData> {
  @override
  final int typeId = 0;

  @override
  PoemData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PoemData(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      title: fields[2] as String,
      content: fields[3] as String,
      timer: fields[4] as int?,
      wordCount: fields[5] as int,
      challengeWordCount: fields[6] as int,
      challengeWords: (fields[7] as List).cast<WordItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, PoemData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.timer)
      ..writeByte(5)
      ..write(obj.wordCount)
      ..writeByte(6)
      ..write(obj.challengeWordCount)
      ..writeByte(7)
      ..write(obj.challengeWords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoemDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
