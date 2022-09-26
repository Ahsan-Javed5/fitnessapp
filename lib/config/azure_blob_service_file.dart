import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:http/http.dart' as http;

/// Blob type
enum BlobType {
  BlockBlob,
  AppendBlob,
}

/// Azure Storage Client
class AzureStorageFile {
  late Map<String, String> config;
  late Uint8List accountKey;

  static const String DefaultEndpointsProtocol = 'DefaultEndpointsProtocol';
  static const String EndpointSuffix = 'EndpointSuffix';
  static const String AccountName = 'AccountName';
  static const String AccountKey = 'AccountKey';
  static final uploader = FlutterUploader();
  String path = '';
  Function(String)? onUploadError;
  Function(String)? onUploadComplete;
  Function(double)? onProgressChange;

  initService() {
    uploader.progress.listen((mProgress) {
      var finalProgress = mProgress.progress!.toDouble() / 100.0;
      if (onProgressChange != null) onProgressChange!(finalProgress);
    });

    uploader.result.listen((result) {
      if (result.status != null) {
        if (result.status == UploadTaskStatus.complete &&
            onUploadComplete != null) {
          onUploadComplete!(path);
        } else if (result.status == UploadTaskStatus.failed &&
            onUploadError != null) {
          onUploadError!('Upload failed');
        }
      }
    }, onError: (ex, stacktrace) {
      if (onUploadError != null) onUploadError!(stacktrace.toString());
    });
  }

  /// Initialize with connection string.
  AzureStorageFile.parse(String connectionString) {
    try {
      var m = <String, String>{};
      var items = connectionString.split(';');
      for (var item in items) {
        var i = item.indexOf('=');
        var key = item.substring(0, i);
        var val = item.substring(i + 1);
        m[key] = val;
      }
      config = m;
      accountKey = base64Decode(config[AccountKey]!);
      initService();
    } catch (e) {
      throw Exception('Parse error.');
    }
  }

  @override
  String toString() {
    return config.toString();
  }

  Uri uri({String path = '/', Map<String, String>? queryParameters}) {
    var scheme = config[DefaultEndpointsProtocol] ?? 'https';
    var suffix = config[EndpointSuffix] ?? 'core.windows.net';
    var name = config[AccountName];
    return Uri(
        scheme: scheme,
        host: '$name.blob.$suffix',
        path: path,
        queryParameters: queryParameters);
  }

  String _canonicalHeaders(Map<String, String> headers) {
    var keys = headers.keys
        .where((i) => i.startsWith('x-ms-'))
        .map((i) => '$i:${headers[i]}\n')
        .toList();
    keys.sort();
    return keys.join();
  }

  String _canonicalResources(Map<String, String> items) {
    if (items.isEmpty) {
      return '';
    }
    var keys = items.keys.toList();
    keys.sort();
    return keys.map((i) => '\n$i:${items[i]}').join();
  }

  sign(http.Request request) {
    request.headers['x-ms-date'] = HttpDate.format(DateTime.now());
    request.headers['x-ms-version'] = '2016-05-31';
    request.headers['Content-Length'] = '0';
    request.headers['Content-Type'] = 'application/octet-stream';
    var ce = request.headers['Content-Encoding'] ?? '';
    var cl = request.headers['Content-Language'] ?? '';
    var cz = request.contentLength == 0 ? '' : '${request.contentLength}';
    var cm = request.headers['Content-MD5'] ?? '';
    var ct = request.headers['Content-Type'] ?? '';
    var dt = request.headers['Date'] ?? '';
    var ims = request.headers['If-Modified-Since'] ?? '';
    var imt = request.headers['If-Match'] ?? '';
    var inm = request.headers['If-None-Match'] ?? '';
    var ius = request.headers['If-Unmodified-Since'] ?? '';
    var ran = request.headers['Range'] ?? '';
    var chs = _canonicalHeaders(request.headers);
    var crs = _canonicalResources(request.url.queryParameters);
    var name = config[AccountName];
    var path = request.url.path;
    var sig =
        '${request.method}\n$ce\n$cl\n$cz\n$cm\n$ct\n$dt\n$ims\n$imt\n$inm\n$ius\n$ran\n$chs/$name$path$crs';
    var mac = crypto.Hmac(crypto.sha256, accountKey);
    var digest = base64Encode(mac.convert(utf8.encode(sig)).bytes);
    var auth = 'SharedKey $name:$digest';
    request.headers['Authorization'] = auth;
  }

  /// Get Blob.
  Future<http.StreamedResponse> getBlob(String path) async {
    var request = http.Request('GET', uri(path: path));
    sign(request);
    return request.send();
  }

  /// Put Blob.
  ///
  /// `body` and `bodyBytes` are exclusive and mandatory.
  Future<void> putBlob(
    String path, {
    String? body,
    Uint8List? bodyBytes,
    String? contentType,
    BlobType type = BlobType.BlockBlob,
    required Function(String) onUploadError,
    required Function(String) onUploadComplete,
    required Function(double) onProgressChange,
  }) async {
    /// set listeners
    this.onProgressChange = onProgressChange;
    this.onUploadError = onUploadError;
    this.onUploadComplete = onUploadComplete;

    /// create request
    var request = http.Request('PUT', uri(path: path));
    request.headers['x-ms-blob-type'] =
        type.toString() == 'BlobType.AppendBlob' ? 'AppendBlob' : 'BlockBlob';
    if (contentType != null) request.headers['content-type'] = contentType;
    if (type == BlobType.BlockBlob) {
      if (bodyBytes != null) {
        request.bodyBytes = bodyBytes;
      } else if (body != null) {
        request.body = body;
      }
    } else {
      request.body = '';
    }
    sign(request);

    this.path = uri(path: path).toString();
    await uploader.clearUploads();
    await uploader.enqueue(RawUpload(
      url: uri(path: path).toString(),
      method: UploadMethod.PUT,
      headers: request.headers,
      path: body,
    ));
    /*if (res.statusCode == 201) {
      await res.stream.drain();
      if (type == BlobType.AppendBlob && (body != null || bodyBytes != null)) {
        await appendBlock(path, body: body, bodyBytes: bodyBytes);
      }
      return;
    }

    var message = await res.stream.bytesToString();
    throw AzureStorageFileException(message, res.statusCode, res.headers);*/
  }

  /// Append block to blob.
  Future<void> appendBlock(String path,
      {String? body, Uint8List? bodyBytes}) async {
    var request = http.Request(
        'PUT', uri(path: path, queryParameters: {'comp': 'appendblock'}));
    if (bodyBytes != null) {
      request.bodyBytes = bodyBytes;
    } else if (body != null) {
      request.body = body;
    }
    sign(request);
    var res = await request.send();
    if (res.statusCode == 201) {
      await res.stream.drain();
      return;
    }

    var message = await res.stream.bytesToString();
    throw AzureStorageFileException(message, res.statusCode, res.headers);
  }
}

/// Azure Storage Exception
class AzureStorageFileException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, String> headers;

  AzureStorageFileException(this.message, this.statusCode, this.headers);
}
