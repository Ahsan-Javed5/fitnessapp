
import 'package:json_annotation/json_annotation.dart';
import 'package:messenger/controllers/json_controller.dart';

part 'Read.g.dart';

@JsonSerializable()
class Read {
  int? status;
  double? date;
  String? entityId;

  Read(this.status, this.date, this.entityId);

  factory Read.fromJson(Map<String, dynamic> json) =>
      _$ReadFromJson(JsonController.convertToJson(json));


  factory Read.fromJsonWithId(Map<String, dynamic> json, String entityId){
    json['entityId'] = entityId;
    return _$ReadFromJson(JsonController.convertToJson(json));
  }

  Map<String, dynamic> toJson() => _$ReadToJson(this);
}
