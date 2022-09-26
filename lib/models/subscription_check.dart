class SubscriptionCheck {
  bool? isSubscribed;
  String? expiryDate;

  SubscriptionCheck({this.isSubscribed, this.expiryDate});

  SubscriptionCheck.fromJson(Map<String, dynamic> json) {
    isSubscribed = json['is_subscribed'] as bool?;
    expiryDate = json['expiry_date'] as String?;
  }
}
