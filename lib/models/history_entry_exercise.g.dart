// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryEntryExerciseAdapter extends TypeAdapter<HistoryEntryExercise> {
  @override
  final int typeId = 14;

  @override
  HistoryEntryExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryEntryExercise(
      name: fields[0] as String,
      bestSet: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryEntryExercise obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bestSet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryEntryExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
