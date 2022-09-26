import 'dart:io';

import 'package:fitnessapp/config/azure_blob_service.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/screens/sideMenu/main_menu_controller.dart';
import 'package:fitnessapp/utils/my_image_picker.dart';
import 'package:get/get.dart';
import 'package:messenger/controllers/user_controller.dart';
import 'package:messenger/model/UserWrapper.dart';

class UserProfileController extends BaseController {
  final String _updateUserEndPoint = 'api/user/';

  var user = User().obs;
  final MyImagePicker _picker = MyImagePicker();
  XFile? _selectedImage;
  File? imageFile;

  final storage = AzureStorage.parse(MyHive.azureConnectionString);

  selectImage() async {
    _selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(_selectedImage!.path);
    update();
  }

  viewUpdate() async {
    user.value = MyHive.getUser()!;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    viewUpdate();
  }

  // String getImagePath() {
  //   String path = '';
  //   if (MyHive.getUser() != null && MyHive.getUser()!.imageUrl != null) {
  //     path = MyHive.getUser()!.imageUrl!;
  //   }
  //   return '$baseUrl$path';
  // }
  String getImagePath() {
    String path = '';
    if (MyHive.getUser() != null && MyHive.getUser()!.imageUrl != null) {
      path = MyHive.getUser()!.imageUrl!;
    }
    return path;
  }

  String getPreferOTPDelivery() {
    String prefer = 'sms';
    if (MyHive.getUser() != null &&
        MyHive.getUser()!.preferredOTPDelivery != null) {
      prefer = MyHive.getUser()!.preferredOTPDelivery!;
    }
    return prefer.toLowerCase();
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
    );
    userWrapper.entityId = user.firebaseKey!;
    userWrapper.fcm = MyHive.getFcm();
    await UserController.updateUser(user.firebaseKey!, userWrapper);
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
      updateUserOnFirebase(user);
      showSnackBar('successful'.tr, 'profile_updated_successfully'.tr);
      Get.find<MainMenuController>().notifyProfileUpdated();
    }
  }
}
