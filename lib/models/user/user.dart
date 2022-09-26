import 'package:fitnessapp/models/bank_details.dart';
import 'package:fitnessapp/models/country.dart';
import 'package:fitnessapp/models/user/coach_groups_count_list.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:hive/hive.dart';

import '../video.dart';
import '../workout_program_type.dart';

part 'user.g.dart';

@HiveType(typeId: 4)
class User {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? firstName;

  @HiveField(2)
  String? lastName;

  @HiveField(3)
  String? userName;

  @HiveField(4)
  String? userType;

  @HiveField(5)
  String? email;

  @HiveField(6)
  String? gender;

  @HiveField(7)
  String? firebaseKey;

  @HiveField(8)
  String? phoneNumber;

  @HiveField(9)
  String? imageUrl;

  @HiveField(10)
  String? faceIdToken;

  @HiveField(11)
  bool? isVerified;

  @HiveField(12)
  bool? isArchived;

  @HiveField(13)
  String? selectedLanguage;

  @HiveField(14)
  String? preferredOTPDelivery;

  @HiveField(15)
  int? subscribersCount;

  @HiveField(16)
  int? monthlySubscriptionPrice;

  @HiveField(17)
  bool? allowPrivateChat;

  @HiveField(18)
  int? countryId;

  @HiveField(19)
  List<WorkoutProgramType?>? userWorkoutProgramTypes;

  @HiveField(20)
  Video? coachIntroVideo;

  @HiveField(21)
  Country? country;

  @HiveField(22)
  String? token;

  @HiveField(23)
  List<CoachGroupCount>? countList;

  @HiveField(24)
  bool? isSubscribed;

  @HiveField(25)
  int? subscriptionFee;

  @HiveField(26)
  String? subscriptionStart;

  @HiveField(27)
  String? subscriptionEnd;

  @HiveField(28)
  String? resetPasswordToken;

  @HiveField(29)
  BankDetails? bankDetails;

  @HiveField(30)
  String? startsAt;

  @HiveField(31)
  String? endsAt;

  @HiveField(32)
  String? appIntroVideo;

  @HiveField(33)
  String? appIntroVideoArabic;

  @HiveField(34)
  String? coachIntroVideoThumbnailNA;

  @HiveField(35)
  String? appIntroVideoEnThumbnail;

  @HiveField(36)
  String? appIntroVideoArThumbnail;

  @HiveField(37)
  String? firebaseJWT;

  @HiveField(38)
  String? bio;

  @HiveField(39)
  String? appIntroVideoStreamingUrl;

  @HiveField(40)
  String? appIntroVideoArabicStreamUrl;

  get localizedVideo =>
      Utils.isRTL() ? (appIntroVideoArabic ?? appIntroVideo) : appIntroVideo;

  get localizedStreamVideoUrl =>
      Utils.isRTL() ? appIntroVideoArabicStreamUrl : appIntroVideoStreamingUrl;

