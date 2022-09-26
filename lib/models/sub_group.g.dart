// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubGroupAdapter extends TypeAdapter<SubGroup> {
  @override
  final int typeId = 7;

  @override
  SubGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubGroup(
      id: fields[0] as int?,
      titleEnglish: fields[1] as String?,
      titleArabic: fields[2] as String?,
      descriptionEnglish: fields[3] as String?,
      descriptionArabic: fields[4] as String?,
      groupThumbnail: fields[5] as String?,
      notifySubscribers: fields[6] as bool?,
      createdAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
      mainGroupId: fields[9] as String?,
      videos: (fields[10] as List?)?.cast<Video?>(),
    );
  }

  @override
  void write(BinaryWriter writer, SubGroup obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.notifySubscribers)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.mainGroupId)
      ..writeByte(10)
      ..write(obj.videos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
