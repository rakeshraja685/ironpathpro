// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgramDayAdapter extends TypeAdapter<ProgramDay> {
  @override
  final int typeId = 3;

  @override
  ProgramDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgramDay(
      id: fields[0] as String,
      name: fields[1] as String,
      exercises: (fields[2] as List).cast<ProgramDayExercise>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProgramDay obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exercises);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
