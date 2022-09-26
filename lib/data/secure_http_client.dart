import 'package:dio/dio.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class MySecureHttpClient {
  static Dio? secureClient;
  static Dio? insecureClient;
  static String sha1 =
      '00 CE AE E4 FB 39 D4 A8 B2 81 22 CC 3F 8B 54 5A C7 A2 FA EC';
  static String sha256 =
      'D5 9B 23 DC 54 23 B8 1D EA 8A 27 C9 04 81 F9 B3 16 23 85 BB 85 B8 42 E1 01 F9 0F B2 35 25 34 22';

  static Dio getClient() {
    secureClient ??= Dio(BaseOptions(baseUrl: Routes.baseUrl))
      ..interceptors.add(CertificatePinningInterceptor(
        allowedSHAFingerprints: [sha256],
        timeout: 10,
      ));
    secureClient!.options.headers['authorization'] = MyHive.getAuthToken();
    return secureClient!;
  }

  static Dio getInsecureClient() {
    insecureClient = Dio(BaseOptions(baseUrl: Routes.baseUrl));
    insecureClient!.options.headers['authorization'] = MyHive.getAuthToken();
    return insecureClient!;
  }
}
