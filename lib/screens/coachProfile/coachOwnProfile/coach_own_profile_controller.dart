import 'dart:async';
import 'dart:io';

import 'package:fitnessapp/config/azure_blob_service.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/admin_settings.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:fitnessapp/screens/sideMenu/main_menu_controller.dart';
import 'package:fitnessapp/utils/my_image_picker.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/UserWrapper.dart';
import 'package:video_compress/video_compress.dart';

class CoachOwnProfileController extends BaseController {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  TextEditingController coachBioController = TextEditingController();
  String? coachBio;
  User? user;
  final String _updateUserEndPoint = 'api/user/';
  final String _addIntroVideoEndPoint = 'api/user/add_intro_video';
  final String _removeIntroVideoEndPoint = 'api/user/remove_intro_video';
  final String _getSubscriptionPriceEndPoint =
      'api/admin_setting/getSubscriptionAmount';

  /// [0] for SMS
  /// [1] for Email
  /// [2] for Both
  var preferredOtpType = 0.obs;
  var subscriptionPrice = '00'.obs;
  XFile? _selectedImage;
  File? imageFile;
  final MyImagePicker _picker = MyImagePicker();
  final storage = AzureStorage.parse(MyHive.azureConnectionString);

  /// Video upload
  final status = 'loading'.obs;
  final mProgressValue = 0.0.obs;

  selectImage() async {
    _selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(_selectedImage!.path);
    update();
  }

  getSubscriptionPrice() async {
    final result = await getReq(
      _getSubscriptionPriceEndPoint,
      (json) => AdminSettings.fromJson(json),
      singleObjectData: true,
      showLoadingDialog: false,
    );

    if (!result.error) {
      final AdminSettings s = result.singleObjectData;
      subscriptionPrice.value = s.value ?? '00';
    }
  }

  changePreferredOtpType(int type) {
    preferredOtpType.value = type;
  }

  User? getUser() {
    User? user = MyHive.getUser();
    return user;
  }

  ///this function is used to update user inside this Controller so that we can use it inside the
  ///UI
  void updateLocalUser(User? localUser) {
    user = localUser ?? getUser();
    coachBioController.text = localUser?.bio ?? ' No Bio';
    update();
  }

  String getPreferOTPDelivery() {
    String prefer = 'sms';
    if (MyHive.getUser() != null &&
        MyHive.getUser()!.preferredOTPDelivery != null) {
      prefer = MyHive.getUser()!.preferredOTPDelivery!;
    }
    return prefer.toLowerCase();
  }

  String getImagePath() {
    String path = '';
    if (MyHive.getUser() != null && MyHive.getUser()!.imageUrl != null) {
      path = MyHive.getUser()!.imageUrl!;
    }
    return path;
  }

  updateUser(Map map, File? image) async {
    setLoading(true, isVideo: true);
    if (image == null) {
      updateProfile(map);
    } else {
      final name = image.path.split('/');
      await storage.putBlob('${MyHive.azureContainer}${name.last}',
          body: image.path,
          contentType: AzureStorage.getImgExtension(image.path),
          bodyBytes: image.readAsBytesSync(),
          onProgressChange: (d) => progressValue.value = d,
          onUploadComplete: (url) async {
            setLoading(false);
            setLoading(true);

            /// save url on our server with other details
            log(message: url);
            map['image_url'] = url;
            updateProfile(map);
          },
          onUploadError: (e) {
            setLoading(false);
            setError(true);
            setMessage(e);
          });
    }
  }

  updateUserOnFirebase(User user) async {
    final userWrapper = UserWrapper.toServerObject(
      name: user.getFullName(),
      phone: user.phoneNumber,
      userType: user.userType,
      pictureURL: user.imageUrl,
      email: user.email,
      availability: Utils.getUserAvailabilityStatus(user),
    );
    userWrapper.entityId = user.firebaseKey!;
    userWrapper.fcm = MyHive.getFcm();
    await UserController.updateUser(user.firebaseKey!, userWrapper);
  }

  removeIntroVideo() async {
    Map body = {};
    final response = await postReq(
        _removeIntroVideoEndPoint, body, (video) => Video.fromJson(video));

    /// save null in intro video in hive when coach remove his intro video
    if (!response.error) {
      User? user = MyHive.getUser();
      if (user != null) {
        user.coachIntroVideo = null;
        MyHive.saveUser(user);
      }
      update(['introBuilder']);
      showSnackBar('alert'.tr, 'video_removed_successfully'.tr);
    }
  }

