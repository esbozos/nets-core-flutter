import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

/// Represents a registered device with its hardware, OS, and token information.
class DeviceIdentifier {
  /// Human-readable device name (brand, model, etc.).
  String name;

  /// Operating system name and version string.
  String os;

  /// Unique device identifier (UUID / vendor identifier).
  String? uuid;

  /// OS version string.
  String? osVersion;

  /// Application version string.
  String? appVersion;

  /// Platform push notification token.
  String? deviceToken;

  /// Firebase Cloud Messaging token.
  String? firebaseToken;

  /// Device IP address.
  String? ip;

  /// Whether the device is considered active.
  bool active;

  /// Server-assigned identifier.
  int? id;

  /// Timestamps for last login, creation, and last update.
  DateTime? lastLogin, created, updated;

  /// Creates a [DeviceIdentifier].
  DeviceIdentifier(
      {required this.name,
      required this.os,
      this.uuid,
      this.osVersion,
      this.appVersion,
      this.deviceToken,
      this.firebaseToken,
      this.active = true,
      this.id,
      this.lastLogin,
      this.created,
      this.updated,
      this.ip});

  /// Deserialises a [DeviceIdentifier] from a JSON [Map].
  factory DeviceIdentifier.fromJson(Map<String, dynamic> json) {
    return DeviceIdentifier(
      name: json['name'],
      os: json['os'],
      uuid: json['uuid'],
      osVersion: json['os_version'],
      appVersion: json['app_version'],
      deviceToken: json['device_token'],
      firebaseToken: json['firebase_token'],
      active: json['active'],
      id: json['id'],
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      ip: json['ip'],
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
    );
  }

  /// Serialises this [DeviceIdentifier] to a JSON [Map].
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'os': os,
      'uuid': uuid,
      'os_version': osVersion,
      'app_version': appVersion,
      'device_token': deviceToken,
      'firebase_token': firebaseToken,
      'active': active,
      'id': id,
      'last_login': lastLogin?.toIso8601String(),
      'created': created?.toIso8601String(),
      'updated': updated?.toIso8601String(),
      'ip': ip,
    };
  }

  @override
  String toString() {
    return name;
  }

  /// Returns a copy of this [DeviceIdentifier] with the given fields replaced.
  DeviceIdentifier copyWith({
    String? name,
    String? os,
    String? uuid,
    String? osVersion,
    String? appVersion,
    String? deviceToken,
    String? firebaseToken,
    bool? active,
    int? id,
    DateTime? lastLogin,
    DateTime? created,
    DateTime? updated,
    String? ip,
  }) {
    return DeviceIdentifier(
      name: name ?? this.name,
      os: os ?? this.os,
      uuid: uuid ?? this.uuid,
      osVersion: osVersion ?? this.osVersion,
      appVersion: appVersion ?? this.appVersion,
      deviceToken: deviceToken ?? this.deviceToken,
      firebaseToken: firebaseToken ?? this.firebaseToken,
      active: active ?? this.active,
      id: id ?? this.id,
      lastLogin: lastLogin ?? this.lastLogin,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      ip: ip ?? this.ip,
    );
  }
}

/// Utility class that holds and exposes the current device's [DeviceIdentifier]
/// as a set of static convenience getters and setters.
class DeviceIdentifierUtil {
  final deviceInfoPlugin = DeviceInfoPlugin();

  /// The singleton [DeviceIdentifier] for the running device.
  static DeviceIdentifier? deviceIdentifier;

  /// The device name, or an empty string if not set.
  static String get deviceName => deviceIdentifier?.name ?? '';

  /// The device OS string, or an empty string if not set.
  static String get deviceOs => deviceIdentifier?.os ?? '';

  static String? get deviceUuid => deviceIdentifier?.uuid;

  static String? get deviceOsVersion => deviceIdentifier?.osVersion;

  static String? get deviceAppVersion => deviceIdentifier?.appVersion;

  static String? get deviceToken => deviceIdentifier?.deviceToken;

  static String? get firebaseToken => deviceIdentifier?.firebaseToken;

  static bool get deviceActive => deviceIdentifier?.active ?? true;

  static int? get deviceId => deviceIdentifier?.id;

  static DateTime? get deviceLastLogin => deviceIdentifier?.lastLogin;

  static DateTime? get deviceCreated => deviceIdentifier?.created;

  static DateTime? get deviceUpdated => deviceIdentifier?.updated;

  static Map<String, dynamic> get deviceJson =>
      deviceIdentifier?.toJson() ?? {};

  static void setDeviceIdentifier(DeviceIdentifier deviceIdentifier) {
    deviceIdentifier = deviceIdentifier;
  }

  static void setDeviceName(String name) {
    deviceIdentifier?.name = name;
  }

  static void setDeviceOs(String os) {
    deviceIdentifier?.os = os;
  }

  static void setDeviceUuid(String uuid) {
    deviceIdentifier?.uuid = uuid;
  }

