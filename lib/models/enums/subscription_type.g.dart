// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionTypeAdapter extends TypeAdapter<SubscriptionType> {
  @override
  final int typeId = 3;

  @override
  SubscriptionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return SubscriptionType.subscribed;
      case 2:
        return SubscriptionType.unSubscribed;
      default:
        return SubscriptionType.subscribed;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionType obj) {
    switch (obj) {
      case SubscriptionType.subscribed:
        writer.writeByte(1);
        break;
      case SubscriptionType.unSubscribed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
