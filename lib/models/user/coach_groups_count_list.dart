class CoachGroupCount {
  String? type;
  int? count;
  int? coachId;

  CoachGroupCount({this.type, this.count});

  CoachGroupCount.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['count'] = count;
    return data;
  }
}
