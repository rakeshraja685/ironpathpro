// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progression_rule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressionRuleAdapter extends TypeAdapter<ProgressionRule> {
  @override
  final int typeId = 1;

  @override
  ProgressionRule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressionRule(
      id: fields[0] as String,
      type: fields[1] as ProgressionType,
      minReps: fields[2] as int,
      maxReps: fields[3] as int,
      increment: fields[4] as double,
      decrement: fields[5] as double,
      rpeThreshold: fields[6] as double,
      name: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressionRule obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.minReps)
      ..writeByte(3)
      ..write(obj.maxReps)
      ..writeByte(4)
      ..write(obj.increment)
      ..writeByte(5)
      ..write(obj.decrement)
      ..writeByte(6)
      ..write(obj.rpeThreshold)
      ..writeByte(7)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressionRuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
