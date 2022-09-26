import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnessapp/config/app_state_observer.dart';
import 'package:fitnessapp/config/azure_blob_service.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/country.dart';
import 'package:fitnessapp/models/enums/subscription_type.dart';
import 'package:fitnessapp/models/enums/user_type.dart';
import 'package:fitnessapp/models/main_group.dart';
import 'package:fitnessapp/models/otp_data.dart';
import 'package:fitnessapp/models/user/user.dart' as model;
import 'package:fitnessapp/models/user/user_credentials.dart';
import 'package:fitnessapp/models/workout_program_type.dart';
import 'package:fitnessapp/utils/my_image_picker.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:messenger/config/Glob.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/Availability.dart';
import 'package:messenger/model/UserWrapper.dart';
import 'package:messenger/model/providers/ThreadUserLinksProvider.dart';
import 'package:provider/provider.dart';

/// This controller is being used everywhere we need to perform auth operations
/// like sign up, sign in, update profile, change password, bank details
class AuthController extends BaseController {
  final formKey = GlobalKey<FormBuilderState>();
  final MyImagePicker _picker = MyImagePicker();
  UserType selectedUser = UserType.user;
  final countries = [];
  final workoutTypes = [];
  XFile? _selectedImage;
  File? imageFile;
  final storage = AzureStorage.parse(MyHive.azureConnectionString);
  final buttonIsEnabled = true.obs;

  /// Endpoints
  final String _verifyUserEndpoint = 'api/user/verifyUser';
  final String _sendOTPEndpoint = 'api/user/getOTP';

  /// sign up fields
  String password = '';
  String firebaseKey = '';
  final showResendButton = false.obs;
  List<String>? selectedWorkoutTypes;

  final String workOutWidgetId = 'workoutMap';

  /// This string will contain email otp after successful response
  String emailOtp = '';
  String smsOtp = '';

  void selectImage() async {
    _selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (_selectedImage != null) {
      imageFile = File(_selectedImage!.path);
      update();
    }
  }

  void getAllCountries() async {
    await Future.delayed(1.milliseconds, () async {
      final result =
          await getReq(getCountriesEndPoint, (json) => Country.fromJson(json));
      if (result.data != null) countries.addAll(result.data ?? []);
      update([getCountriesEndPoint]);
    });
  }

  void getWorkoutTypes() async {
    await Future.delayed(1.milliseconds, () async {
      final result = await getReq(
          getWorkoutTypesEndPoint, (json) => WorkoutProgramType.fromJson(json));
      if (result.data != null) workoutTypes.addAll(result.data ?? []);
      update([getWorkoutTypesEndPoint]);
    });
  }

  void verifyDetailsThenPhone() async {
    formKey.currentState!.save();
    if (imageFile == null) {
      Utils.showSnack('alert', 'select_photo'.tr);
    } else if (formKey.currentState!.validate()) {
      /// verify username via api call
      if (await verifyUserName()) {
        verifyPhoneAndEmail();
      }
    }
  }

  Future<bool> verifyUserName() async {
    final res = await postReq(_verifyUserEndpoint,
        {'user_name': formKey.currentState!.value['user_name']}, (j) => null);
    if (res.error) showSnackBar('alert', res.message);
    return !res.error;
  }

