import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fitnessapp/config/app_state_observer.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/currency_model.dart';
import 'package:fitnessapp/models/enums/locale_type.dart';
import 'package:fitnessapp/models/enums/subscription_type.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/screens/chat/chat_view_screen.dart';
import 'package:fitnessapp/screens/sideMenu/main_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:messenger/config/Glob.dart';
import 'package:messenger/controllers/threads_controller.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/Availability.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';

class Utils {
  ///user currency name and rate against USD
  static CurrencyModel? currencyModel;

  static String lastErrorMessage = '';

  static Locale getLocaleFromLocaleType(LocaleType type) {
    if (type == LocaleType.en) {
      return const Locale('en', 'US');
    } else {
      return const Locale('ar', 'SA');
    }
  }

  static Future<File> changeFileNameOnly(File file, String newFileName) async {
    //var path = file.path;
    //var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath =
        (await getApplicationDocumentsDirectory()).path + '/' + newFileName;
    return await File(file.path).copy(newPath);
  }

  static bool isUserAdmin() {
    return (MyHive.getUser()?.firebaseKey ?? '') == MyHive.adminFBEntityKey;
  }

  static String userTypeValue(UserType type) {
    switch (type) {
      case UserType.guest:
        return 'Guest';
      case UserType.coach:
        return 'Coach';
      case UserType.user:
        return 'User';
      case UserType.noUser:
        return 'noUser';
    }
  }

  static UserType userTypeKey(String? type) {
    switch (type) {
      case 'Guest':
        return UserType.guest;
      case 'Coach':
        return UserType.coach;
      case 'Admin':
        return UserType.coach;
      case 'User':
        return UserType.user;
      case 'noUser':
        return UserType.noUser;
      default:
        return UserType.noUser;
    }
  }

  static bool isRTL() {
    return Get.locale?.languageCode == 'ar';
  }

  static String getUserAvailabilityStatus(User user) {
    String availabilityStatus = Availability.Available;

    if ((user.isArchived ?? false) || !(user.isVerified ?? false)) {
      availabilityStatus = Availability.Disabled;
    } else if (MyHive.getUserType() == UserType.coach &&
        !(user.allowPrivateChat!)) {
      availabilityStatus = Availability.Away;
    } else if (!(user.isArchived ?? false)) {
      availabilityStatus = Availability.Available;
    }

    return availabilityStatus;
  }

  static bool isSubscribedUser() {
    return MyHive.getSubscriptionType() == SubscriptionType.subscribed &&
        MyHive.getUserType() == UserType.user;
  }

  static bool isSubscribedCoach() {
    return MyHive.getSubscriptionType() == SubscriptionType.subscribed &&
        MyHive.getUserType() == UserType.coach;
  }

  static bool isUnSubscribedUser() {
    return MyHive.getSubscriptionType() == SubscriptionType.unSubscribed &&
        MyHive.getUserType() == UserType.user;
  }

  static bool isUnSubscribedCoach() {
    return MyHive.getSubscriptionType() == SubscriptionType.unSubscribed &&
        MyHive.getUserType() == UserType.coach;
  }

  static bool isUser() {
    return MyHive.getUserType() == UserType.user;
  }

  static bool isGuest() {
    return MyHive.getUserType() == UserType.guest;
  }

  static bool isCoach() {
    return MyHive.getUserType() == UserType.coach;
  }

  static String formatDateTime(String timestamp,
      {String format = 'dd MMM, yyyy'}) {
    var lc = Get.locale?.languageCode;
    if (timestamp.isEmpty) return '';
    final formattedTimestamp = DateTime.parse(timestamp);

    return DateFormat(format, lc).format(formattedTimestamp);
  }

  static String getMonthNameFromDate(String timestamp,
      {String format = 'MMMM'}) {
    if (timestamp.isEmpty) return '';
    final formattedTimestamp = DateTime.parse(timestamp);
    return DateFormat(format).format(formattedTimestamp);
  }

  static Future<File?> uInt8ListToTempImageFile(Uint8List image) async {
    File? thumbnailFile;
    try {
      final tempDir = await getTemporaryDirectory();
      thumbnailFile = await File('${tempDir.path}/image.jpg').create();
      thumbnailFile.writeAsBytesSync(image);
    } catch (_) {}

    return thumbnailFile;
  }

  static getThumbnailFromVideoFile(String filePath) async {
    return await VideoCompress.getByteThumbnail(
      filePath,
      quality: 100,
      position: -1,
    );
  }

