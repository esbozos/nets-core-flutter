import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// Callback invoked during file download to report progress.
///
/// [receivedBytes] is the number of bytes received so far.
/// [totalBytes] is the total size of the file being downloaded.
typedef OnDownloadProgressCallback = void Function(
    int receivedBytes, int totalBytes);

/// Callback invoked during file upload to report progress.
///
/// [sentBytes] is the number of bytes sent so far.
/// [totalBytes] is the total size of the file being uploaded.
typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);

/// Represents a named URL segment in a hierarchical URL tree.
class BaseUrl {
  /// The logical name used to identify this URL segment (e.g. `'auth'`).
  String name;

  /// The URL path fragment (e.g. `'auth/'`).
  String path;

  /// Nested URL segments under this one.
  List<BaseUrl> items;

  /// Creates a [BaseUrl] with the given [name] and [path].
  BaseUrl({required this.name, required this.path, this.items = const []});

  @override
  String toString() {
    return 'BaseUrl{name: $name, path: $path, items: $items}';
  }
}

/// Exception thrown when a dotted URL name cannot be resolved in [ApiUrls].
class UrlDoestNotExists implements Exception {
  @override
  String toString() {
    return 'Url doest not exists';
  }
}

/// Manages the base URLs and named route tree for the API.
///
/// Resolves dotted names (e.g. `'auth.login'`) to full URL strings,
/// automatically switching between production and development base URLs
/// depending on [kDebugMode].
class ApiUrls {
  /// Production base URL for API endpoints.
  final String baseUrl;

  /// Development base URL for API endpoints.
  final String baseUrlDev;

  /// Production base URL for media files.
  final String baseMediaUrl;

  /// Development base URL for media files.
  final String baseMediaUrlDev;

  /// The list of registered URL trees, including built-in [authUrls].
  final List<BaseUrl> urls;

  /// Creates an [ApiUrls] instance.
  ///
  /// All string parameters must be non-empty.
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

  /// Built-in authentication URL routes (`auth.login`, `auth.logout`, etc.).
  static List<BaseUrl> authUrls = [
    BaseUrl(name: 'auth', path: 'auth/', items: [
      BaseUrl(name: 'login', path: 'login/'),
      BaseUrl(name: 'logout', path: 'logout/'),
      BaseUrl(name: 'refresh', path: 'refresh/'),
      BaseUrl(name: 'update', path: 'update/'),
    ]),
  ];

  /// Resolves a dotted [name] (e.g. `'auth.login'`) to a full URL string.
  ///
  /// Throws [UrlDoestNotExists] if any segment in [name] is not registered.
  /// Returns the dev URL in debug mode and the production URL otherwise.
  String getUrl(String name) {
    List<String> nameParts = name.split('.');
    String url = '';

    BaseUrl? ce = urls.firstWhereOrNull((e) => e.name == nameParts[0]);
    if (ce == null) {
      throw UrlDoestNotExists();
    }
    url += ce.path;
    int i = 1;
    while (i < nameParts.length) {
      ce = ce!.items.firstWhereOrNull((e) => e.name == nameParts[i]);
      if (ce == null) {
        throw UrlDoestNotExists();
      }
      url += ce.path;
      i++;
    }
      if (kDebugMode) {
      return '$baseUrlDev$url';
    }
    return '$baseUrl$url';
  }

  /// Builds a full media URL from a relative [path].
  ///
  /// Automatically prepends the `dj-media/` prefix if missing and
  /// uses the dev base URL in debug mode.
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
