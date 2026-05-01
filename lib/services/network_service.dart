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

/// HTTP API client that handles authentication, cookies, and file transfers.
///
/// Uses [ApiUrls] to resolve named routes and [StorageService] to persist
/// auth tokens and cookies across sessions.
class ApiService {
  /// OAuth2 client identifier.
  final String clientId;

  /// OAuth2 client secret.
  final String clientSecret;

  /// Current session cookies keyed by name.
  Map<String, String> cookies = {};
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };

  /// Named URL resolver for this service instance.
  final ApiUrls urls;

  /// Creates an [ApiService].
  ApiService(
      {required this.urls, required this.clientId, required this.clientSecret});

  final StorageService _storageService = StorageService();

  /// When `true`, self-signed TLS certificates are accepted.
  /// Should only be enabled during development.
  static bool trustSelfSigned = true;

  /// Returns an [HttpClient] configured with a 10-second timeout and
  /// optional self-signed certificate trust.
  static HttpClient getHttpClient() {
    HttpClient httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  /// Performs an authenticated HTTP GET request.
  ///
  /// [urlName] is a dotted route name (e.g. `'user.profile'`).
  /// [data] is sent as query parameters.
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

  /// Ensures the request headers contain the current auth token and cookies.
  ///
  /// Merges any extra [headers] into the shared header map.
  Future ensureHeaders(Map<String, String>? headers) async {
    // Ensure headers for requests, auth and cookies included
    if (!_headers.containsKey('Authorization')) await setAuth();
    if (headers != null) _headers.addAll(headers);
    log('ensure headers ${_headers.toString()}');
  }

  /// Performs an authenticated HTTP POST request with JSON body.
  ///
  /// [urlName] is a dotted route name resolved via [ApiUrls].
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
      rethrow;
    }
  }

  /// Authenticates a user using an email and one-time [code].
  Future authenticate(String email, String code) async {
    return post('auth.auth', {
      "email": email,
      "code": code,
      "client_id": clientId,
      "client_secret": clientSecret
    });
  }

  /// Loads the stored auth token and cookies into the request headers.
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

  /// Uploads a [file] as a multipart POST request.
  ///
  /// Reports upload progress via the optional [onUploadProgress] callback.
  /// Returns the decoded JSON response body.
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
  
    if (allSetCookie == null || allSetCookie.isEmpty) {
      return;
    }
    var setCookies = allSetCookie.split(',');

    for (var setCookie in setCookies) {
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

  /// Downloads a file from [urlName] and returns its raw bytes.
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
