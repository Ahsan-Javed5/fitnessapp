// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainGroupAdapter extends TypeAdapter<MainGroup> {
  @override
  final int typeId = 6;

  @override
  MainGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainGroup(
      id: fields[0] as int?,
      titleEnglish: fields[1] as String?,
      titleArabic: fields[2] as String?,
      descriptionEnglish: fields[3] as String?,
      descriptionArabic: fields[4] as String?,
      groupThumbnail: fields[5] as String?,
      groupPlain: fields[6] as String?,
      forGender: fields[7] as String?,
      notifySubscribers: fields[8] as bool?,
      createdAt: fields[9] as String?,
      updatedAt: fields[10] as String?,
      coachId: fields[11] as int?,
      isFree: fields[12] as bool,
      subGroups: (fields[13] as List?)?.cast<SubGroup?>(),
    );
  }

  @override
  void write(BinaryWriter writer, MainGroup obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleEnglish)
      ..writeByte(2)
      ..write(obj.titleArabic)
      ..writeByte(3)
      ..write(obj.descriptionEnglish)
      ..writeByte(4)
      ..write(obj.descriptionArabic)
      ..writeByte(5)
      ..write(obj.groupThumbnail)
      ..writeByte(6)
      ..write(obj.groupPlain)
      ..writeByte(7)
      ..write(obj.forGender)
      ..writeByte(8)
      ..write(obj.notifySubscribers)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.coachId)
      ..writeByte(12)
      ..write(obj.isFree)
      ..writeByte(13)
      ..write(obj.subGroups);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
