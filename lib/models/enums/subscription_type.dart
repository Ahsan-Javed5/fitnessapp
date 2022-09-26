import 'package:hive/hive.dart';

part 'subscription_type.g.dart';

@HiveType(typeId: 3)
enum SubscriptionType {
  @HiveField(1)
  subscribed,
  @HiveField(2)
  unSubscribed,
}
