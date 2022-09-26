import 'package:fitnessapp/utils/utils.dart';

class Matrix {
  int? id;
  String? matrix;
  String? value;
  String? valueArabic;

  Matrix({
    this.id,
    this.matrix,
    this.value,
    this.valueArabic,
  });

  get localizedValue => Utils.isRTL() ? valueArabic ?? '' : value ?? '';

  Matrix.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    matrix = json['matrix']?.toString();
    value = json['value']?.toString();
    valueArabic = json['value_arabic']?.toString();
  }
}
