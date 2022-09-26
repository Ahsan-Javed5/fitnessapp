// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VideoAdapter extends TypeAdapter<Video> {
  @override
  final int typeId = 8;

  @override
  Video read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Video(
      id: fields[0] as int?,
      videoUrl: fields[1] as String?,
      duration: fields[2] as dynamic,
      title_en: fields[3] as String?,
      title_ar: fields[4] as String?,
      description_en: fields[5] as String?,
      description_ar: fields[6] as String?,
      createdAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
      coachId: fields[9] as int?,
      privateVideoGroupId: fields[10] as int?,
      thumbnail: fields[13] as String?,
      user: fields[12] as User?,
      isProcessed: fields[14] as int?,
      videoStreamUrl: fields[15] as String?,
      video_id: fields[16] as int?,
    )..notifySubscriber = fields[11] as bool?;
  }

  @override
  void write(BinaryWriter writer, Video obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoUrl)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.title_en)
      ..writeByte(4)
      ..write(obj.title_ar)
      ..writeByte(5)
      ..write(obj.description_en)
      ..writeByte(6)
      ..write(obj.description_ar)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.coachId)
      ..writeByte(10)
      ..write(obj.privateVideoGroupId)
      ..writeByte(11)
      ..write(obj.notifySubscriber)
      ..writeByte(12)
      ..write(obj.user)
      ..writeByte(13)
      ..write(obj.thumbnail)
      ..writeByte(14)
      ..write(obj.isProcessed)
      ..writeByte(15)
      ..write(obj.videoStreamUrl)
      ..writeByte(16)
      ..write(obj.video_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
