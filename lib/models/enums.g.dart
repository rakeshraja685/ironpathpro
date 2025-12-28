// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitAdapter extends TypeAdapter<Unit> {
  @override
  final int typeId = 9;

  @override
  Unit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Unit.kg;
      case 1:
        return Unit.lb;
      default:
        return Unit.kg;
    }
  }

  @override
  void write(BinaryWriter writer, Unit obj) {
    switch (obj) {
      case Unit.kg:
        writer.writeByte(0);
        break;
      case Unit.lb:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SplitTypeAdapter extends TypeAdapter<SplitType> {
  @override
  final int typeId = 10;

  @override
  SplitType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SplitType.ppl;
      case 1:
        return SplitType.upperLower;
      case 2:
        return SplitType.fullBody;
      case 3:
        return SplitType.broSplit;
      case 4:
        return SplitType.custom;
      default:
        return SplitType.ppl;
    }
  }

  @override
  void write(BinaryWriter writer, SplitType obj) {
    switch (obj) {
      case SplitType.ppl:
        writer.writeByte(0);
        break;
      case SplitType.upperLower:
        writer.writeByte(1);
        break;
      case SplitType.fullBody:
        writer.writeByte(2);
        break;
      case SplitType.broSplit:
        writer.writeByte(3);
        break;
      case SplitType.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplitTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProgressionTypeAdapter extends TypeAdapter<ProgressionType> {
  @override
  final int typeId = 11;

  @override
  ProgressionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProgressionType.double;
      case 1:
        return ProgressionType.linear;
      case 2:
        return ProgressionType.repTarget;
      default:
        return ProgressionType.double;
    }
  }

  @override
  void write(BinaryWriter writer, ProgressionType obj) {
    switch (obj) {
      case ProgressionType.double:
        writer.writeByte(0);
        break;
      case ProgressionType.linear:
        writer.writeByte(1);
        break;
      case ProgressionType.repTarget:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExperienceLevelAdapter extends TypeAdapter<ExperienceLevel> {
  @override
  final int typeId = 12;

  @override
  ExperienceLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ExperienceLevel.beginner;
      case 1:
        return ExperienceLevel.intermediate;
      case 2:
        return ExperienceLevel.advanced;
      default:
        return ExperienceLevel.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, ExperienceLevel obj) {
    switch (obj) {
      case ExperienceLevel.beginner:
        writer.writeByte(0);
        break;
      case ExperienceLevel.intermediate:
        writer.writeByte(1);
        break;
      case ExperienceLevel.advanced:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExperienceLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
