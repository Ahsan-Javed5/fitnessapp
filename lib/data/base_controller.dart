import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fitnessapp/config/space_values.dart';
import 'package:fitnessapp/config/text_styles.dart';
import 'package:fitnessapp/constants/routes.dart';
import 'package:fitnessapp/data/secure_http_client.dart';
import 'package:fitnessapp/models/base_response.dart';
import 'package:fitnessapp/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';
import 'package:lottie/lottie.dart';

class BaseController extends GetxController {
  static const String _baseUrl = Routes.baseUrl;
  final String getCountriesEndPoint = 'api/country/';
  final String getWorkoutTypesEndPoint = 'api/workout_program_type/';
  final String userSignupEndPoint = 'api/user/';
  final progressValue = 0.0.obs;

  // final secureRepository = MySecureHttpClient.getClient();
  final insecureRepository = MySecureHttpClient.getClient();
  final _isLoading = false.obs;
  final _isError = false.obs;
  final _message = ''.obs;

  bool ignoreLoadingCalls = false;

  get isLoading => _isLoading.value;

  get isError => _isError.value;

  get message => _message.value;

  get baseUrl => _baseUrl;

  setError(bool isError) {
    _isError.value = isError;
  }

  setLoading(bool isLoading, {bool isVideo = false}) async {
    if (ignoreLoadingCalls) return;
    _isLoading.value = isLoading;
    if (isLoading) {
      Get.closeAllSnackbars();
      if (Get.isDialogOpen ?? true) return;
      Get.defaultDialog(
          title: ''.tr,
          radius: 8,
          contentPadding:
              isVideo ? EdgeInsets.all(Spaces.normX(4)) : EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          barrierDismissible: false,
          content: SizedBox(
            height: Spaces.normY(isVideo ? 6 : 13),
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  top: 0,
                  child: isVideo
                      ? Obx(() {
                          return LinearProgressIndicator(
                              value: progressValue.value);
                        })
                      : Lottie.asset(
                          'assets/animations/loading_animation.json',
                          repeat: true,
                          animate: true,
                          height: Spaces.normY(13),
                        ),
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  top: Spaces.normY(isVideo ? 3 : 9),
                  child: Center(
                      child: Text(
                    isVideo ? 'uploading'.tr : 'loading'.tr,
                    style: TextStyles.normalBlueBodyText
                        .copyWith(fontSize: Spaces.normSP(11)),
                  )),
                ),
              ],
            ),
          ));
    } else if (!isLoading && (Get.isDialogOpen ?? false)) {
      int i = 0;

      while (!Get.isOverlaysClosed && i < 100) {
        i++;
        await Future.delayed(200.milliseconds, () {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        });
      }
    }
  }

  showSnackBar(String title, String message) {
    Utils.showSnack(title, message, isError: isError);
  }

  /// if [notifyOnlyIfError] is true then snack bar appear only if there is error
  /// if it is false and then snack bar will appear everytime
  /// if [notify] is false then no snack bar will appear in any case only the
  /// message will be set silently
  setMessage(
    String message, {
    bool notify = true,
    bool notifyOnlyIfError = true,
  }) {
    _message.value = message;
    if (notify) {
      if (Get.isDialogOpen!) Get.back();
      if (notifyOnlyIfError && isError) {
        Utils.showSnack(
          isError ? 'Error' : 'Success',
          message,
          isError: isError,
        );
      } else if (!notifyOnlyIfError) {
        Utils.showSnack(
          isError ? 'Error' : 'Success',
          message,
          isError: isError,
        );
      }
    }
  }

  /// [modelClassJsonFunction] example (j) => GeneralUser.fromJson(j)
  /// Use this method to send patch request for Rest apis
  Future<BaseResponse> patchReq(
    String endPoint,
    Map body,
    Function(Map<String, dynamic>) modelClassJsonFunction, {
    bool singleObjectData = false,
  }) async {
    try {
      setLoading(true);
      final _result = await MySecureHttpClient.getClient().patch(
        endPoint,
        data: body,
      );
      return parseResponse(_result, modelClassJsonFunction,
          singleObjectData: singleObjectData);
    } catch (e) {
      return parseException(e);
    }
  }

  /// [modelClassJsonFunction] example (j) => GeneralUser.fromJson(j)
  /// Use this method to send put request for Rest apis
  Future<BaseResponse> putReq(
    String endPoint,
    dynamic putValue,
    Map body,
    Function(Map<String, dynamic>) modelClassJsonFunction, {
    bool singleObjectData = false,
    bool autoHandleLoadingIndicator = true,
  }) async {
    try {
      if (autoHandleLoadingIndicator) setLoading(true);
      final _result = await MySecureHttpClient.getClient().put(
        '$endPoint$putValue',
        data: body,
      );
      return parseResponse(
        _result,
        modelClassJsonFunction,
        singleObjectData: singleObjectData,
        autoHandleLoadingIndicator: autoHandleLoadingIndicator,
      );
    } catch (e) {
      return parseException(e);
    }
  }

  /// [modelClassJsonFunction] example (j) => GeneralUser.fromJson(j)
  /// Use this method to send post request for Rest apis
  Future<BaseResponse> deleteReq(
    String endPoint,
    Map<String, dynamic> query,
    Function(Map<String, dynamic>) modelClassJsonFunction, {
    bool singleObjectData = false,
  }) async {
    try {
      setLoading(true);
      String finalURl = endPoint;
      final _result = await MySecureHttpClient.getClient().delete(
        finalURl,
        queryParameters: query,
      );
      return parseResponse(_result, modelClassJsonFunction,
          singleObjectData: singleObjectData);
    } catch (e) {
      return parseException(e);
    }
  }

  /// [modelClassJsonFunction] example (j) => GeneralUser.fromJson(j)
  /// Use this method to send post request for Rest apis
  Future<BaseResponse> postReq(
    String endPoint,
    Map body,
    Function(Map<String, dynamic>) modelClassJsonFunction, {
    bool singleObjectData = false,
    bool handleLoading = true,
  }) async {
    if (handleLoading) setLoading(true);
    try {
      final _result = await MySecureHttpClient.getClient().post(
        endPoint,
        data: body,
      );
      log(message: 'URL: ${_result.requestOptions.baseUrl}');
      return parseResponse(
        _result,
        modelClassJsonFunction,
        singleObjectData: singleObjectData,
        autoHandleLoadingIndicator: handleLoading,
      );
    } catch (e) {
      return parseException(e);
    }
  }

  Future<BaseResponse> getReq(
    String endpoint,
    Function(Map<String, dynamic>) modelClassJsonFunction, {
    bool showLoadingDialog = true,
    bool singleObjectData = false,
    Map<String, dynamic>? query,
  }) async {
    if (showLoadingDialog) {
      setLoading(true);
    }
    try {
      dynamic _result = await MySecureHttpClient.getClient().get(
        endpoint,
        queryParameters: query,
      );
      log(
          message:
              'URL: ${_result.requestOptions.baseUrl} EndPoint: $endpoint');
      return await parseResponse(_result, modelClassJsonFunction,
          singleObjectData: singleObjectData);
    } catch (e) {
      return parseException(e);
    }
  }

  Future<BaseResponse> parseResponse(
    dynamic response,
    Function(Map<String, dynamic>) modelClassJsonFunction, {
    bool singleObjectData = false,
    bool autoHandleLoadingIndicator = true,
  }) async {
    try {
      if (kDebugMode) {
        log(
            message: response?.toString() ??
                response.statusMessage ??
                'Could not parse response');
      }

      /// if response is not successful or if there is error which is not thrown
      /// by our server explicitly then we need to do this to get error message
      ///
      /// if error code is 401 then logout user because session is expired
      ///
      if (response.statusCode == 401) {
        _isError.value = true;
        Utils.showSnack('Alert', 'Session terminated, logging out...');
        await Utils.clearDataAndGotoLogin();
        return BaseResponse();
      }
      if (response == null ||
          response.data == null ||
          // response.body.length < 2 ||
          response.statusCode == 401) {
        _isError.value = true;
        setMessage(response.statusText);
        return BaseResponse(error: true, message: response.statusText);
      } else {
        /// When the response is send by our server intentionally
        final data = BaseResponse.fromJson(
          response.data,
          modelClassJsonFunction,
          singleObjectData: singleObjectData,
        );

        if (autoHandleLoadingIndicator) {
          _isError.value = data.error;
          setMessage(data.message);
        }

        return data;
      }
    } catch (e) {
      /// if error is thrown while parsing response or during
      /// sending http request then catch and parse that exception
      e.printError();
      if (autoHandleLoadingIndicator) {
        _isError.value = true;
        setMessage(e.toString());
      }
      return BaseResponse(error: true, message: e.toString());
    } finally {
      /// finally hide loading dialog
      /// added delay otherwise there is chance that finally is called before and
      /// dialog appears late and then we will miss this call so to avoid that
      /// added delay
      Future.delayed(10.milliseconds, () => setLoading(false));
    }
  }

  BaseResponse parseException(e) {
    setError(true);
    setLoading(false);
    if (kDebugMode) e.toString();
    if (e is DioError) {
      final error = e;
      if (error.error is CertificateNotVerifiedException) {
        return BaseResponse(error: true, message: 'Connection is not secure');
      } else if (e.response?.statusCode == 401) {
        Utils.showSnack('Alert', 'Session terminated, logging out...');
        Utils.clearDataAndGotoLogin();
      } else if (e.response?.data['message'] != null) {
        return BaseResponse(error: true, message: e.response?.data['message']);
      } else if (error.error is SocketException) {
        return BaseResponse(
            error: true, message: 'Please check your internet connection');
      }
    }
    return BaseResponse();
  }

  void log({
    String identifier = '@@@@\n---------------------------------------->',
    required String message,
  }) {
    if (kDebugMode) {
      print('$identifier\n$message\n<----------------------------------------');
    }
  }
}
