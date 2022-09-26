import 'package:fitnessapp/constants/data.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/matrix.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';

class FreePaidContainerMatrixController extends BaseController {
  //Get Container images for free and paid groups
  void getMatrix() async {
    Future.delayed(1.milliseconds, () async {
      final data = await getReq(
          'api/admin_setting/containerImages', (c) => Matrix.fromJson(c),
          showLoadingDialog: false, singleObjectData: false);

      if (!data.error) {
        DataUtils.matrixList = [...?data.data];
      }
    });
  }

  Future<bool> logoutUser() async {
    if (MyHive.getAuthToken() == 'Bearer ${MyHive.guestToken}') {
      Utils.clearDataAndGotoLogin();
      return true;
    }
    var result = await getReq('api/user/logout', (p0) => null);
    if (!result.error) Utils.clearDataAndGotoLogin();
    return !result.error;
  }

  @override
  void onInit() {
    super.onInit();
    getMatrix();
  }
}
