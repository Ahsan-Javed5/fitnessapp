import 'package:hive/hive.dart';

part 'country.g.dart';

@HiveType(typeId: 5)
class Country {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? iso;

  Country({
    this.id,
    this.name,
    this.iso,
  });

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    name = json['name']?.toString();
    iso = json['iso_3']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['iso_3'] = iso;
    return data;
  }
}
