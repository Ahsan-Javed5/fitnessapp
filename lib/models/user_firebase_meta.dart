import 'package:hive/hive.dart';

part 'user_firebase_meta.g.dart';

@HiveType(typeId: 12)
class UserFirebaseMeta {
  @HiveField(0)
  String? availability;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? fcm;
  @HiveField(4)
  String? nameLowercase;
  @HiveField(5)
  String? phone;
  @HiveField(6)
  String? pictureUrl;
  @HiveField(7)
  String? userType;

  UserFirebaseMeta({
    this.availability,
    this.name,
    this.email,
    this.fcm,
    this.nameLowercase,
    this.phone,
    this.pictureUrl,
    this.userType,
  });

  UserFirebaseMeta.fromJson(Map<String, dynamic> json) {
    availability = json['availability']?.toString();
    email = json['email']?.toString();
    fcm = json['fcm']?.toString();
    name = json['name']?.toString();
    nameLowercase = json['name_lowercase']?.toString();
    phone = json['phone']?.toString();
    pictureUrl = json['pictureURL']?.toString();
    userType = json['userType']?.toString();
  }
}
