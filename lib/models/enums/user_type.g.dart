// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTypeAdapter extends TypeAdapter<UserType> {
  @override
  final int typeId = 1;

  @override
  UserType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserType.guest;
      case 1:
        return UserType.coach;
      case 2:
        return UserType.user;
      case 3:
        return UserType.noUser;
      default:
        return UserType.guest;
    }
  }

  @override
  void write(BinaryWriter writer, UserType obj) {
    switch (obj) {
      case UserType.guest:
        writer.writeByte(0);
        break;
      case UserType.coach:
        writer.writeByte(1);
        break;
      case UserType.user:
        writer.writeByte(2);
        break;
      case UserType.noUser:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
