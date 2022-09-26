import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fitnessapp/constants/color_constants.dart';
import 'package:fitnessapp/data/base_controller.dart';
import 'package:fitnessapp/data/local/my_hive.dart';
import 'package:fitnessapp/models/monthly_statement.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MonthlyStatementController extends BaseController {
  final DateTime focusedDay = DateTime.now();
  final kFirstDay = DateTime(2021, 1, 1);
  final kLastDay = DateTime(2030, 9, 30);
  String? downloadDirPath;
  DateTime? startRange;
  DateTime? endRange;
  final monthlyStatements = <MonthlyStatement>[].obs;
  final monthlyStatementsFullCopy = <MonthlyStatement>[];

  setDateRange(DateTime? startDate, DateTime? endDate) {
    startRange = startDate;
    endRange = endDate;
    update();
  }

  getMonthlyStatementsOfCoach() async {
    Future.delayed(10.milliseconds, () async {
      final result = await getReq('api/payout/getMonthlyStatement',
          (json) => MonthlyStatement.fromJson(json),
          query: {
            'coach_id': MyHive.getUser()?.id.toString(),
            'limit': '200',
            'offset': '0',
          });
      if (!result.error) {
        monthlyStatements.clear();
        monthlyStatementsFullCopy.clear();
        monthlyStatementsFullCopy.addAll([...?result.data]);
        applyFilters();
      }
    });
  }

  bool itemIsWithinFilterRange(String d) {
    if (d.isEmpty) return true;
    final targetDate = DateTime.parse(d);

    return targetDate.isAfter(startRange!) && targetDate.isBefore(endRange!);
  }

  void applyFilters() {
    monthlyStatements.clear();
    if (startRange == null && endRange == null) {
      monthlyStatements.addAll(monthlyStatementsFullCopy);
    } else {
      monthlyStatements.clear();
      for (MonthlyStatement s in monthlyStatementsFullCopy) {
        if (itemIsWithinFilterRange(s.lastStatementDate ?? '')) {
          monthlyStatements.add(s);
        }
      }
    }
    update();
  }

  Future<bool> _checkPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var status;
      if (androidInfo.version.sdkInt! <= 28) {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.storage.request();
          if (result == PermissionStatus.granted) {
            return true;
          }
        } else {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        final result = await getExternalStorageDirectory();
        externalStorageDirPath = result!.absolute.path;
      } catch (e) {
        final directory = await getApplicationSupportDirectory();
        externalStorageDirPath = directory.absolute.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<void> _prepareSaveDir() async {
    downloadDirPath = (await _findLocalPath())!;
    final savedDir = Directory(downloadDirPath!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<void> retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';
    setLoading(true);
    try {
      myUrl = url + '/' + fileName;
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
        setLoading(false);
        Get.snackbar(
            'Success', 'File download successfully, click here to open file.',
            backgroundColor: Colors.green,
            colorText: ColorConstants.whiteColor,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(10),
            icon: const Icon(
              Icons.folder_open,
              color: Colors.white,
            ), onTap: (g) {
          OpenFile.open(file.path);
        });
      } else {
        filePath = 'Error code: ' + response.statusCode.toString();
        setLoading(false);
        Utils.showSnack('Error', 'Could not download file');
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
      setLoading(false);
      Utils.showSnack('Error', 'Could not download file');
    }

    return filePath;
  }
}
