import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/locale_type.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';

class ChooseLanguageController extends GetxController {
  LocaleType selectedLocale = MyHive.getLocaleType();

  updateLocale(LocaleType type) {
    MyHive.setLocaleType(type);
    selectedLocale = MyHive.getLocaleType();
    Get.updateLocale(Utils.getLocaleFromLocaleType(type));
    update();
  }
}
