import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/screens/about_us.dart';
import 'package:fitnessapp/screens/addEditGroup/add_group.dart';
import 'package:fitnessapp/screens/addEditGroup/edit_main_group_screen.dart';
import 'package:fitnessapp/screens/addEditGroup/edit_sub_group.dart';
import 'package:fitnessapp/screens/addEditGroup/select_video_screen.dart';
import 'package:fitnessapp/screens/chat/thread_view_screen.dart';
import 'package:fitnessapp/screens/chooseRole/choose_role.dart';
import 'package:fitnessapp/screens/coachProfile/coachOwnProfile/coach_own_profile.dart';
import 'package:fitnessapp/screens/coachProfile/coach_profile.dart';
import 'package:fitnessapp/screens/coachProfile/report_video_page.dart';
import 'package:fitnessapp/screens/coachProfile/videoDetail/video_detail_screen.dart';
import 'package:fitnessapp/screens/coachProfile/videoDetail/video_detail_screen_deep_linking.dart';
import 'package:fitnessapp/screens/coachProfile/workout_free_main_groups_screen.dart';
import 'package:fitnessapp/screens/coachProfile/workout_groups_screen.dart';
import 'package:fitnessapp/screens/coachProfile/workout_main_groups_screen.dart';
import 'package:fitnessapp/screens/coachProfile/workout_sub_groups_screen.dart';
import 'package:fitnessapp/screens/contactUs/contact_us.dart';
import 'package:fitnessapp/screens/faqs/ask_question_page.dart';
import 'package:fitnessapp/screens/faqs/frequently_asked_question.dart';
import 'package:fitnessapp/screens/freePaidGroups/add_video_page.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_and_paid_groups.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_paid_main_group_screen.dart';
import 'package:fitnessapp/screens/freePaidGroups/free_paid_sub_group_screen.dart';
import 'package:fitnessapp/screens/guest/filter_screen.dart';
import 'package:fitnessapp/screens/guest/workout_for_screen.dart';
import 'package:fitnessapp/screens/home/main_home_screen.dart';
import 'package:fitnessapp/screens/langSelection/choose_language.dart';
import 'package:fitnessapp/screens/login/forget_password_username_screen.dart';
import 'package:fitnessapp/screens/login/forgot_password_screen.dart';
import 'package:fitnessapp/screens/login/login_side_menu_home_screen.dart';
import 'package:fitnessapp/screens/monthlyStatements/date_range_filter_page.dart';
import 'package:fitnessapp/screens/monthlyStatements/monthly_statement.dart';
import 'package:fitnessapp/screens/onBoarding/on_boarding_screen.dart';
import 'package:fitnessapp/screens/paymentHistory/payment_history_screen.dart';
import 'package:fitnessapp/screens/profileSetup/profile_setup_screen.dart';
import 'package:fitnessapp/screens/profileSetup/upload_intro_video_screen.dart';
import 'package:fitnessapp/screens/resetPassword/reset_password.dart';
import 'package:fitnessapp/screens/search/search_screen.dart';
import 'package:fitnessapp/screens/seeMoreCoaches/see_more_coaches.dart';
import 'package:fitnessapp/screens/signup/coach/signup_coach_side_menu_home_screen.dart';
import 'package:fitnessapp/screens/signup/code_verification_screen.dart';
import 'package:fitnessapp/screens/signup/set_password_screen.dart';
import 'package:fitnessapp/screens/signup/user/signup_user_side_menu_home_screen.dart';
import 'package:fitnessapp/screens/signup/welcome_screen.dart';
import 'package:fitnessapp/screens/subscriptions/subscription_view_pager.dart';
import 'package:fitnessapp/screens/termsCondition/terms_and_conditions.dart';
import 'package:fitnessapp/screens/unknown_route.dart';
import 'package:fitnessapp/screens/userProfile/user_own_profile.dart';
import 'package:fitnessapp/screens/videoLibrary/add_multiple_private_videos_page.dart';
import 'package:fitnessapp/screens/videoLibrary/add_private_group_page.dart';
import 'package:fitnessapp/screens/videoLibrary/add_private_video_page.dart';
import 'package:fitnessapp/screens/videoLibrary/my_videos_library.dart';
import 'package:fitnessapp/screens/videoLibrary/private_group_video_view.dart';
import 'package:fitnessapp/screens/videoLibrary/private_video_library.dart';
import 'package:fitnessapp/screens/videoLibrary/send_video_to_active_users.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Routes {
  //App ase URL
  // static const String baseUrl = 'https://814b-115-186-141-41.ngrok.io/';
  // static const String baseUrl = 'https://backend-fitness.codesorbit.net/';
  static const String baseUrl = 'https://api.fitandmore.app/';
  // static const String baseUrl = 'https://devfitandmoreapi.azurewebsites.net/';
  static const String storagePath = '/storage/emulated/0/DCIM/Fitness';
  static const String noPageFound = '/noPageFound';
  static const String chooseRole = '/chooseRole';
  static const String loginScreen = '/loginScreen';
  static const String signUpUser = '/signUpUser';
  static const String signUpCoach = '/signUpCoach';
  static const String home = '/userHome';
  static const String aboutUs = '/aboutUs';
  static const String contactUs = '/contactUs';
  static const String coachProfile = '/coachProfile';
  static const String forgotPassword = '/forgotPassword';
  static const String forgotPasswordUserName = '/forgotPasswordUserName';
  static const String termsConditions = '/termsConditions';
  static const String chooseLanguage = '/chooseLanguage';
  static const String filterScreen = '/filterScreen';
  static const String codeVerification = '/codeVerification';
  static const String setPasswordScreen = '/setPasswordScreen';
  static const String welcomeScreen = '/welcomeScreen';
  static const String coachOwnProfile = '/coachOwnProfile';
  static const String dateRangeFilterPage = '/dateRangeFilter';
  static const String seeMoreCoaches = '/seeMoreCoaches';
  static const String monthlyStatementsScreen = '/monthlyStatementScreen';
  static const String resetPasswordScreen = '/resetPasswordScreen';
  static const String addGroupPage = '/addEditGroup';
  static const String askQuestionPage = '/askQuestion';
  static const String faqs = '/faqs';
  static const String userOwnProfile = '/userOwnProfile';
  static const String paymentHistory = '/paymentHistory';
  static const String reportVideoPage = '/reportVideoPage';
  static const String editSubGroupPage = '/editSubGroup';
  static const String searchScreen = '/searchScreen';
  static const String videoPlayerScreen = '/videoPlayerScreen';
  static const String addPrivateGroupScreen = '/addPrivateGroup';
  static const String addPrivateVideoScreen = '/addPrivateVideoPage';
  static const String addMultiplePrivateVideosScreen =
      '/addMultiplePrivateVideosPage';
  static const String editMainGroupScreen = '/editMainGroup';

  /// Chat module screens
  static const String chatMainScreen = '/chatMainScreen';

  /// Workout plans tree of a coach
  static const String workoutGroupScreen = '/workoutGroupScreen';
  static const String workoutMainGroupScreen = '/workoutMainGroupScreen';
  static const String workoutSubGroupScreen = '/workoutSubGroupScreen';
  static const String videoDetailScreen = '/videoDetailsScreen';
  static const String workoutFreeMainGroupScreen =
      '/workoutFreeMainGroupScreen';
  static const String videoDetailScreenDeepLinking =
      '/videoDetailsScreenDeepLinking';

  /// Free and Paid Groups Screen tree with tab controller
  static const String freeAndPaidGroupsScreen = '/freePaidGroups';
  static const String freePaidMainGroupScreen = '/freePaidMainGroupView';
  static const String freePaidSubGroupScreen = '/freePaidSubGroupView';

  /// Profile set up
  static const String profileSetupScreen = '/profileSetup';
  static const String bankAccountDetailsPage = '/bankDetails';
  static const String uploadDocumentPage = '/uploadDocument';
  static const String contract = '/contract';
  static const String subscription = '/subscription';
  static const String uploadIntroVideo = '/uploadIntroVideo';

  /// Videos Screens
  /// Shows a list of group and a route to go to video library
  static const String privateVideoLibrary = '/privateVideoLibrary';
  static const String selectVideoScreen = '/selectVideoScreen';

  /// Shows a list of private videos and option to add more videos
  static const String myVideoLibrary = '/myVideoLibrary';
  static const String addVideoPage = '/addVideoPage';
  static const String privateGroupVideoView = '/mainGroupVideoView';
  static const String sendVideoToActiveUsers = '/SendVideoToActiveUsers';

  static const String workoutFor = '/workoutFor';
  static const String onBoardingScreen = '/onBoardingScreen';

  static const String fullPhoto = '/onBoardingScreen';

  static getUnknownRoute() {
    return GetPage(
      name: noPageFound,
      page: () => const UnknownRoutePage(),
      transition: Transition.zoom,
    );
  }

  static getInitialRoute() {
    if (MyHive.getUserType() != UserType.noUser) {
      final user = MyHive.getUser();

      /// If user type is coach and if his bank details are empty then
      /// take the user to the bank details screen instead of the home screen
      if (user != null &&
          user.userType == 'Coach' &&
          (user.bankDetails == null ||
              user.bankDetails!.subscriptionPrice == null)) {
        return profileSetupScreen;
      } else if (MyHive.getUserType() == UserType.guest) {
        MyHive.setAuthToken(MyHive.guestToken);
      }
      return home;
    } else {
      if (MyHive.isLocaleSelected()) {
        return loginScreen;
      } else {
        return chooseLanguage;
      }
    }
  }

  static getPages() {
    return [
      GetPage(
        name: noPageFound,
        page: () => const UnknownRoutePage(),
      ),
      GetPage(
        name: reportVideoPage,
        page: () => const ReportVideoPage(),
      ),
      GetPage(
        name: chooseRole,
        page: () => const ChooseRole(),
      ),
      GetPage(
        name: userOwnProfile,
        page: () => UserOwnProfile(),
      ),
      GetPage(
        name: loginScreen,
        page: () => ChangeNotifierProvider(
          create: (_) => LoginMenuProvider(),
          child: const LoginHomeScreen(),
        ),
        preventDuplicates: true,
        maintainState: true,
      ),
      GetPage(
        name: selectVideoScreen,
        page: () => const SelectVideoScreen(),
      ),
      GetPage(
        name: forgotPassword,
        page: () => ForgotPasswordScreen(),
      ),
      GetPage(
        name: editSubGroupPage,
        page: () => EditSubGroup(),
      ),
      GetPage(
        name: editMainGroupScreen,
        page: () => EditMainGroupScreen(),
      ),
      GetPage(
        name: seeMoreCoaches,
        page: () => const SeeMoreCoaches(),
      ),
      GetPage(
        name: addPrivateVideoScreen,
        page: () => AddPrivateVideoPage(),
      ),
      GetPage(
        name: addMultiplePrivateVideosScreen,
        page: () => AddMultiplePrivateVideosPage(),
      ),
      GetPage(
        name: paymentHistory,
        page: () => const PaymentHistoryScreen(),
      ),
      GetPage(
        name: subscription,
        page: () => const SubscriptionViewPager(),
      ),
      GetPage(
        name: resetPasswordScreen,
        page: () => ResetPasswordScreen(),
      ),
      GetPage(
        name: addGroupPage,
        page: () => AddGroup(),
      ),
      GetPage(
        name: chatMainScreen,
        page: () => const ThreadViewScreen(),
      ),
      GetPage(
        name: privateGroupVideoView,
        page: () => PrivateGroupVideoView(),
      ),
      GetPage(
        name: freeAndPaidGroupsScreen,
        page: () => FreeAndPaidGroupsScreen(),
      ),
      GetPage(
        name: freePaidMainGroupScreen,
        page: () => FreePaidMainGroupScreen(),
      ),
      GetPage(
        name: freePaidSubGroupScreen,
        page: () => FreePaidSubGroupScreen(),
      ),
      GetPage(
        name: signUpUser,
        page: () => ChangeNotifierProvider(
          create: (_) => SignUpUserMenuProvider(),
          child: const SignUpUserHomeScreen(),
        ),
        preventDuplicates: true,
        maintainState: false,
      ),
      GetPage(
        name: signUpCoach,
        page: () => ChangeNotifierProvider(
          create: (_) => SignUpCoachMenuProvider(),
          child: const SignUpCoachHomeScreen(),
        ),
        preventDuplicates: true,
        maintainState: false,
      ),
      GetPage(
        name: forgotPasswordUserName,
        page: () => const ForgetPasswordUserNameScreen(),
      ),
      GetPage(
        name: coachOwnProfile,
        page: () => CoachOwnProfile(),
      ),
      GetPage(
        name: codeVerification,
        page: () => CodeVerificationScreen(),
      ),
      GetPage(
        name: dateRangeFilterPage,
        page: () => DateRangeFilterPage(),
      ),
      GetPage(
        name: addVideoPage,
        page: () => AddVideoPage(),
      ),
      GetPage(
        name: setPasswordScreen,
        page: () => SetPasswordScreen(),
      ),
      GetPage(
        name: welcomeScreen,
        page: () => const WelcomeScreen(),
      ),
      GetPage(
        name: profileSetupScreen,
        page: () => ProfileSetupScreen(),
      ),
      GetPage(
        name: privateVideoLibrary,
        page: () => PrivateVideoLibrary(),
      ),
      GetPage(
        name: myVideoLibrary,
        page: () => const MyVideosLibrary(),
      ),
      GetPage(
        name: coachProfile,
        page: () => CoachProfile(),
      ),
      GetPage(
        name: monthlyStatementsScreen,
        page: () => const MonthlyStatementScreen(),
      ),
      GetPage(
        name: addPrivateGroupScreen,
        page: () => AddPrivateGroupPage(),
      ),
      GetPage(
        name: videoDetailScreen,
        page: () => const VideoDetailScreen(),
      ),
      GetPage(
        name: videoDetailScreenDeepLinking,
        page: () => const VideoDetailScreenDeepLinking(),
        maintainState: false,
        preventDuplicates: true,
      ),
      GetPage(
        name: filterScreen,
        page: () => FilterScreen(),
        preventDuplicates: true,
        transition: Transition.topLevel,
      ),
      GetPage(
        name: contactUs,
        page: () => ContactUs(),
      ),
      GetPage(
        name: faqs,
        page: () => FrequentlyAskedQuestions(),
      ),
      GetPage(
        name: askQuestionPage,
        page: () => AskQuestionPage(),
      ),
      GetPage(
        name: workoutGroupScreen,
        page: () => const WorkoutGroupsScreen(),
      ),
      GetPage(
        name: workoutMainGroupScreen,
        page: () => const WorkoutMainGroupsScreen(),
      ),
      GetPage(
        name: workoutFreeMainGroupScreen,
        page: () => const WorkoutFreeMainGroupsScreen(),
      ),
      GetPage(
        name: workoutSubGroupScreen,
        page: () => const WorkoutSubGroupsScreen(),
      ),
      GetPage(
        name: chooseLanguage,
        page: () => const ChooseLanguage(),
        transition: Transition.zoom,
      ),
      GetPage(
        name: termsConditions,
        page: () => const TermsAndConditions(),
      ),
      GetPage(
        name: aboutUs,
        page: () => const AboutUs(),
      ),
      GetPage(
        name: workoutFor,
        page: () => WorkoutForScreen(),
      ),
      GetPage(
        name: uploadIntroVideo,
        page: () => const UploadIntroVideoScreen(),
      ),
      GetPage(
        name: onBoardingScreen,
        page: () => const OnBoardingScreen(),
        preventDuplicates: true,
      ),
      GetPage(
        name: searchScreen,
        preventDuplicates: true,
        transition: Transition.upToDown,
        page: () => const SearchScreen(),
      ),
      GetPage(
        name: home,
        page: () => ChangeNotifierProvider(
          create: (_) => MenuProviderUser(),
          child: const MainHomeScreen(),
        ),
        preventDuplicates: true,
        maintainState: true,
      ),
      GetPage(
        name: sendVideoToActiveUsers,
        page: () => const SendVideoToActiveUsers(),
      ),
    ];
  }

  static to(String route, {Map<String, dynamic>? arguments}) =>
      Get.toNamed(route, arguments: arguments);

  static offAllTo(String route, {Map<String, dynamic>? arguments}) =>
      Get.offAllNamed(route, arguments: arguments);

  static offTo(String route, {Map<String, dynamic>? arguments}) =>
      Get.offNamed(route, arguments: arguments);

  static back() => Get.back();
}
