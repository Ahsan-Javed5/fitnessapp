import 'package:fitnessapp/models/user/user.dart';

class Subscriber {
  int? id;
  User? user;
  String? status;
  String? endsAt;
  String? startsAt;
  int? amountPaid;

  Subscriber({
    this.id,
    this.user,
    this.status,
    this.endsAt,
    this.startsAt,
    this.amountPaid,
  });

  Subscriber.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    user = (json['User'] != null && (json['User'] is Map))
        ? User.fromJson(json['User'])
        : null;
    status = json['status']?.toString();
    endsAt = json['ends_at']?.toString();
    startsAt = json['starts_at']?.toString();
    amountPaid = int.tryParse(json['amount_paid']?.toString() ?? '');
  }
}
