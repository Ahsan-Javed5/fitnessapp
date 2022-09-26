import 'package:fitnessapp/utils/utils.dart';
import 'package:hive/hive.dart';

part 'workout_program_type.g.dart';

@HiveType(typeId: 10)
class WorkoutProgramType {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? nameArabic;
  bool isSelected = false;

  get localizedName => Utils.isRTL() ? (nameArabic ?? name) : name;

  WorkoutProgramType({this.id, this.name, this.nameArabic});

  WorkoutProgramType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameArabic = json['name_arabic'];
  }
}
