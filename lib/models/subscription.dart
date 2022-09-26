import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';

class Subscription {
  var id;
  var amountPaid;
  String? startsAt;
  String? endsAt;
  String? status;
  User? user;

  get formattedStartDateTime => Utils.formatDateTime(startsAt ?? '');

  get formattedEndDateTime => Utils.formatDateTime(endsAt ?? '');

  Subscription(
      {this.id,
      this.amountPaid,
      this.startsAt,
      this.endsAt,
      this.status,
      this.user});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amountPaid = json['amount_paid'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    status = json['status'];

    /// Calculate appropriate map key to get proper response
    /// if user is requesting his subscriptions then use [coach] key
    /// else if Coach is requesting his subscriptions then use [user] key

    String key = MyHive.getUserType() == UserType.coach ? 'User' : 'coach';
    user = json[key] != null ? User.fromJson(json[key]) : null;
  }
}
