// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 4;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      userName: fields[3] as String?,
      userType: fields[4] as String?,
      email: fields[5] as String?,
      gender: fields[6] as String?,
      firebaseKey: fields[7] as String?,
      phoneNumber: fields[8] as String?,
      imageUrl: fields[9] as String?,
      faceIdToken: fields[10] as String?,
      isVerified: fields[11] as bool?,
      isArchived: fields[12] as bool?,
      selectedLanguage: fields[13] as String?,
      preferredOTPDelivery: fields[14] as String?,
      subscribersCount: fields[15] as int?,
      monthlySubscriptionPrice: fields[16] as int?,
      allowPrivateChat: fields[17] as bool?,
      countryId: fields[18] as int?,
      userWorkoutProgramTypes:
          (fields[19] as List?)?.cast<WorkoutProgramType?>(),
      coachIntroVideo: fields[20] as Video?,
      country: fields[21] as Country?,
      token: fields[22] as String?,
      isSubscribed: fields[24] as bool?,
      subscriptionFee: fields[25] as int?,
      subscriptionStart: fields[26] as String?,
      subscriptionEnd: fields[27] as String?,
      resetPasswordToken: fields[28] as String?,
      bankDetails: fields[29] as BankDetails?,
      countList: (fields[23] as List?)?.cast<CoachGroupCount>(),
      startsAt: fields[30] as String?,
      endsAt: fields[31] as String?,
      appIntroVideo: fields[32] as String?,
      appIntroVideoArabic: fields[33] as String?,
      coachIntroVideoThumbnailNA: fields[34] as String?,
      appIntroVideoArThumbnail: fields[36] as String?,
      appIntroVideoEnThumbnail: fields[35] as String?,
      firebaseJWT: fields[37] as String?,
      bio: fields[38] as String?,
    )
      ..appIntroVideoStreamingUrl = fields[39] as String?
      ..appIntroVideoArabicStreamUrl = fields[40] as String?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(41)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.userType)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.firebaseKey)
      ..writeByte(8)
      ..write(obj.phoneNumber)
      ..writeByte(9)
      ..write(obj.imageUrl)
      ..writeByte(10)
      ..write(obj.faceIdToken)
      ..writeByte(11)
      ..write(obj.isVerified)
      ..writeByte(12)
      ..write(obj.isArchived)
      ..writeByte(13)
      ..write(obj.selectedLanguage)
      ..writeByte(14)
      ..write(obj.preferredOTPDelivery)
      ..writeByte(15)
      ..write(obj.subscribersCount)
      ..writeByte(16)
      ..write(obj.monthlySubscriptionPrice)
      ..writeByte(17)
      ..write(obj.allowPrivateChat)
      ..writeByte(18)
      ..write(obj.countryId)
      ..writeByte(19)
      ..write(obj.userWorkoutProgramTypes)
      ..writeByte(20)
      ..write(obj.coachIntroVideo)
      ..writeByte(21)
      ..write(obj.country)
      ..writeByte(22)
      ..write(obj.token)
      ..writeByte(23)
      ..write(obj.countList)
      ..writeByte(24)
      ..write(obj.isSubscribed)
      ..writeByte(25)
      ..write(obj.subscriptionFee)
      ..writeByte(26)
      ..write(obj.subscriptionStart)
      ..writeByte(27)
      ..write(obj.subscriptionEnd)
      ..writeByte(28)
      ..write(obj.resetPasswordToken)
      ..writeByte(29)
      ..write(obj.bankDetails)
      ..writeByte(30)
      ..write(obj.startsAt)
      ..writeByte(31)
      ..write(obj.endsAt)
      ..writeByte(32)
      ..write(obj.appIntroVideo)
      ..writeByte(33)
      ..write(obj.appIntroVideoArabic)
      ..writeByte(34)
      ..write(obj.coachIntroVideoThumbnailNA)
      ..writeByte(35)
      ..write(obj.appIntroVideoEnThumbnail)
      ..writeByte(36)
      ..write(obj.appIntroVideoArThumbnail)
      ..writeByte(37)
      ..write(obj.firebaseJWT)
      ..writeByte(38)
      ..write(obj.bio)
      ..writeByte(39)
      ..write(obj.appIntroVideoStreamingUrl)
      ..writeByte(40)
      ..write(obj.appIntroVideoArabicStreamUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
