// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_program_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutProgramTypeAdapter extends TypeAdapter<WorkoutProgramType> {
  @override
  final int typeId = 10;

  @override
  WorkoutProgramType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutProgramType(
      id: fields[0] as int?,
      name: fields[1] as String?,
      nameArabic: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutProgramType obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nameArabic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutProgramTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}