// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_firebase_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserFirebaseMetaAdapter extends TypeAdapter<UserFirebaseMeta> {
  @override
  final int typeId = 12;

  @override
  UserFirebaseMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserFirebaseMeta(
      availability: fields[0] as String?,
      name: fields[1] as String?,
      email: fields[2] as String?,
      fcm: fields[3] as String?,
      nameLowercase: fields[4] as String?,
      phone: fields[5] as String?,
      pictureUrl: fields[6] as String?,
      userType: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserFirebaseMeta obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.availability)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.fcm)
      ..writeByte(4)
      ..write(obj.nameLowercase)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.pictureUrl)
      ..writeByte(7)
      ..write(obj.userType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserFirebaseMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
