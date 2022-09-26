class SubscriptionResp {
  var id;
  String? amountPaid;
  String? startsAt;
  String? endsAt;
  String? status;
  int? userId;
  String? coachId;
  String? updatedAt;
  String? createdAt;

  SubscriptionResp(
      {this.id,
      this.amountPaid,
      this.startsAt,
      this.endsAt,
      this.status,
      this.userId,
      this.coachId,
      this.updatedAt,
      this.createdAt});

  SubscriptionResp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amountPaid = json['amount_paid'];
    startsAt = json['starts_at'];
    endsAt = json['ends_at'];
    status = json['status'];
    userId = json['user_id'];
    coachId = json['coach_id'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['amount_paid'] = amountPaid;
    data['starts_at'] = startsAt;
    data['ends_at'] = endsAt;
    data['status'] = status;
    data['user_id'] = userId;
    data['coach_id'] = coachId;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}
