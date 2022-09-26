// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BankDetailsAdapter extends TypeAdapter<BankDetails> {
  @override
  final int typeId = 11;

  @override
  BankDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankDetails(
      id: fields[0] as int?,
      fullName: fields[1] as String?,
      swiftCode: fields[2] as String?,
      currency: fields[3] as String?,
      accountNumber: fields[4] as int?,
      ibanNumber: fields[5] as String?,
      documentType: fields[6] as String?,
      expiryDate: fields[7] as String?,
      documentImage: fields[8] as String?,
      signatureImageUrl: fields[9] as String?,
      subscriptionPrice: fields[10] as int?,
      createdAt: fields[11] as String?,
      updatedAt: fields[12] as String?,
      userId: fields[13] as int?,
      countryId: fields[14] as int?,
      documentNumber: fields[16] as String?,
    )..bankId = fields[15] as int?;
  }

  @override
  void write(BinaryWriter writer, BankDetails obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.swiftCode)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.accountNumber)
      ..writeByte(5)
      ..write(obj.ibanNumber)
      ..writeByte(6)
      ..write(obj.documentType)
      ..writeByte(7)
      ..write(obj.expiryDate)
      ..writeByte(8)
      ..write(obj.documentImage)
      ..writeByte(9)
      ..write(obj.signatureImageUrl)
      ..writeByte(10)
      ..write(obj.subscriptionPrice)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.userId)
      ..writeByte(14)
      ..write(obj.countryId)
      ..writeByte(15)
      ..write(obj.bankId)
      ..writeByte(16)
      ..write(obj.documentNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
