import 'dart:convert';

import 'package:fitnessapp/models/bank.dart';
import 'package:fitnessapp/models/bank_details.dart';
import 'package:fitnessapp/models/country.dart';
import 'package:fitnessapp/models/enums/locale_type.dart';
import 'package:fitnessapp/models/enums/subscription_type.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/sub_group.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/models/user/user_credentials.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/models/workout_program_type.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class MyHive {
  static late Box _ins;
  static const String _subscriptionType = 'subScrType';
  static const String _userData = 'userData';
  static const String _userType = 'userType';
  static const String _localeType = 'localeType';
  static const String _localeSelected = 'localeSelected';
  static const String _authToken = 'authToken';
  static const String _userCredentials = 'userCredentials';
  static const String _fcm = 'fcm';
  static const String adminFBEntityKey = 'admin';
  static var encryptionKey;

  /// MyFatoorah Credentialsz
  // static const String liveAPIKeyMF =
  //     'O-a1Ai98vtN3Vt2YNy05OuHAD5gbTtwkVb7d2DFTo-3JbK109oteDwebMj3bzg0aonwZ0saq1zyO2faX2a6SO2ydmCU_-XNK3zCmzEIJBEtYu0rqD5vR3sXRDC4sBD0H8PBzw5vPTXn6xDGKzAkUyIYb37y6Jvu_Y-AmuKxEBUSOVEg7zFmi9-wxRxi2hR6zQBOswrD7rwPx3u_w1cRSX8uGk6fNd_ofLR3DSO8ZfMrSC5NKF0dkqWm7An7Fxv2-Q03ymtpVGyqNcMRhBvY_SgDh_dPdG1q2yuxo96hvohs6Nv9n_MgVsvPk2AleokqkJbQ5cKROCVJ4mBvUb0OM0luy6rDW9u4tNLgpPKOXpHSvt8Cbom76TieD-eamlejG6c_ESH-Tjo2vW1ysDoRoO8NCYtgm04lSY1Lr9A5REIBCFTZsV630MKPnTE9cOCR7RlTsJpV3ZM3x88BeXt5mRkSh9XTHafHvoRlBV2RgGw6E3eDhc5569fP4VkcVMQ7NwSXZWyxAWAwQC2T7bTotpWqWA9mKzYSsia56xZ0af9LYPtK1VsnAWa2fakAtmfUdoF-_iEQGt71pQD11Yo7VPxRNTZe1KRgnGVa3XwQk2He3hPeN5Gk68XimTles1A4xTZLedyietGL8X94Gn0hR3BjzGYaLj-BSHwR-eEPfswzOiit9bFrFz0hvcze6KCYB4pTV8w';
  static const String newLiveAPIKeyMFQTR =
      'xg9fsVnFAfe-k2E1roKGxYrvOpJW7lUnZnCnOSXfVql26C8mrB7SMAUSlMMJJFYcqLI4SCxL4akPBS0WizZPZyvZIhBJIDmnwwm5KhleS-wmyHI17pa9dYYTj2kLXhJXGKmASVYW87A-ND_mhm25o0bmq3OPmrPpueDIBqQFJd3JJ5JeD3GMpALPpSGoCIpzy5oc6ExOmV4zv9gte3AL1qi8jEJ-48fAmQBNHAQg1icmDSg7MK6AmBMuyrdFagUIOp9DWIu6bFsObzickaRNCga4bUgZlMvm-W0LHfFRmeep8QAG_6cilvfl9C_PtnTVoseDcm21EHodSwwB7CWWgs1ngKXWDk9X0ZAJFfjqCcPnJxgOmSJN3a-0Bi10v2Smmr5jrX8B9EByPT32QFxUUQLfirFylwDLP3uGFEUv3aiVQxewZNv8zKzffZLXCauZuzPXuOS7k4QdX1wQZqgLgM3ibBXLYqQ1iBKL2zhUtMGNCc9nSSEesuI8TZxoiaZXUywYGIf-HdT82F1hBtDf48fzJRAoBHPF_9gMtfl7Hmk12yBwi6k-hZrxVdxTYsJJzQKwxE1J5yDvdkaxyRWr7q2LbHEwEhcbrH2DYymXOuo74z9fskJG16IpC--RIV6VxNND8ujOw3yacnSgb8zN6OgNCtJLqkhxCYygDKFtuxmckOphkiOVMPnQPyxMv0lgGB-ybg';
  static const String testAPIKeyMF =
      'O-a1Ai98vtN3Vt2YNy05OuHAD5gbTtwkVb7d2DFTo-3JbK109oteDwebMj3bzg0aonwZ0saq1zyO2faX2a6SO2ydmCU_-XNK3zCmzEIJBEtYu0rqD5vR3sXRDC4sBD0H8PBzw5vPTXn6xDGKzAkUyIYb37y6Jvu_Y-AmuKxEBUSOVEg7zFmi9-wxRxi2hR6zQBOswrD7rwPx3u_w1cRSX8uGk6fNd_ofLR3DSO8ZfMrSC5NKF0dkqWm7An7Fxv2-Q03ymtpVGyqNcMRhBvY_SgDh_dPdG1q2yuxo96hvohs6Nv9n_MgVsvPk2AleokqkJbQ5cKROCVJ4mBvUb0OM0luy6rDW9u4tNLgpPKOXpHSvt8Cbom76TieD-eamlejG6c_ESH-Tjo2vW1ysDoRoO8NCYtgm04lSY1Lr9A5REIBCFTZsV630MKPnTE9cOCR7RlTsJpV3ZM3x88BeXt5mRkSh9XTHafHvoRlBV2RgGw6E3eDhc5569fP4VkcVMQ7NwSXZWyxAWAwQC2T7bTotpWqWA9mKzYSsia56xZ0af9LYPtK1VsnAWa2fakAtmfUdoF-_iEQGt71pQD11Yo7VPxRNTZe1KRgnGVa3XwQk2He3hPeN5Gk68XimTles1A4xTZLedyietGL8X94Gn0hR3BjzGYaLj-BSHwR-eEPfswzOiit9bFrFz0hvcze6KCYB4pTV8w';
  static const String guestToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6NDc5LCJmaXJzdF9uYW1lIjoiZ3Vlc3QiLCJsYXN0X25hbWUiOiJ1c2VyIiwidXNlcl9uYW1lIjoiZ3Vlc3QiLCJ1c2VyX3R5cGUiOiJVc2VyIiwiZW1haWwiOiJndWVzdEBjb2Rlc29yYml0LmNvbSIsImdlbmRlciI6Ik1hbGUiLCJmaXJlYmFzZV91c2VyX2tleSI6bnVsbCwiZmlyZWJhc2Vfa2V5IjpudWxsLCJwaG9uZV9udW1iZXIiOiIrMTIzMTIzMTIzIiwiaW1hZ2VfdXJsIjoiaHR0cHM6Ly9maXRhbmRtb3Jlc3RvcmFnZS5ibG9iLmNvcmUud2luZG93cy5uZXQvZml0LW4tbW9yZS1mcmVlLWNvbnRlbnQvaW1hZ2VfcGlja2VyXzIyMjc1N0JDLTNGMjMtNDI3NC1BNzY0LTQ1MjQ0MDlERTVGQy0zNDQzLTAwMDAwNDUyMDRBQzc1QUYucG5nIiwiZmFjZV9pZF90b2tlbiI6bnVsbCwiaXNfdmVyaWZpZWQiOnRydWUsImlzX2FyY2hpdmVkIjpmYWxzZSwic2VsZWN0ZWRfbGFuZ3VhZ2UiOiJFbmdsaXNoIiwicHJlZmZlcmVkX09UUF9kZWxpdmVyeSI6IlNNUyIsInN1YnNjcmliZXJzX2NvdW50IjowLCJtb3VudGhseV9zdWJzY3JpcHRpb25fcHJpY2UiOjAsImFsbG93X3ByaXZhdGVfY2hhdCI6ZmFsc2UsInJlc2V0X3Bhc3N3b3JkX3Rva2VuIjpudWxsLCJjb21pc3Npb25fcGVyIjpudWxsLCJwb3NpdGlvbiI6bnVsbCwiZmlyZWJhc2Vfand0IjpudWxsLCJjb3VudHJ5X2lkIjoxLCJDb2FjaEJhbmtEZXRhaWxzIjp7fSwiVXNlcldvcmtvdXRQcm9ncmFtVHlwZXMiOltdLCJDb2FjaEludHJvVmlkZW8iOnt9LCJDb3VudHJ5Ijp7ImlkIjoxLCJuYW1lIjoiUWF0YXIiLCJpc28iOiJRQVQiLCJpc29fMyI6IlFBVCJ9fQ.izgg49Kj1gnGAT7ngvjXr09OoNFlk3qwlgj_j_KHvXQ';

  /// Azure Credentials
  static const String azureContainer = '/fit-n-more/';
  static const String azureAccountName = 'fitandmorestoragegp';
  static const String azureEndpointSuffix = 'core.windows.net';
  static const String azureConnectionString =
      'BlobEndpoint=https://fitandmorestoragegp.blob.core.windows.net/;QueueEndpoint=https://fitandmorestoragegp.queue.core.windows.net/;FileEndpoint=https://fitandmorestoragegp.file.core.windows.net/;TableEndpoint=https://fitandmorestoragegp.table.core.windows.net/;SharedAccessSignature=sv=2020-08-04&ss=b&srt=sco&sp=rwdlacitfx&se=2023-01-11T16:00:17Z&st=2022-01-11T08:00:17Z&spr=https&sig=B2BQSmGSs%2BnJqIX380YKGx3oWW423vsS4NQlEz9qLGc%3D';
  static const String sasKey =
      '?sv=2020-08-04&ss=b&srt=sco&sp=rwdlacitfx&se=2023-01-11T16:00:17Z&st=2022-01-11T08:00:17Z&spr=https&sig=B2BQSmGSs%2BnJqIX380YKGx3oWW423vsS4NQlEz9qLGc%3D';

  /// Old Azure credentials
  //'DefaultEndpointsProtocol=https;AccountName=fitandmorestorage;AccountKey=mVIl5UN8kG+bTdQoJJ+JFlV/pnaoaX71cR/OR55SU8uZ7JPfE6Hzx3JKIgPXdfVw2MfQR3N87rdEBdpvo8woSA==;EndpointSuffix=core.windows.net';
  //'?sv=2020-08-04&ss=b&srt=sco&sp=rwdlacx&se=2023-11-16T23:13:13Z&st=2021-11-18T15:13:13Z&spr=https,http&sig=qSlovArDISHF1snEmgu%2BCZvhTEl9lI34QXq921Ex0rg%3D';

  Box get ins => _ins;

  static init() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    var secureKey = await secureStorage.read(key: 'secure_key_32');
    var containsEncryptionKey = (secureKey?.isNotEmpty ?? false);
    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(
          key: 'secure_key_32', value: base64UrlEncode(key));
    }
    encryptionKey =
        base64Url.decode(await secureStorage.read(key: 'secure_key_32') ?? '');

    Hive
      ..registerAdapter(BankAdapter())
      ..registerAdapter(VideoAdapter())
      ..registerAdapter(CountryAdapter())
      ..registerAdapter(SubGroupAdapter())
      ..registerAdapter(MainGroupAdapter())
      ..registerAdapter(UserTypeAdapter())
      ..registerAdapter(LocaleTypeAdapter())
      ..registerAdapter(WorkoutProgramTypeAdapter())
      ..registerAdapter(UserAdapter())
      ..registerAdapter(BankDetailsAdapter())
      ..registerAdapter(UserCredentialsAdapter())
      ..registerAdapter(SubscriptionTypeAdapter());
    _ins = await Hive.openBox('APP',
        encryptionCipher: HiveAesCipher(encryptionKey));
  }

  static getLocaleType() {
    return _ins.get(_localeType) ?? LocaleType.en;
  }

  static bool isLocaleSelected() {
    return _ins.get(_localeSelected) ?? false;
  }

  static setLocaleSelected() {
    _ins.put(_localeSelected, true);
  }

  static UserType getUserType() {
    return _ins.get(_userType) ?? UserType.noUser;
  }

  static String getFcm() {
    return _ins.get(_fcm) ?? '';
  }

  static String getAuthToken() {
    //before
    //return _ins.get(_authToken) ?? '';
    //after
    return (_ins.get(_authToken)?.toString().isNotEmpty ?? false)
        ? _ins.get(_authToken)
        : 'Bearer ' + guestToken;
  }

  static SubscriptionType getSubscriptionType() {
    return _ins.get(_subscriptionType) ?? SubscriptionType.unSubscribed;
  }

  static setAuthToken(String authToken) {
    _ins.put(_authToken, authToken.isNotEmpty ? 'Bearer $authToken' : '');
  }

  //save username and password for next login with face id
  static setUserCredentials(UserCredentials? userCredentials) {
    _ins.put(_userCredentials, userCredentials);
  }

  static UserCredentials? getUserCredentials() {
    return _ins.get(_userCredentials, defaultValue: null);
  }

  static setLocaleType(LocaleType type) {
    _ins.put(_localeType, type);
  }

  static setFcm(String fcm) {
    _ins.put(_fcm, fcm);
  }

  static setSubscriptionType(SubscriptionType type) {
    _ins.put(_subscriptionType, type);
  }

  static setUserType(UserType type) {
    _ins.put(_userType, type);
  }

  static clearBox() {
    _ins.clear();
  }

  static saveUser(User? user) {
    _ins.put(_userData, user);
  }

  static User? getUser() {
    return _ins.get(_userData, defaultValue: null);
  }
}
