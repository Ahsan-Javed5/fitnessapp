import 'package:fitnessapp/data/local/my_hive.dart';

class ViewUtils {
  static String getSasUrl(String url) {
    if (!url.contains(MyHive.sasKey)) {
      url = '$url${MyHive.sasKey}';
      return url;
    } else {
      return url;
    }
  }
}
