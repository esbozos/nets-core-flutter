library nets_core;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'services/storage_service.dart';

class NetsCore {
  static const MethodChannel _channel = const MethodChannel('store_checker');

  static Future<bool> get isTrusted async {
    final String? sourceName = await _channel.invokeMethod('getSource');
    debugPrint('isTrusted sourceName: $sourceName');
    return true;
  }
}
