import 'package:fitnessapp/utils/utils.dart';

class FAQ {
  int? id;
  String? questionAr;
  String? questionEn;
  String? answerAr;
  String? answerEn;
  String? createdAt;
  String? updatedAt;

  get question => Utils.isRTL() ? questionAr : questionEn;

  get answer => Utils.isRTL() ? answerAr : answerEn;

  FAQ({
    this.id,
    this.questionAr,
    this.questionEn,
    this.answerAr,
    this.answerEn,
    this.createdAt,
    this.updatedAt,
  });

  FAQ.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    questionAr = json['question_ar']?.toString();
    questionEn = json['question_en']?.toString();
    answerAr = json['answer_ar']?.toString();
    answerEn = json['answer_en']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }
}
