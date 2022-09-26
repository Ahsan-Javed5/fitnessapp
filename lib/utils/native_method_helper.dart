import 'dart:developer';

import 'package:flutter/services.dart';

class NativeMethodHandle {
  static const MethodChannel _channel = MethodChannel('image_gallery_saver');

  static Future saveFile(String file,
      {String? name, bool isReturnPathOfIOS = false}) async {
    final result = await _channel.invokeMethod(
        'saveFileToGallery', <String, dynamic>{
      'file': file,
      'name': name,
      'isReturnPathOfIOS': isReturnPathOfIOS
    });
    log('result from native Ios Code : $result');
    return result;
  }
}
