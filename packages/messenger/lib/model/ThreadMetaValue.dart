import 'package:json_annotation/json_annotation.dart';

part 'ThreadMetaValue.g.dart';

@JsonSerializable()
class ThreadMetaValue {
  @JsonKey(name: 'creator_entity_id')
  String? creatorEntityId;
  int? type;
  String? creator;
  @JsonKey(name: 'creation_date')
  double? creationDate;
  @JsonKey(name: 'state')
  String? state;

  ThreadMetaValue(
    this.creatorEntityId,
    this.type,
    this.creator,
    this.creationDate,
    this.state,
  );

  factory ThreadMetaValue.fromJson(Map<String, dynamic> json) =>
      _$ThreadMetaValueFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadMetaValueToJson(this);
}
