import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

int id = 0;

/// Defines an Android notification channel used to group and style notifications.
class NotificationChannel {
  /// Unique channel identifier.
  String id;

  /// Human-readable channel name shown in device settings.
  String name;

  /// Optional description shown in device settings.
  String? description;

  /// Optional drawable icon name (without extension).
  String? icon;

  /// Optional accent colour for notifications on this channel.
  Color? color;

  /// Optional ticker text for accessibility.
  String? ticker;

  /// Creates a [NotificationChannel].
  NotificationChannel(
      {required this.id,
      required this.name,
      this.description,
      this.icon,
      this.color,
      this.ticker});
}

/// An inline action button that can appear on a notification.
class NotificationAction {
  /// Unique action identifier.
  String id;

  /// Label shown on the action button.
  String title;

  /// Optional colour for the action title.
  Color? color;

  /// Creates a [NotificationAction] with [id] and [title].
  NotificationAction(this.id, this.title);
}

/// Represents a notification to be displayed to the user.
class NotificationMessage {
  /// Unique notification identifier.
  int id;

  /// Short notification title.
  String title;

  /// Notification body text.
  String body;

  /// Optional string payload delivered when the user taps the notification.
  String? payload;

  /// Optional list of inline action buttons.
  List<NotificationAction>? actions;

  /// Creates a [NotificationMessage].
  NotificationMessage(
      {required this.id,
      required this.title,
      required this.body,
      this.payload,
      this.actions});
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Stream of [NotificationMessage] objects broadcast when a local notification
/// is received while the app is in the foreground.
/// Since the plugin is initialised in `main`, streams are the recommended
/// way to propagate notification events to the UI.
final StreamController<NotificationMessage> didReceiveLocalNotificationStream =
    StreamController<NotificationMessage>.broadcast();

/// Stream of notification payload strings broadcast when the user taps
/// a notification to open the app.
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

/// Displays a local notification using the provided [channel] and [message].
///
/// An optional [notificationId] can be supplied to control update/dismissal;
/// otherwise a unique auto-incrementing id is used.
/// Does nothing on Windows.
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

/// Holds the result state of [initializeLocalNotifications].
class NotificationService {
  /// Whether the notification plugin was successfully initialized.
  bool? initialized;

  /// Whether the user granted notification permissions.
  bool? permissionGranted;

  /// `true` if the app was launched by tapping a notification.
  bool didNotificationLaunchApp;

  /// The payload from the notification that launched the app, if any.
  String? launchPayload;

  NotificationService(
      {this.initialized,
      this.permissionGranted,
      this.didNotificationLaunchApp = false,
      this.launchPayload});
}

/// Initialises the local notifications plugin for all supported platforms.
///
/// Pass an optional [icon] drawable name (without prefix/extension).
/// Set [requestPermissions] to `true` to prompt the user for permission.
/// Returns a [NotificationService] with the resulting initialisation state.
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