  get localizedVideoThumbnail => Utils.isRTL()
      ? (appIntroVideoArThumbnail ?? appIntroVideoEnThumbnail)
      : appIntroVideoEnThumbnail;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.userName,
      this.userType,
      this.email,
      this.gender,
      this.firebaseKey,
      this.phoneNumber,
      this.imageUrl,
      this.faceIdToken,
      this.isVerified,
      this.isArchived,
      this.selectedLanguage,
      this.preferredOTPDelivery,
      this.subscribersCount,
      this.monthlySubscriptionPrice,
      this.allowPrivateChat,
      this.countryId,
      this.userWorkoutProgramTypes,
      this.coachIntroVideo,
      this.country,
      this.token,
      this.isSubscribed,
      this.subscriptionFee,
      this.subscriptionStart,
      this.subscriptionEnd,
      this.resetPasswordToken,
      this.bankDetails,
      this.countList,
      this.startsAt,
      this.endsAt,
      this.appIntroVideo,
      this.appIntroVideoArabic,
      this.coachIntroVideoThumbnailNA,
      this.appIntroVideoArThumbnail,
      this.appIntroVideoEnThumbnail,
      this.firebaseJWT,
      this.bio});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    userName = json['user_name']?.toString();
    userType = json['user_type']?.toString();
    coachIntroVideoThumbnailNA = json['thumbnail_url']?.toString();
    email = json['email']?.toString();
    gender = json['gender']?.toString();
    firebaseKey = json['firebase_key']?.toString();
    phoneNumber = json['phone_number']?.toString();
    imageUrl = json['image_url']?.toString();
    faceIdToken = json['face_id_token']?.toString();
    isVerified = json['is_verified'];
    isArchived = json['is_archived'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    selectedLanguage = json['selected_language']?.toString();
    appIntroVideoEnThumbnail = json['app_intro_thumbnail_english']?.toString();
    appIntroVideoArThumbnail = json['app_intro_thumbnail_arabic']?.toString();
    preferredOTPDelivery = json['preffered_OTP_delivery']?.toString();
    subscribersCount = json['subscribers_count']?.toInt();
    monthlySubscriptionPrice = json['mounthly_subscription_price']?.toInt();
    allowPrivateChat = json['allow_private_chat'];
    token = json['token'];
    firebaseJWT = json['firebase_jwt'];
    bio = json['bio'];
    countryId = json['country_id'];
    appIntroVideo = json['app_intro_video_english'];
    appIntroVideoArabic = json['app_intro_video_arabic'];
    /* if (json['CoachMainGroups'] != null) {
      final v = json['CoachMainGroups'];
      final arr0 = <MainGroup>[];
      v.forEach((v) {
        arr0.add(MainGroup.fromJson(v));
      });
      coachMainGroups = arr0;
    }*/
    if (json['UserWorkoutProgramTypes'] != null) {
      final v = json['UserWorkoutProgramTypes'];
      final arr0 = <WorkoutProgramType>[];
      v.forEach((v) {
        arr0.add(WorkoutProgramType.fromJson(v));
      });
      userWorkoutProgramTypes = arr0;
    }
    coachIntroVideo = json['CoachIntroVideo'] == null
        ? null
        : Video.fromJson(json['CoachIntroVideo']);
    country =
        (json['Country'] != null) ? Country.fromJson(json['Country']) : null;
    subscriptionEnd = json['subscription_end'];
    subscriptionStart = json['subscription_start'];
    isSubscribed = json['is_subscribed'];
    resetPasswordToken = json['reset_password_token'];
    subscriptionFee = null;
    appIntroVideoArabicStreamUrl = json['app_intro_streaming_video_arabic'];
    appIntroVideoStreamingUrl = json['app_intro_streaming_video_english'];
    bankDetails = (json['bankDetails'] != null)
        ? BankDetails.fromJson(json['bankDetails'])
        : null;

    if (json['count_list'] != null) {
      countList = <CoachGroupCount>[];
      json['count_list'].forEach((v) {
        countList?.add(CoachGroupCount.fromJson(v));
      });
    }
  }

  String getFullName() {
    return '$firstName $lastName'.toTitleCase();
  }

  String userWorkoutProgramTypesToString() {
    String s = '';
    if (userWorkoutProgramTypes == null || userWorkoutProgramTypes!.isEmpty) {
      return s;
    } else {
      int length = userWorkoutProgramTypes!.length;

      for (var i = 0; i < length; i++) {
        if (length > 1 && i == length - 1) {
          s += ' & ${userWorkoutProgramTypes![i]!.name ?? ''}';
        } else if (i >= length - 2) {
          s += userWorkoutProgramTypes![i]!.name ?? '';
        } else {
          s += '${userWorkoutProgramTypes![i]!.name ?? ''}, ';
        }
      }
      return s;
    }
  }
}