  void signUp() async {
    buttonIsEnabled.value = false;
    setLoading(true, isVideo: true);
    final name = imageFile!.path.split('/');
    await storage.putBlob('${MyHive.azureContainer}${name.last}',
        body: imageFile!.path,
        contentType: AzureStorage.getImgExtension(imageFile!.path),
        bodyBytes: imageFile!.readAsBytesSync(),
        onProgressChange: (d) => progressValue.value = d,
        onUploadComplete: (url) async {
          //setLoading(true);

          /// save url on our server with other details
          log(message: url);

          var response = await postReq(
            userSignupEndPoint,
            {
              'image': url,
              ...formKey.currentState!.value,
              'country_id': Utils.getIdOfValue(
                  countries, formKey.currentState!.value['country']),
              if (selectedUser == UserType.coach)
                'workout_program_types': selectedWorkoutTypes!
                    .map((e) => Utils.getIdOfValue(workoutTypes, e,
                        localizedCheck: true))
                    .toList()
                    .toString(),
              'password': password,
              'firebase_key': formKey.currentState!.value['user_name'],
              'user_type': Utils.userTypeValue(selectedUser),
              'selected_language': Utils.isRTL() ? 'Arabic' : 'English',
            },
            (user) => model.User.fromJson(user),
            singleObjectData: true,
            handleLoading: false,
          );

          if (!response.error) {
            //setLoading(true);
            model.User user = response.singleObjectData;
            MyHive.saveUser(user);
            MyHive.setUserType(selectedUser);
            MyHive.setAuthToken(user.token ?? '');

            ///saving username and password locally for next login with face id, encrypt password
            UserCredentials userCredentials = UserCredentials();
            userCredentials.userName = user.userName ?? '';
            userCredentials.password = password;
            MyHive.setUserCredentials(userCredentials);

            await authenticateUserWithMessenger(user);
            await updateFCM();
            Get.find<AppStateObserver>().listenForUserDataChanges();
            final p = Provider.of<ThreadUserLinksProvider>(Get.context!,
                listen: false);
            await Future.delayed(const Duration(milliseconds: 10)).then((_) {
              p.initProvider(user.firebaseKey!);
            });
            setLoading(false);
            if (selectedUser == UserType.user) {
              Routes.offAllTo(Routes.home);
              MyHive.setSubscriptionType(SubscriptionType.unSubscribed);
            } else {
              Routes.offAllTo(Routes.welcomeScreen);
            }
          } else {
            setLoading(false);
            buttonIsEnabled.value = true;
          }
        },
        onUploadError: (e) {
          setLoading(false);
          setError(true);
          buttonIsEnabled.value = true;
          setMessage(e);
        });
  }

  updateFCM() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      await postReq('api/user/update/fcm', {'fcm_token': token},
          (p0) => MainGroup.fromJson(p0));
    });
  }

  Future<void> verifyPhoneAndEmail() async {
    showResendButton.value = false;
    //  this one
    // if (selectedUser == UserType.coach) {
    await Future.delayed(const Duration(milliseconds: 10), () {
      sendOtpOnMailAddress(
        /// if the user type is [UserType.user] then there will be no email
        /// only in case of coach email will be available
        formKey.currentState!.value['email'] ?? '',
        formKey.currentState!.value['phone_number'],
      );
    });
    // } else {
    //   Get.toNamed(Routes.setPasswordScreen);
    // }

    Future.delayed(30.seconds, () => showResendButton.value = true);
  }

  void sendOtpOnMailAddress(String email, String phone) async {
    Map body = {'email': email};

    // MyHive.getUserType() == UserType.user
    //     ? {
    //         'number': phone,
    //       }
    //     : {
    //         'email': email,
    //         'number': phone,
    //       };

    var response =
        await postReq(_sendOTPEndpoint, body, (p0) => OTPData.fromJson(p0));
    if (!response.error) {
      var data = response.data?[0];
      if (data != null) {
        OTPData otpData = data as OTPData;
        emailOtp = otpData.emailOTP;
        // smsOtp = otpData.smsOTP;
      }
      setLoading(false);
      Routes.to(Routes.codeVerification);
    } else {
      Utils.showSnack(
        'error',
        'Failed to sent OTP on email',
        isError: true,
      );
    }
  }

  bool validateMailOtp(String userOtp) {
    return userOtp == emailOtp;
  }

  bool validateSmsOtp(String userOtp) {
    return userOtp == smsOtp;
  }

  void verifyCode(String smsCode, String emailCode) async {
    if (!validateSmsOtp(smsCode)) {
      Utils.showSnack(
        'alert'.tr,
        'Invalid sms OTP',
        isError: true,
      );
      return;
    }

    if (!validateMailOtp(emailCode)) {
      Utils.showSnack(
        'alert'.tr,
        'Invalid email OTP',
        isError: true,
      );
      return;
    }
    Get.toNamed(Routes.setPasswordScreen);
  }

  authenticateUserWithMessenger(model.User user) async {
    if (!await Glob.authenticateUserWithCustomToken(user.firebaseJWT!)) {
      Future.delayed(
          1.seconds,
          () => Utils.showSnack(
                'error',
                'Cannot authenticate with messenger',
                isError: true,
              ));
      log(message: '@@@@ ---> cannot authenticate user with firebase');
      return;
    }

    log(message: '@@@@ ---> User is authenticated with firebase');
    final userWrapper = UserWrapper.toServerObject(
      name: user.getFullName(),
      phone: user.phoneNumber,
      userType: user.userType,
      pictureURL: user.imageUrl,
      email: user.email,
      availability: Availability.Available,
    );
    userWrapper.entityId = user.firebaseKey!;
    userWrapper.fcm = MyHive.getFcm();
    Glob().currentUserKey = user.firebaseKey;
    await UserController.authenticateUser(userWrapper);
  }
}