  addIntroVideo(String videoPath, File videoFile) async {
    Map body = {};

    status.value = 'loading';
    Get.defaultDialog(
        title: '',
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        barrierDismissible: false,
        content: Column(
          children: [
            Obx(() {
              return Text(
                status.value.tr,
                style: TextStyles.headingAppBlackBold,
              );
            }),
            Spaces.y2,
            Obx(() {
              return LinearProgressIndicator(value: mProgressValue.value);
            }),
            Spaces.y2,
          ],
        ));

    /// Compressing
    status.value = 'compressing';
    await VideoCompress.setLogLevel(0);
    Subscription subscription =
        VideoCompress.compressProgress$.subscribe((progress) {
      mProgressValue.value = progress / 100;
    });
    File? renamedFile;
    if (Platform.isIOS && videoFile.path.contains(' ')) {
      renamedFile = await Utils.changeFileNameOnly(
          File.fromUri(Uri.parse(videoFile.path)),
          '${DateTime.now().microsecondsSinceEpoch}newVideo.mov');
    }

    ///here he is compressing video!
    final MediaInfo? info = await VideoCompress.compressVideo(
      renamedFile?.path ?? videoFile.path,
      quality: VideoQuality.HighestQuality,
      deleteOrigin: true,
      includeAudio: true,
    );
    subscription.unsubscribe();
    File file = File(info!.path!);

    /// Create Thumbnail and upload
    status.value = 'Thumbnailing...';
    final uInt8List = await Utils.getThumbnailFromVideoFile(file.path);
    final imageFile = await Utils.uInt8ListToTempImageFile(uInt8List);
    String thumbnailUrl = await uploadImage(
      imageFile!,
      '${DateTime.now().microsecondsSinceEpoch}thumbnail.png',
    );

    /// Uploading Video
    status.value = 'uploading';
    mProgressValue.value = 0;
    await storage.putBlob(
        '${MyHive.azureContainer}${info.path!.split('\/').last}',
        body: file.path,
        contentType: 'application/octet-stream',
        bodyBytes: file.readAsBytesSync(), onProgressChange: (d) {
      return mProgressValue.value = d;
    }, onUploadComplete: (s) async {
      /// save url on our server with other details
      body['video'] = s;
      body['thumbnail_url'] = thumbnailUrl;
      log(message: s);
      final response = await postReq(
        _addIntroVideoEndPoint,
        body,
        (video) => Video.fromJson(video),
        singleObjectData: true,
      );
      setMessage(response.message);
      Video? video = response.singleObjectData;
      if (!response.error && video != null) {
        User? user = MyHive.getUser();
        if (user != null) {
          user.coachIntroVideo = video;
          MyHive.saveUser(user);
          update(['introBuilder']);
        }
      }
    }, onUploadError: (e) {
      setError(true);
      setMessage(e);
    });
  }

  /// This method will upload the image on Azure and will return the url
  /// of that image on azure
  uploadImage(File imageFile, String name) async {
    Completer completer = Completer<String>();
    await storage.putBlob(
      '${MyHive.azureContainer}$name',
      body: imageFile.path,
      contentType: AzureStorage.getImgExtension(imageFile.path),
      bodyBytes: imageFile.readAsBytesSync(),
      onProgressChange: (d) {},
      onUploadComplete: (url) async {
        /// save url on our server with other details
        log(message: url);

        completer.complete(url);
      },
      onUploadError: (e) {
        setError(true);
        completer.complete('');
        setMessage(e);
      },
    );

    return completer.future;
  }

  void updateProfile(Map map) async {
    final response = await putReq(
      _updateUserEndPoint,
      '',
      map,
      (json) => User.fromJson(json),
    );
    setLoading(false);
    if (!response.error) {
      User user = response.data![0];
      MyHive.saveUser(user);
      User? nSavedUser = MyHive.getUser();
      updateLocalUser(nSavedUser);
      updateUserOnFirebase(user);
      showSnackBar('successful'.tr, 'profile_updated_successfully'.tr);
      Get.find<MainMenuController>().notifyProfileUpdated();
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (Platform.isAndroid) {
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    }
  }

  @override
  InternalFinalCallback<void> get onDelete {
    if (Platform.isAndroid) {
      FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    }
    return super.onDelete;
  }
}
