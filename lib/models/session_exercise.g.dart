// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionExerciseAdapter extends TypeAdapter<SessionExercise> {
  @override
  final int typeId = 6;

  @override
  SessionExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionExercise(
      exerciseId: fields[0] as String,
      progressionRuleId: fields[1] as String?,
      sets: (fields[2] as List).cast<WorkoutSet>(),
      notes: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SessionExercise obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.exerciseId)
      ..writeByte(1)
      ..write(obj.progressionRuleId)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