  static void setDeviceOsVersion(String osVersion) {
    deviceIdentifier?.osVersion = osVersion;
  }

  static void setDeviceAppVersion(String appVersion) {
    deviceIdentifier?.appVersion = appVersion;
  }

  static void setDeviceToken(String deviceToken) {
    deviceIdentifier?.deviceToken = deviceToken;
  }

  static void setFirebaseToken(String firebaseToken) {
    deviceIdentifier?.firebaseToken = firebaseToken;
  }

  static void setDeviceActive(bool active) {
    deviceIdentifier?.active = active;
  }

  static void setDeviceId(int id) {
    deviceIdentifier?.id = id;
  }

  static void setDeviceLastLogin(DateTime lastLogin) {
    deviceIdentifier?.lastLogin = lastLogin;
  }

  static void setDeviceCreated(DateTime created) {
    deviceIdentifier?.created = created;
  }

  static void setDeviceUpdated(DateTime updated) {
    deviceIdentifier?.updated = updated;
  }

  static void setDeviceJson(Map<String, dynamic> json) {
    deviceIdentifier = DeviceIdentifier.fromJson(json);
  }

  static void clearDeviceIdentifier() {
    deviceIdentifier = null;
  }

  /// Collects device information and returns a populated [DeviceIdentifier].
  ///
  /// Pass the optional [appVersion] string to embed in the identifier.
  Future<DeviceIdentifier> getIdentifier(String? appVersion) async {
    appVersion ??= '';

    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    String emu = '';

    DeviceIdentifier deviceIdentifier = DeviceIdentifier(
      name: '',
      os: '',
      uuid: '',
      osVersion: '',
      appVersion: '',
      deviceToken: '',
      firebaseToken: '',
      active: true,
      id: null,
      lastLogin: null,
      created: null,
      updated: null,
      ip: '',
    );

    if (Platform.isAndroid) {
      if (!allInfo['isPhysicalDevice']) {
        emu = 'EMULATOR';
      }
      deviceIdentifier.name =
          '${allInfo['brand']} ${allInfo['model']} $emu ${allInfo['device']} ${allInfo['manufacturer']}';
      deviceIdentifier.os =
          'Android ${allInfo['version.release']} ${allInfo['version.sdkInt']}';
      deviceIdentifier.osVersion = allInfo['version.release'];
      deviceIdentifier.appVersion = appVersion;
      deviceIdentifier.deviceToken = '';
      deviceIdentifier.firebaseToken = '';
    } else if (Platform.isIOS) {
      if (!allInfo['isPhysicalDevice']) {
        emu = 'EMULATOR';
      }
      deviceIdentifier.name = '${allInfo['name']} ${allInfo['model']} $emu ';
      deviceIdentifier.os =
          '${allInfo['systemName']} ${allInfo['systemVersion']}';
      deviceIdentifier.osVersion = allInfo['systemVersion'];
      deviceIdentifier.appVersion = appVersion;
      deviceIdentifier.deviceToken = allInfo['identifierForVendor'];
      deviceIdentifier.firebaseToken = '';
    } else if (Platform.isWindows) {
      deviceIdentifier.name =
          '${allInfo['productName']} ${allInfo['displayVersion']} $emu ';
      deviceIdentifier.os = '${allInfo['productName']}';
      deviceIdentifier.osVersion = allInfo['displayVersion'];
      deviceIdentifier.appVersion = appVersion;
      deviceIdentifier.deviceToken = allInfo['deviceId'];
      deviceIdentifier.firebaseToken = '';
    } else if (Platform.isLinux) {
      deviceIdentifier.name = '${allInfo['prettyName']}';
      deviceIdentifier.os = '${allInfo['id']}';
      deviceIdentifier.osVersion = allInfo['version'];
      deviceIdentifier.appVersion = appVersion;
      deviceIdentifier.deviceToken = allInfo['machineId'];
      deviceIdentifier.firebaseToken = '';
    } else if (Platform.isMacOS) {
      deviceIdentifier.name =
          '${allInfo['computerName']} ${allInfo['model']} ${allInfo['osRelease']} $emu ';
      deviceIdentifier.os =
          'macOS ${allInfo['osRelease']} ${allInfo['osVersion']}';
      deviceIdentifier.osVersion = allInfo['osRelease'];
      deviceIdentifier.appVersion = appVersion;
      deviceIdentifier.deviceToken = allInfo['systemGUID'];
      deviceIdentifier.firebaseToken = '';
    } else {
      // is browser
      deviceIdentifier.name =
          '${allInfo['appName']} ${allInfo['appVersion']} $emu ';
      deviceIdentifier.os = '${allInfo['platform']} ${allInfo['appVersion']}';
      deviceIdentifier.osVersion = allInfo['userAgent'];
      deviceIdentifier.appVersion = appVersion;
      deviceIdentifier.deviceToken = '';
      deviceIdentifier.firebaseToken = '';
    }

    return deviceIdentifier;
  }

  DeviceIdentifierUtil();
}
