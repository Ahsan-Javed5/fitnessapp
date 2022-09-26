import 'package:fitnessapp/constants/nested_routes_name.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/subscription_type.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/drawer/flutter_zoom_drawer.dart';
import 'package:fitnessapp/screens/signup/sign_up_user.dart';
import 'package:fitnessapp/screens/signup/user/signup_user_menu_page.dart'
    as menu_item;
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:messenger/config/Glob.dart';
import 'package:messenger/controllers/user_controller.dart';

class SignUpUserHomeScreen extends StatefulWidget {
  const SignUpUserHomeScreen({Key? key}) : super(key: key);

  @override
  _SignUpUserHomeScreenState createState() => _SignUpUserHomeScreenState();
}

class _SignUpUserHomeScreenState extends State<SignUpUserHomeScreen> {
  final _drawerController = ZoomDrawerController();
  final int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isRtl = Get.locale?.languageCode == 'ar';
    var widgetMain = MainScreen(callback: () {
      _drawerController.toggle!();
    });

    return ZoomDrawer(
      controller: _drawerController,
      style: DrawerStyle.Style1,
      menuScreen: menu_item.SignUpUserMenuScreen(
        getMenuListing()!,
        callback: _updatePage,
        current: _currentPage,
      ),
      mainScreen: widgetMain,
      showShadow: true,
      mainScreenScale: .5,
      angle: 0.0,
      backgroundColor: Colors.transparent,
      slideWidth:
          MediaQuery.of(context).size.width * (ZoomDrawer.isRTL() ? .45 : 0.75),
      isRtl: isRtl,
      clipMainScreen: true,
    );
  }

  List<menu_item.MenuItem>? getMenuListing() {
    List<menu_item.MenuItem>? menuList;
    menuList = [
      menu_item.MenuItem('log_in', 'assets/svgs/ic_login.svg', 13),
      //menu_item.MenuItem('register', 'assets/svgs/ic_register.svg', 14),
      // menu_item.MenuItem('q_as', 'assets/svgs/ic_qa.svg', 9),
      menu_item.MenuItem('contact_us', 'assets/svgs/ic_contact_us.svg', 15),
      menu_item.MenuItem('about_us', 'assets/svgs/ic_about_us.svg', 10),
      menu_item.MenuItem(
          'terms_conditions', 'assets/svgs/ic_terms_condition.svg', 11),
    ];
    return menuList;
  }

  void _updatePage(index) {
    switch (index) {
      case 9:
        Get.toNamed(Routes.faqs);
        break;

      case 10:
        Get.toNamed(Routes.aboutUs);
        break;

      case 11:
        Get.toNamed(Routes.termsConditions);
        break;

      case 13:
        Get.offAllNamed(Routes.loginScreen);
        break;

      case 14:
        clearDataAndGotoLogin(route: Routes.chooseRole);
        break;

      case 15:
        Get.toNamed(Routes.contactUs);
        break;
    }
    //Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index);
    _drawerController.toggle!();
  }

  void clearDataAndGotoLogin({String route = Routes.loginScreen}) async {
    await UserController.setUserOffline(MyHive.getUser()?.firebaseKey ?? '');
    MyHive.setUserType(UserType.noUser);
    MyHive.setSubscriptionType(SubscriptionType.unSubscribed);
    MyHive.setAuthToken('');
    MyHive.saveUser(null);
    Glob().currentUserKey = '';
    Get.offAllNamed(route);
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback? callback;

  const MainScreen({Key? key, this.callback}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final rtl = ZoomDrawer.isRTL();

    GetPageRoute? onGenerateRoute(RouteSettings settings) {
      switch (settings.name) {
        case NestedRoutesName.signUpUser:
          return GetPageRoute(
            settings: settings,
            page: () => SignUpUser(callback: onClicked),
          );
      }
      return null;
    }

    var _brightnessType = Brightness.light;
    return ValueListenableBuilder<DrawerState>(
      valueListenable: ZoomDrawer.of(context)!.stateNotifier!,
      builder: (context, state, child) {
        //TODO Awais
        if (state == DrawerState.closed) {
          _brightnessType = Brightness.light;
        } else {
          _brightnessType = Brightness.dark;
        }

        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop();
              return false;
            },
            child: GradientBackground(
              includePadding: false,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: null,
                body: Navigator(
                  // key: Get.nestedKey(1), // create a key by index
                  initialRoute: NestedRoutesName.signUpUser,
                  onGenerateRoute: (settings) {
                    return onGenerateRoute(settings);
                  },
                ),
              ),
            )),
        onPanUpdate: (details) {
          if (details.delta.dx > 6 && !rtl || details.delta.dx < -6 && rtl) {
            ZoomDrawer.of(context)!.toggle();
          }
        },
      ),
    );
  }

  void onClicked() {
    widget.callback!();
  }
}

class SignUpUserMenuProvider extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}
