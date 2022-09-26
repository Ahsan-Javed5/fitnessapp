import 'package:hive/hive.dart';

part 'user_type.g.dart';

@HiveType(typeId: 1)
enum UserType {
  @HiveField(0)
  guest,
  @HiveField(1)
  coach,
  @HiveField(2)
  user,
  @HiveField(3)
  noUser,
}

