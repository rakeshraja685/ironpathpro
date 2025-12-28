// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_day_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgramDayExerciseAdapter extends TypeAdapter<ProgramDayExercise> {
  @override
  final int typeId = 13;

  @override
  ProgramDayExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramDayExercise(
      exerciseId: fields[0] as String,
      targetSets: fields[1] as int,
      targetReps: fields[2] as String,
      progressionRuleId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProgramDayExercise obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.targetSets)
      ..writeByte(2)
      ..write(obj.targetReps)
      ..writeByte(3)
      ..write(obj.progressionRuleId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramDayExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
