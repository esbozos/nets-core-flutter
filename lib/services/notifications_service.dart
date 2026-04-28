import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int id = 0;

class NotificationChannel {
  String id;
  String name;
  String? description;
  String? icon;
  Color? color;
  String? ticker;

  NotificationChannel(
      {required this.id,
      required this.name,
      this.description,
      this.icon,
      this.color,
      this.ticker});
}

class NotificationAction {
  String id;
  String title;
  Color? color;

  NotificationAction(this.id, this.title);
}

class NotificationMessage {
  int id;
  String title;
  String body;
  String? payload;
  List<NotificationAction>? actions;

  NotificationMessage(
      {required this.id,
      required this.title,
      required this.body,
      this.payload,
      this.actions});
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<NotificationMessage> didReceiveLocalNotificationStream =
    StreamController<NotificationMessage>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

Future<void> showLocalNotification(
    NotificationChannel channel, NotificationMessage message,
    {int? notificationId}) async {
  if (Platform.isWindows) return;
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          color: channel.color,
          icon: channel.icon != null
              ? '@mipmap/${channel.icon}'
              : '@mipmap/ic_launcher',
          actions: message.actions
              ?.map((e) =>
                  AndroidNotificationAction(e.id, e.title, titleColor: e.color))
              .toList(),
          ticker: channel.ticker);
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      id: notificationId ?? id++, title: message.title, body: message.body, notificationDetails: notificationDetails,
      payload: message.payload);
}

class NotificationService {
  bool? initialized;
  bool? permissionGranted;
  bool didNotificationLaunchApp;
  String? launchPayload;

  NotificationService(
      {this.initialized,
      this.permissionGranted,
      this.didNotificationLaunchApp = false,
      this.launchPayload});
}

Future<NotificationService> initializeLocalNotifications(String? icon,
// if platform is windows we dont initialize notifications

    {List<NotificationAction>? actionCategories,
    bool requestPermissions = false,
    void Function(NotificationResponse)? onDidReceiveNotificationResponse,
    void Function(NotificationResponse)?
        onDidReceiveBackgroundNotificationResponse}) async {
  NotificationService notificationService = NotificationService(
    initialized: false,
    permissionGranted: false,
    didNotificationLaunchApp: false,
    launchPayload: null,
  );

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      (!kIsWeb && Platform.isLinux) || Platform.isWindows
          ? null
          : await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();

  // check for payload if app was launched via notification
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    notificationService.didNotificationLaunchApp = true;
    notificationService.launchPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;

    // initialRoute = SecondPage.routeName;
  }
  var initializationSettingsAndroid = AndroidInitializationSettings(
      icon != null ? '@mipmap/$icon' : '@mipmap/ic_launcher');

  // Linux initialization settings
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon(
        icon != null ? 'icons/$icon.png' : 'icons/app_icon.png'),
  );

  // macOS initialization settings
  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[];
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    // onDidReceiveLocalNotification:
    //     (int id, String? title, String? body, String? payload) async {
    //   didReceiveLocalNotificationStream.add(
    //     NotificationMessage(
    //       id: id,
    //       title: title ?? '',
    //       body: body ?? '',
    //       payload: payload,
    //     ),
    //   );
    // },
    notificationCategories: darwinNotificationCategories,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );
  notificationService.initialized = Platform.isWindows
      ? false
      : await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
          onDidReceiveBackgroundNotificationResponse:
              onDidReceiveBackgroundNotificationResponse);

  if (requestPermissions) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        notificationService.permissionGranted =
            await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>()
                ?.requestNotificationsPermission();
        break;

      case TargetPlatform.iOS:
        notificationService.permissionGranted =
            await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    IOSFlutterLocalNotificationsPlugin>()
                ?.requestPermissions(
                  alert: true,
                  badge: true,
                  sound: true,
                );
      case TargetPlatform.macOS:
        notificationService.permissionGranted =
            await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    IOSFlutterLocalNotificationsPlugin>()
                ?.requestPermissions(
                  alert: true,
                  badge: true,
                  sound: true,
                );
        break;
      case TargetPlatform.linux:
        notificationService.permissionGranted = true;
        break;
      default:
        notificationService.permissionGranted = true;
        break;
    }
  } else {
    notificationService.permissionGranted = true;
  }
  return notificationService;
}
