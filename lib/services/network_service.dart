import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:nets_core/nets_core.dart';
import 'package:nets_core/services/api_urls.dart';

typedef OnDownloadProgressCallback = void Function(
    int receivedBytes, int totalBytes);
typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);

class ApiService {
  final String clientId;

  final String clientSecret;
  Map<String, String> cookies = {};
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  final ApiUrls urls;
  ApiService(
      {required this.urls, required this.clientId, required this.clientSecret});

  final StorageService _storageService = StorageService();
  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  Future<http.Response> get(String urlName, Map<String, dynamic> data) async {
    try {
      // get Url from dotted name
      String urlFromName = urls.getUrl(urlName);

      if (kDebugMode) {
        print('url from name $urlFromName');
      }
      await ensureHeaders({});
      // Build Uri form string
      var encodedData = data.map((key, value) {
        if (value is String) {
          return MapEntry(key, value);
        } else {
          return MapEntry(key, jsonEncode(value));
        }
      });
      var url = Uri.parse(urlFromName).replace(queryParameters: encodedData);
      if (kDebugMode) {
        print('url from name parsed $url');
      }
      // Perform request
      var response = await http.get(url, headers: _headers);
      // update cookies from response
      _updateCookie(response);
      return response;
    } catch (e) {
      log('Api service get error ${e.toString()}');
      rethrow;
    }
  }

  Future ensureHeaders(Map<String, String>? headers) async {
    // Ensure headers for requests, auth and cookies included
    if (!_headers.containsKey('Authorization')) await setAuth();
    if (headers != null) _headers.addAll(headers);
    log('ensure headers ${_headers.toString()}');
  }

  Future post(String urlName, Map<String, dynamic> data,
      {Map<String, String>? headers, Encoding? encoding}) async {
    try {
      // Ensure header and auth if exists
      await ensureHeaders(headers);
      if (kDebugMode) {
        print(_headers);
      }
      // Get url by dotted name
      String urlFromName = urls.getUrl(urlName);
      // Build uri from string
      var url = Uri.parse(urlFromName);

      // Data can contain non string values, so we need to encode it
      var encodedData = data.map((key, value) {
        if (value is String) {
          return MapEntry(key, value);
        } else {
          return MapEntry(key, jsonEncode(value));
        }
      });

      // Encode data to json
      String stringData = jsonEncode(encodedData);

      // Perform request
      var response = await http.post(url,
          body: stringData, headers: _headers, encoding: encoding);

      // update cookies from response
      _updateCookie(response);
      return response;
    } catch (e) {
      log('Api service post error ${e.toString()}');
    }
  }

  Future authenticate(String email, String code) async {
    return post('auth.auth', {
      "email": email,
      "code": code,
      "client_id": clientId,
      "client_secret": clientSecret
    });
  }

  Future setAuth() async {
    dynamic auth = await _storageService.readSecureData('authState');

    if (auth != null) {
      auth = jsonDecode(auth);

      if (auth["token"] != null) {
        _headers['Authorization'] = 'Bearer ${auth["token"]}';
      }
    }
    dynamic cookies = await _storageService.readSecureData('cookies');

    if (cookies != null) {
      _headers['cookie'] = cookies;
    }
    return;
  }

  Future<Map<String, dynamic>> fileUploadMultipart(
      {required String urlName,
      required Map<String, String> data,
      required String fieldName,
      required File file,
      Map<String, String>? headers,
      OnUploadProgressCallback? onUploadProgress}) async {
    final url = Uri.parse(urls.getUrl(urlName));

    final httpClient = getHttpClient();

    final request = await httpClient.postUrl(url);

    int byteCount = 0;

    var multipart = await http.MultipartFile.fromPath(fieldName, file.path);

    var requestMultipart = http.MultipartRequest("POST", url);

    requestMultipart.files.add(multipart);
    requestMultipart.fields.addAll(data);

    var msStream = requestMultipart.finalize();

    var totalByteLength = requestMultipart.contentLength;

    request.contentLength = totalByteLength;

    await ensureHeaders(headers);
    _headers['Content-Type'] = requestMultipart.headers['content-type']!;

    for (var header in _headers.entries) {
      request.headers.add(header.key, header.value);
    }

    Stream<List<int>> streamUpload = msStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;

          if (onUploadProgress != null) {
            onUploadProgress(byteCount, totalByteLength);
            // CALL STATUS CALLBACK;
          }
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();

    var statusCode = httpResponse.statusCode;

    if (statusCode ~/ 100 != 2) {
      throw Exception(
          'Error uploading file, Status code: ${httpResponse.statusCode}');
    } else {
      var responseJson = await httpResponse.transform(utf8.decoder).join();

      return json.decode(responseJson);
    }
  }

  void _updateCookie(http.Response response) async {
    String? allSetCookie = response.headers['set-cookie'];
    if (kDebugMode) {
      print('set cookies is $allSetCookie');
    }
    var setCookies = allSetCookie?.split(',');

    for (var setCookie in setCookies ?? []) {
      var cookies = setCookie.split(';');

      for (var cookie in cookies) {
        _setCookie(cookie);
      }
    }

    _headers['cookie'] = _generateCookieHeader();
    await _storageService.writeSecureData(
        'cookies', jsonEncode(_headers['cookie']));
    }

  void _setCookie(String rawCookie) {
    if (rawCookie.isNotEmpty) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;
        if (key == 'csrftoken') {
          _headers['X-Csrftoken'] = value;
        }

        cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";
      cookie += "$key=${cookies[key]!}";
    }

    return cookie;
  }

  Future<Uint8List> downloadFile(
      {required String urlName, Map<String, dynamic>? data}) async {
    final url = Uri.parse(urls.getUrl(urlName));
    ensureHeaders({'Content-Type': 'application/json', 'responseType': 'blob'});

    final request = await http.post(
      url,
      body: jsonEncode(data),
      headers: _headers,
    );
    return request.bodyBytes;
  }
}
