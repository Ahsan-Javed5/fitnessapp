// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocaleTypeAdapter extends TypeAdapter<LocaleType> {
  @override
  final int typeId = 2;

  @override
  LocaleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LocaleType.en;
      case 1:
        return LocaleType.ar;
      default:
        return LocaleType.en;
    }
  }

  @override
  void write(BinaryWriter writer, LocaleType obj) {
    switch (obj) {
      case LocaleType.en:
        writer.writeByte(0);
        break;
      case LocaleType.ar:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
