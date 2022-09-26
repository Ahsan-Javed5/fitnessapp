import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnessapp/config/app_state_observer.dart';
import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/screens/coachProfile/video_list_controller.dart';
import 'package:fitnessapp/screens/video_player_controller.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/localization/form_builder_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:messenger/config/Glob.dart';
import 'package:messenger/model/providers/ThreadUserLinksProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'config/push_notification_service.dart';
import 'config/theme_data.dart';
import 'lang/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  await MyHive.init();
  await setupInteractedMessage();
  initDynamicLinks();
  Glob.initMessenger(
    MyHive.getUser()?.firebaseKey?.toString() ?? '',
    MyHive.getUser()?.firebaseJWT?.toString() ?? '',
  );
  Get.put(AppStateObserver());
  if (!kDebugMode) debugPrint = (String? message, {int? wrapWidth}) {};
  runApp(const MyApp());
}

void initDynamicLinks() async {
  final PendingDynamicLinkData? data =
      await FirebaseDynamicLinks.instance.getInitialLink();
  final Uri? deepLink = data?.link;
  if (deepLink != null) {
    //Set video ID globally that we will use at home screen for video detail showing
    //DataUtils.videoID = videoID!;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (deepLink.queryParameters.containsKey('id')) {
        String? videoID = deepLink.queryParameters['id'];
        String? workoutType = deepLink.queryParameters['workoutType'];
        String? navKey = deepLink.queryParameters['nav_key'];
        DataUtils.videoID = videoID!;
        final videoController = Get.put(VideoListController());
        String pwt = Utils.getReplaceSymbol(workoutType ?? '', 'REMOVE', '&');
        videoController.workoutProgramTypeString = pwt;
        videoController.navigationString = navKey;

        //Particularly for Guest users
        if (DataUtils.videoID.isNotEmpty) {
          //Move to the videoDetailScreen
          Future.delayed(const Duration(seconds: 2), () {
            Map<String, dynamic> arg = {};
            arg['videoID'] = DataUtils.videoID;
            Routes.to(Routes.videoDetailScreenDeepLinking, arguments: arg);
            DataUtils.videoID = ''; //empty video id after moving
          });
        }
      }
    });
  }
  FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink) async {
        Future.delayed(const Duration(milliseconds: 1000), () {
          final Uri? deepLink = dynamicLink?.link;
          if (deepLink != null) {
            if (deepLink.queryParameters.containsKey('id')) {
              String? videoID = deepLink.queryParameters['id'];
              String? workoutType = deepLink.queryParameters['workoutType'];
              String? navKey = deepLink.queryParameters['nav_key'];
              final videoController = Get.put(VideoListController());
              String pwt =
                  Utils.getReplaceSymbol(workoutType ?? '', 'REMOVE', '&');
              videoController.workoutProgramTypeString = pwt;
              videoController.navigationString = navKey;
              //Set video ID globally that we will use at home screen for video detail showing
              //DataUtils.videoID = videoID!;
              Future.delayed(const Duration(milliseconds: 1000), () {
                Map<String, dynamic> arg = {};
                arg['videoID'] = videoID;
                Routes.to(Routes.videoDetailScreenDeepLinking, arguments: arg);
                //DataUtils.videoID = '';
              });
            }
          }
        });
      },
      onError: (OnLinkErrorException e) async {});
}

// It is assumed that all messages contain a data field with the key 'type'
Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => VideoPlayerController());
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();

    /// Status bar background and data color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ));

    /// Using Sizer for asset scaling based on screen size and density
    return Sizer(
      builder: (context, orientation, deviceType) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThreadUserLinksProvider(Glob().currentUserKey ?? ''),
            lazy: false,
          ),
        ],
        child: GetMaterialApp(
          /// Material app builder to keep the scaling of the font consistent
          /// Font will not be affected by the device font settings
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },

          /// Locale Management
          locale: TranslationService.locale,
          fallbackLocale: TranslationService.fallbackLocale,
          translations: TranslationService(),
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],

          /// Route Management
          // home: RecorderView(),
          unknownRoute: Routes.getUnknownRoute(),
          initialRoute: Routes.getInitialRoute(),
          getPages: Routes.getPages(),

          /// Material App Management
          title: 'app_name'.tr,
          debugShowCheckedModeBanner: false,
          theme: getAppThemeData(),
        ),
      ),
    );
  }
}
