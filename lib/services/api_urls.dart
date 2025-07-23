import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

typedef OnDownloadProgressCallback = void Function(
    int receivedBytes, int totalBytes);
typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);

class BaseUrl {
  String name;
  String path;
  List<BaseUrl> items;
  BaseUrl({required this.name, required this.path, this.items = const []});

  @override
  String toString() {
    return 'BaseUrl{name: $name, path: $path, items: $items}';
  }
}

class UrlDoestNotExists implements Exception {
  @override
  String toString() {
    return 'Url doest not exists';
  }
}

class ApiUrls {
  final String baseUrl;
  final String baseUrlDev;
  final String baseMediaUrl;
  final String baseMediaUrlDev;
  final List<BaseUrl> urls;

  ApiUrls(
      {required this.baseUrl,
      required this.baseUrlDev,
      required this.baseMediaUrl,
      required this.baseMediaUrlDev,
      required this.urls})
      : assert(() {
          if (baseUrl.isEmpty) {
            throw Exception('baseUrl cannot be empty');
          }
          if (baseUrlDev.isEmpty) {
            throw Exception('baseUrlDev cannot be empty');
          }
          if (baseMediaUrl.isEmpty) {
            throw Exception('baseMediaUrl cannot be empty');
          }
          if (baseMediaUrlDev.isEmpty) {
            throw Exception('baseMediaUrlDev cannot be empty');
          }
          return true;
        }()) {
    urls.addAll(authUrls);
  }

  static List<BaseUrl> authUrls = [
    BaseUrl(name: 'auth', path: 'auth/', items: [
      BaseUrl(name: 'login', path: 'login/'),
      BaseUrl(name: 'logout', path: 'logout/'),
      BaseUrl(name: 'refresh', path: 'refresh/'),
      BaseUrl(name: 'update', path: 'update/'),
    ]),
  ];

  String getUrl(String name) {
    List<String> nameParts = name.split('.');
    String url = '';

    BaseUrl? ce = urls.firstWhereOrNull((e) => e.name == nameParts[0]);
    url += ce!.path;
    int i = 1;
    while (i <= nameParts.length) {
      ce = ce!.items.firstWhereOrNull((e) => e.name == nameParts[i]);

      url += ce!.path;
          i++;
    }
      if (kDebugMode) {
      return '$baseUrlDev$url';
    }
    return '$baseUrl$url';
  }

  String mediaUrl(String path) {
    // path join with baseMediaUrl

    String p = path.startsWith('/') ? path.substring(1) : path;
    if (!p.startsWith('dj-media')) {
      p = 'dj-media/$p';
    }

    // String p = path;
    String s = kDebugMode ? baseMediaUrlDev : baseMediaUrl;
    s = s.endsWith('/') ? s.substring(0, s.length - 1) : s;
    return '$s/$p';
  }
}
