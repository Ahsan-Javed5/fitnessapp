import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/models/video.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';

class ResetPasswordController extends BaseController {
  final String _updateUserEndPoint = 'api/user/reset_password';

  restPassWord(Map body) async {
    var response = await putReq(
        _updateUserEndPoint, "", body, (video) => Video.fromJson(video),
        singleObjectData: false);

    if (!response.error) {
      Get.back();
      Future.delayed(
          1000.milliseconds, () => showSnackBar('alert'.tr, response.message));
    }
  }
}