  /// This method is used to get the id of a object when we give the value of the object
  /// for example if we provide List<Country> and v is 'Qatar' then it will return the
  /// id of the Qatar country in the list of countries
  /// Pseudo code
  /// Get List<Objects>
  /// Convert into Map<k,v> where key will be the name and value will be the id
  /// [localizedCheck] if set to true will check arabic and English strings
  /// otherwise it will only check for English name
  static String getIdOfValue(List<dynamic> l, String v,
      {bool localizedCheck = false}) {
    var map = localizedCheck
        ? {for (var v in l) v.localizedName: v.id}
        : {for (var v in l) v.name: v.id};
    return map[v].toString();
  }

  static void showSnack(String title, String msg, {bool isError = false}) {
    Get.closeAllSnackbars();
    String filteredMessage = (msg.toLowerCase().contains('timeout') ||
            msg.toLowerCase().contains('socket'))
        ? 'Please check your internet'
        : msg.tr;
    log(filteredMessage.toString());
    EasyDebounce.debounce('snackBar', 600.milliseconds, () {
      Get.snackbar(
        title.tr,
        filteredMessage,
        isDismissible: true,
        backgroundColor: isError
            ? ColorConstants.redButtonBackground
            : ColorConstants.appBlue,
        colorText: ColorConstants.whiteColor,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
    });
  }

  static Route createRoute(Widget screenToRoute) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screenToRoute,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static void navigateToNextScreen(BuildContext context, Widget widget) {
    Navigator.of(context).push(createRoute(widget));
  }

  static Future<void> open1to1Chat(
      String currentUser, String targetUser, BuildContext context,
      {Map<String, dynamic>? arguments}) async {
    await ThreadsController.fetchOrCreatePrivate1to1Thread(
      currentUser,
      targetUser,
    ).then((value) {
      if (value == null) return;

      if (value.isError) {
        showSnack('Error', value.message, isError: true);
        return;
      }
      final currentRoute = Get.currentRoute;

      /// If currentRoute is empty that means Chat screen is already opened
      /// first pop that and open new screen to avoid multiple instance of chat
      /// currentRoute will be empty because chat screens are pushed using different navigator
      if (currentRoute.isEmpty) {
        Navigator.pop(context);
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            maintainState: false,
            builder: (context) => ChatViewScreen(
              currentUserId: currentUser,
              thread: value,
              position: -1,
              arguments: arguments,
            ),
          ),
        )
            .then(
          (value) {
            //this will be called when user will come back from
            //chat view screen
          },
        );
      } else {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            maintainState: false,
            builder: (context) => ChatViewScreen(
              currentUserId: currentUser,
              thread: value,
              position: -1,
              arguments: arguments,
            ),
          ),
        )
            .then(
          (value) {
            //this will be called when user will come back from
            //chat view screen
          },
        );
      }
    });
  }

  //Pass video ID and this fun will return the firebase dynamic link short URL
  static Future<String> getDynamicLink(
      String id, String workoutType, String navigationKey) async {
    //program workout type
    String pwt = getReplaceSymbol(workoutType, '&', 'REMOVE');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://fitandmorevideo.page.link',
      link: Uri.parse(
          'https://www.codesorbit.com/?id=$id&workoutType=$pwt&nav_key=$navigationKey'),
      androidParameters: AndroidParameters(
        packageName: 'com.fitandmoreapp',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.fitandmoreapp',
        appStoreId: '123456789',
        minimumVersion: '1',
      ),
    );
    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }

  static String getReplaceSymbol(
      String toDoString, String fromReplace, String toReplace) {
    String defaultValue = toDoString.replaceAll(fromReplace, toReplace);
    return defaultValue;
  }

  static void backUntil({String untilRoute = Routes.home}) {
    Get.until((route) =>
        (Get.currentRoute == untilRoute) && !(Get.isDialogOpen ?? false));
  }

  static final Map<String, String> countryCurrencyMap = {
    'AED': 'United Arab Emirates, UAE',
    'AFN': 'Afghanistan',
    'ALL': 'Albania',
    'AMD': 'Armenia',
    'ANG': 'Netherlands Antilles',
    'AOA': 'Angola',
    'ARS': 'Argentina',
    'AUD':
        'Australia, Australian Antarctic Territory, Christmas Island, Cocos (Keeling) Islands, Heard and McDonald Islands, Kiribati, Nauru, Norfolk Island, Tuvalu',
    'AWG': 'Aruba',
    'AZN': 'Azerbaijan',
    'BAM': 'Bosnia and Herzegovina',
    'BBD': 'Barbados',
    'BDT': 'Bangladesh',
    'BGN': 'Bulgaria',
    'BHD': 'Bahrain',
    'BIF': 'Burundi',
    'BMD': 'Bermuda',
    'BND': 'Brunei',
    'BOB': 'Bolivia',
    'BOV': 'Bolivia',
    'BRL': 'Brazil',
    'BSD': 'Bahamas',
    'BTN': 'Bhutan',
    'BWP': 'Botswana',
    'BYR': 'Belarus',
    'BZD': 'Belize',
    'CAD': 'Canada',
    'CDF': 'Democratic Republic of Congo',
    'CHE': 'Switzerland',
    'CHF': 'Switzerland, Liechtenstein',
    'CHW': 'Switzerland',
    'CLF': 'Chile',
    'CLP': 'Chile',
    'CNY': 'Mainland China',
    'COP': 'Colombia',
    'COU': 'Colombia',
    'CRC': 'Costa Rica',
    'CUP': 'Cuba',
    'CVE': 'Cape Verde',
    'CYP': 'Cyprus',
    'CZK': 'Czech Republic',
    'DJF': 'Djibouti',
    'DKK': 'Denmark, Faroe Islands, Greenland',
    'DOP': 'Dominican Republic',
    'DZD': 'Algeria',
    'EEK': 'Estonia',
    'EGP': 'Egypt',
    'ERN': 'Eritrea',
    'ETB': 'Ethiopia',
    'EUR': 'European Union, see eurozone',
    'FJD': 'Fiji',
    'FKP': 'Falkland Islands',
    'GBP': 'United Kingdom',
    'GEL': 'Georgia',
    'GHS': 'Ghana',
    'GIP': 'Gibraltar',
    'GMD': 'Gambia',
    'GNF': 'Guinea',
    'GTQ': 'Guatemala',
    'GYD': 'Guyana',
    'HKD': 'Hong Kong Special Administrative Region',
    'HNL': 'Honduras',
    'HRK': 'Croatia',
    'HTG': 'Haiti',
    'HUF': 'Hungary',
    'IDR': 'Indonesia',
    'ILS': 'Israel',
    'INR': 'Bhutan, India',
    'IQD': 'Iraq',
    'IRR': 'Iran',
    'ISK': 'Iceland',
    'JMD': 'Jamaica',
    'JOD': 'Jordan',
    'JPY': 'Japan',
    'KES': 'Kenya',
    'KGS': 'Kyrgyzstan',
    'KHR': 'Cambodia',
    'KMF': 'Comoros',
    'KPW': 'North Korea',
    'KRW': 'South Korea',
    'KWD': 'Kuwait',
    'KYD': 'Cayman Islands',
    'KZT': 'Kazakhstan',
    'LAK': 'Laos',
    'LBP': 'Lebanon',
    'LKR': 'Sri Lanka',
    'LRD': 'Liberia',
    'LSL': 'Lesotho',
    'LTL': 'Lithuania',
    'LVL': 'Latvia',
    'LYD': 'Libya',
    'MAD': 'Morocco, Western Sahara',
    'MDL': 'Moldova',
    'MGA': 'Madagascar',
    'MKD': 'Former Yugoslav Republic of Macedonia',
    'MMK': 'Myanmar',
    'MNT': 'Mongolia',
    'MOP': 'Macau Special Administrative Region',
    'MRO': 'Mauritania',
    'MTL': 'Malta',
    'MUR': 'Mauritius',
    'MVR': 'Maldives',
    'MWK': 'Malawi',
    'MXN': 'Mexico',
    'MXV': 'Mexico',
    'MYR': 'Malaysia',
    'MZN': 'Mozambique',
    'NAD': 'Namibia',
    'NGN': 'Nigeria',
    'NIO': 'Nicaragua',
    'NOK': 'Norway',
    'NPR': 'Nepal',
    'NZD': 'Cook Islands, New Zealand, Niue, Pitcairn, Tokelau',
    'OMR': 'Oman',
    'PAB': 'Panama',
    'PEN': 'Peru',
    'PGK': 'Papua New Guinea',
    'PHP': 'Philippines',
    'PKR': 'Pakistan',
    'PLN': 'Poland',
    'PYG': 'Paraguay',
    'QAR': 'Qatar',
    'RON': 'Romania',
    'RSD': 'Serbia',
    'RUB': 'Russia, Abkhazia, South Ossetia',
    'RWF': 'Rwanda',
    'SAR': 'Saudi Arabia',
    'SBD': 'Solomon Islands',
    'SCR': 'Seychelles',
    'SDG': 'Sudan',
    'SEK': 'Sweden',
    'SGD': 'Singapore',
    'SHP': 'Saint Helena',
    'SKK': 'Slovakia',
    'SLL': 'Sierra Leone',
    'SOS': 'Somalia',
    'SRD': 'Suriname',
    'STD': 'São Tomé and Príncipe',
    'SYP': 'Syria',
    'SZL': 'Swaziland',
    'THB': 'Thailand',
    'TJS': 'Tajikistan',
    'TMM': 'Turkmenistan',
    'TND': 'Tunisia',
    'TOP': 'Tonga',
    'TRY': 'Turkey',
    'TTD': 'Trinidad and Tobago',
    'TWD':
        'Taiwan and other islands that are under the effective control of the Republic of China (ROC)',
    'TZS': 'Tanzania',
    'UAH': 'Ukraine',
    'UGX': 'Uganda',
    'USD':
        'American Samoa, British Indian Ocean Territory, Ecuador, El Salvador, Guam, Haiti, Marshall Islands, Micronesia, Northern Mariana Islands, Palau, Panama, Puerto Rico, East Timor, Turks and Caicos Islands, United States, Virgin Islands',
    'USN': 'United States',
    'USS': 'United States',
    'UYU': 'Uruguay',
    'UZS': 'Uzbekistan',
    'VEB': 'Venezuela',
    'VND': 'Vietnam',
    'VUV': 'Vanuatu',
    'WST': 'Samoa',
    'XAF':
        'Cameroon, Central African Republic, Congo, Chad, Equatorial Guinea, Gabon',
    'XAG': '',
    'XAU': '',
    'XBA': '',
    'XBB': '',
    'XBC': '',
    'XBD': '',
    'XCD':
        'Anguilla, Antigua and Barbuda, Dominica, Grenada, Montserrat, Saint Kitts and Nevis, Saint Lucia, Saint Vincent and the Grenadines',
    'XDR': 'International Monetary Fund',
    'XFO': 'Bank for International Settlements',
    'XFU': 'International Union of Railways',
    'XOF':
        "Benin, Burkina Faso, Côte d'Ivoire, Guinea-Bissau, Mali, Niger, Senegal, Togo",
    'XPD': '',
    'XPF': 'French Polynesia, New Caledonia, Wallis and Futuna',
    'XPT': '',
    'XTS': '',
    'XXX': '',
    'YER': 'Yemen',
    'ZAR': 'South Africa',
    'ZMK': 'Zambia',
    'ZWD': 'Zimbabwe'
  };

  static String getCurrencyCodeFromCountry(String countryName) {
    final keys = countryCurrencyMap.keys;

    for (String s in keys) {
      if (countryCurrencyMap[s]!
          .toLowerCase()
          .contains(countryName.toLowerCase().trim())) {
        return s;
      }
    }
    return '';
  }

  static clearDataAndGotoLogin({String route = Routes.loginScreen}) async {
    UserController.setUserOffline(MyHive.getUser()?.firebaseKey ?? '',
        removeFcm: true);
    MyHive.setUserType(UserType.noUser);
    MyHive.setSubscriptionType(SubscriptionType.unSubscribed);
    MyHive.setAuthToken('');
    MyHive.saveUser(null);
    Glob().currentUserKey = '';
    try {
      Get.find<MainMenuController>().closeObservers();
      Get.find<AppStateObserver>().unsubscribeUserListener();
    } catch (e) {
      e.printError();
    }
    Get.offAllNamed(route);
  }

  static void openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
      );
    }
  }

  static void copyToClipBoard(String? msg) {
    Clipboard.setData(ClipboardData(text: msg));
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static void requestPermission() async {
    PermissionStatus mic = await Permission.microphone.status;
    PermissionStatus sto = await Permission.storage.status;
    PermissionStatus acMedia = await Permission.accessMediaLocation.status;
    PermissionStatus iosPhoto = await Permission.photos.status;
    if (mic.isDenied && sto.isDenied) {
      await [
        Permission.microphone,
        Permission.storage,
      ].request();
    } else if (mic.isDenied) {
      await Permission.microphone.request();
    } else if (sto.isDenied) {
      await Permission.storage.request();
    } else if (acMedia.isDenied) {
      await Permission.accessMediaLocation.request();
    }

    if (Platform.isIOS && iosPhoto.isDenied) {
      await Permission.photos.request();
    }
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
