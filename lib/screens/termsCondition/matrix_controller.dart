import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/matrix.dart';
import 'package:fitnessapp/models/user/user.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MatrixController extends BaseController {
  final String _matrixEP = 'api/user/get_matrix?matrix=';
  final matrixValue = ''.obs;

  void fetchMatrixData(String query, {bool supportRTL = true}) async {
    Future.delayed(const Duration(milliseconds: 1), () async {
      final _result = await getReq(
        '$_matrixEP$query',
        (json) => Matrix.fromJson(json),
        singleObjectData: true,
      );

      if (!_result.error) {
        if (_result.singleObjectData != null) {
          final data = _result.singleObjectData as Matrix;
          String value = '';
          if (Utils.isRTL() && supportRTL) {
            value = data.valueArabic ?? 'error';
            //value = addUserDataInArContract(value);
          } else {
            value = data.value ?? 'error';
           // value = addUserDataInEnglishContract(value);
          }
          matrixValue.value = value;
        }
      }
    });
  }

  ///TODO replace other required fields in ENG contract
  String addUserDataInEnglishContract(String contract) {
    User? user = getUser();
    if (user != null) {
      String userName = user.getFullName();
      String country = user.country?.name ?? '';
      contract = contract.replaceAll('[name]', '<b>$userName</b>');
      contract = contract.replaceAll('[NAME]', '<b>$userName</b>');
      contract = contract.replaceAll('[Name]', '<b>$userName</b>');
      contract = contract.replaceAll('[location]', '<b>$country</b>');
      contract = contract.replaceAll('[Location]', '<b>$country</b>');
    }
    return contract;
  }

  String addUserDataInArContract(String contract) {
    User? user = getUser();
    if (user != null) {
      String userName = user.getFullName();
      String country = user.country?.name ?? '';
      contract = contract.replaceAll('[الاسم]', '<b>$userName</b>');
      contract = contract.replaceAll('[بالاسم]', '<b>$userName</b>');
      contract = contract.replaceAll('[الموقع]', '<b>$country</b>');
    }
    return contract;
  }

  User? getUser() {
    return MyHive.getUser();
  }
}
