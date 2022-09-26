import 'package:hive/hive.dart';


part 'user_credentials.g.dart';

/// This class is for remember user data, userName and password
/// when user login we will remember his credentials and save locally
/// When he will come on login screen again and click on 'use face id' and authenticate successfully, then we will use last entered credentials which we save locally


@HiveType(typeId: 13)
class UserCredentials{
  @HiveField(0)
  String? userName;

  @HiveField(1)
  String? password;
}
