class AdminSettings {
  int? id;
  String? matrix;
  String? value;
  String? valueArabic;
  String? status;

  AdminSettings({
    this.id,
    this.matrix,
    this.value,
    this.valueArabic,
    this.status,
  });

  AdminSettings.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    matrix = json['matrix']?.toString();
    value = json['value']?.toString();
    valueArabic = json['value_arabic']?.toString();
    status = json['status']?.toString();
  }
}
