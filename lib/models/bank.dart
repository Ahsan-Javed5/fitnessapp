import 'package:hive/hive.dart';

part 'bank.g.dart';

@HiveType(typeId: 9)
class Bank {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? swiftCode;

  Bank({
    this.id,
    this.name,
    this.swiftCode,
  });

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    name = json['name']?.toString();
    swiftCode = json['bank_swift_code']?.toInt();
  }
}
