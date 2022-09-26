import 'package:fitnessapp/constants/nested_routes_name.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/coachProfile/group_container_images_controller.dart';
import 'package:fitnessapp/screens/drawer/flutter_zoom_drawer.dart';
import 'package:fitnessapp/screens/guest/guest_home_screen.dart';
import 'package:fitnessapp/screens/sideMenu/main_menu_page.dart' as menu_item;
import 'package:fitnessapp/user_home_screen.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:fitnessapp/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../coach_home_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  //Controller initialization of free and paid container at coach profile screen
  final matrixController = Get.put(FreePaidContainerMatrixController());

  final _drawerController = ZoomDrawerController();
  final int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isRtl = Get.locale?.languageCode == 'ar';
    var widgetMain = MainScreen(callback: () {
      _drawerController.toggle!();
    });

    // if (DataUtils.videoID.isNotEmpty) {
    //   //Move to the videoDetailScreen
    //   Future.delayed(const Duration(seconds: 2), () {
    //     Map<String, dynamic> arg = {};
    //     arg['videoID'] = DataUtils.videoID;
    //     Routes.to(Routes.videoDetailScreenDeepLinking, arguments: arg);
    //     DataUtils.videoID = ''; //empty video id after moving
    //   });
    // }

    return ZoomDrawer(
      controller: _drawerController,
      style: DrawerStyle.Style1,
      menuScreen: menu_item.MainMenuScreen(
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
    UserType type = MyHive.getUserType();
    List<menu_item.MenuItem>? menuList;
    switch (type) {
      case UserType.guest:
        menuList = [
          menu_item.MenuItem('log_in', 'assets/svgs/ic_login.svg', 13),
          menu_item.MenuItem('register', 'assets/svgs/ic_register.svg', 14),
          // menu_item.MenuItem('q_as', 'assets/svgs/ic_qa.svg', 9),
          menu_item.MenuItem('contact_us', 'assets/svgs/ic_contact_us.svg', 15),
          menu_item.MenuItem('about_us', 'assets/svgs/ic_about_us.svg', 10),
          menu_item.MenuItem(
              'terms_conditions', 'assets/svgs/ic_terms_condition.svg', 11),
        ];
        break;
      case UserType.user:
        menuList = [
          menu_item.MenuItem('home', 'assets/svgs/ic_home.svg', 0),
          menu_item.MenuItem('profile_setting', 'assets/svgs/ic_user.svg', 1),
          menu_item.MenuItem('subscriptions', 'assets/svgs/ic_dollar.svg', 4),
          menu_item.MenuItem('chat', 'assets/svgs/ic_chat.svg', 5),
          menu_item.MenuItem(
              'contact_admin', 'assets/svgs/ic_contact_admin.svg', 7),
          menu_item.MenuItem(
              'payment_history', 'assets/svgs/ic_pay_history.svg', 8),
          // menu_item.MenuItem('q_as', 'assets/svgs/ic_qa.svg', 9),
          menu_item.MenuItem('about_us', 'assets/svgs/ic_about_us.svg', 10),
          menu_item.MenuItem(
              'terms_conditions', 'assets/svgs/ic_terms_condition.svg', 11),
          menu_item.MenuItem('logout', 'assets/svgs/ic_logout.svg', 12),
        ];
        break;
      case UserType.coach:
        menuList = [
          menu_item.MenuItem('home', 'assets/svgs/ic_home.svg', 0),
          menu_item.MenuItem('profile_setting', 'assets/svgs/ic_user.svg', 1),
          menu_item.MenuItem(
              'my_video_library', 'assets/svgs/ic_video_lib.svg', 2),
          menu_item.MenuItem('groups', 'assets/svgs/ic_groups.svg', 3),
          if (!Utils.isUserAdmin())
            menu_item.MenuItem(
                'contact_admin', 'assets/svgs/ic_contact_admin.svg', 7),
          menu_item.MenuItem('subscriptions', 'assets/svgs/ic_dollar.svg', 4),
          menu_item.MenuItem('chat', 'assets/svgs/ic_chat.svg', 5),
          menu_item.MenuItem(
              'monthly_statements', 'assets/svgs/ic_pay_history.svg', 6),
          // menu_item.MenuItem('q_as', 'assets/svgs/ic_qa.svg', 9),
          menu_item.MenuItem('about_us', 'assets/svgs/ic_about_us.svg', 10),
          menu_item.MenuItem(
              'terms_conditions', 'assets/svgs/ic_terms_condition.svg', 11),
          menu_item.MenuItem('logout', 'assets/svgs/ic_logout.svg', 12),
        ];
        break;
      case UserType.noUser:
        break;
    }
    return menuList;
  }

  void _updatePage(index) {
    bool isCoach = MyHive.getUserType() == UserType.coach;
    switch (index) {
      case 0:
        //Get.offAllNamed(Routes.home);
        break;
      case 1:
        if (isCoach) {
          Get.toNamed(Routes.coachOwnProfile);
        } else {
          Get.toNamed(Routes.userOwnProfile);
        }
        break;
      case 2:
        if (isCoach) Get.toNamed(Routes.privateVideoLibrary);
        break;
      case 3:
        if (isCoach) Get.toNamed(Routes.freeAndPaidGroupsScreen);
        break;
      case 4:
        if (isCoach) {
          Get.toNamed(Routes.subscription);
        } else {
          Get.toNamed(Routes.subscription);
        }
        break;
      case 5:
        Get.toNamed(Routes.chatMainScreen);
        break;
      case 6:
        if (isCoach) {
          Get.toNamed(Routes.monthlyStatementsScreen);
        } else {
          Get.toNamed(Routes.monthlyStatementsScreen);
        }
        break;
      case 7:
        Utils.open1to1Chat(MyHive.getUser()?.firebaseKey ?? '',
            MyHive.adminFBEntityKey, context);
        break;
      case 8:
        Get.toNamed(Routes.paymentHistory);
        break;
      case 9:
        Get.toNamed(Routes.faqs);
        break;
      case 10:
        Get.toNamed(Routes.aboutUs);
        break;
      case 11:
        Get.toNamed(Routes.termsConditions);
        break;
      case 12:
        matrixController.logoutUser();
        break;
      case 13:
        matrixController.logoutUser();
        break;
      case 14:
        matrixController.logoutUser();
        break;
      case 15:
        Get.toNamed(Routes.contactUs);
        break;
    }
    _drawerController.toggle!();
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
        case NestedRoutesName.userHomePage:
          return GetPageRoute(
            settings: settings,
            page: () => UserHomeScreen(callback: onClicked),
          );

        case NestedRoutesName.coachHomePage:
          return GetPageRoute(
            settings: settings,
            page: () => CoachHomeScreen(callback: onClicked),
          );

        case NestedRoutesName.guestHome:
          return GetPageRoute(
            settings: settings,
            page: () => GuestHomeScreen(callback: onClicked),
          );
      }
      return null;
    }

    return ValueListenableBuilder<DrawerState>(
      valueListenable: ZoomDrawer.of(context)!.stateNotifier!,
      builder: (context, state, child) {
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: WillPopScope(
            onWillPop: () async {
              Get.back();
              return true;
            },
            child: GradientBackground(
              includePadding: false,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: null,
                body: Navigator(
                  initialRoute: NestedRoutesName.getInitialRoute(),
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

class MenuProviderUser extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}
