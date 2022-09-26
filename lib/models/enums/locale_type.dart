import 'package:hive/hive.dart';
part 'locale_type.g.dart';

@HiveType(typeId: 2)
enum LocaleType {
  @HiveField(0)
  en,
  @HiveField(1)
  ar,
}
