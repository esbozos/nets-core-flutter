# nets_core

Modern Flutter foundations for Nets apps. `nets_core` packages the shared UI, services, app shell, storage, notifications, localisation, and utilities that Nets projects use to start consistent and move faster.

[![pub package](https://img.shields.io/pub/v/nets_core.svg)](https://pub.dev/packages/nets_core)
[![Dart SDK](https://img.shields.io/badge/dart-%5E3.5.0-0175C2.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/flutter-ready-02569B.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-see%20LICENSE-111827.svg)](LICENSE)

## What You Get

`nets_core` is the common layer for Flutter applications in the Nets ecosystem. It keeps repeated product work out of each app and gives teams a reliable base for navigation, forms, secure data, API calls, notifications, and platform utilities.

| Area | Included |
| --- | --- |
| App shell | `AppStack`, `AppStackMenuItem`, `go_router` integration, convex bottom navigation |
| UI | Buttons, profile avatars, loading screens, decorated lists, sliver headers, gradient helpers |
| Layouts | Fullscreen, sticky header/body, stepper, progress-step layouts |
| Forms | Declarative form builder and styled text inputs |
| Camera | Ready-to-use picture capture and preview flow |
| Networking | URL registry, authenticated requests, cookies, multipart uploads, development certificates |
| Storage | Secure key-value helpers backed by `flutter_secure_storage` |
| Notifications | Local notifications and Firebase Cloud Messaging helpers |
| State | Riverpod state notifier with selective secure persistence |
| Utilities | Device info, country helpers, string extensions, package localisations |

## Installation

Add the package to your app:

```yaml
dependencies:
  nets_core: ^0.1.15
```

Then fetch dependencies:

```sh
flutter pub get
```

## Requirements

| Tool | Version |
| --- | --- |
| Dart SDK | `^3.5.0` |
| Flutter | Compatible with the Dart SDK above |

Some features depend on platform setup in the host app. Camera, push notifications, Firebase, and secure storage should be configured in the application that consumes this package.

## Quick Start

### App Shell

Use `AppStack` as the shared scaffold for apps that use bottom navigation with `go_router`.

```dart
AppStack(
  title: 'Nets App',
  menu: [
    AppStackMenuItem(
      label: 'Home',
      icon: Icons.home,
      location: '/home',
    ),
    AppStackMenuItem(
      label: 'Profile',
      icon: Icons.person,
      location: '/profile',
    ),
  ],
  child: child,
)
```

### Secure Storage

Store sensitive app values behind a small, predictable API.

```dart
final storage = StorageService();

await storage.writeSecureData('accessToken', token);
final savedToken = await storage.readSecureData('accessToken');
```

### API Client

Define named routes once, then call them through `ApiService`.

```dart
final apiUrls = ApiUrls(
  baseUrl: 'https://api.example.com',
  baseUrlDev: 'https://dev.api.example.com',
  baseMediaUrl: 'https://media.example.com',
  baseMediaUrlDev: 'https://dev.media.example.com',
  urls: [
    BaseUrl(
      name: 'users',
      path: '/api/users/',
      items: [
        BaseUrl(name: 'detail', path: '/api/users/{id}/'),
      ],
    ),
  ],
);

final api = ApiService(
  urls: apiUrls,
  clientId: 'client-id',
  clientSecret: 'client-secret',
);

final response = await api.get('users', {});
```

### Camera Flow

Launch the built-in capture screen and receive the selected file when the user continues.

```dart
final cameras = await availableCameras();

Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => TakePictureScreen(
      camera: cameras.first,
      title: 'Profile photo',
      onPictureTaken: (file) {
        // Upload or persist the captured image.
      },
    ),
  ),
);
```

### String Utilities

Use shared extensions for common display formatting.

```dart
'hello world'.capitalize;             // Hello world
'hello world'.capitalizeFirstofEach; // Hello World
```

## Platform Setup

### Firebase

The notification stack expects Firebase to be initialised by the host app before Firebase Messaging is used.

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Android

Add the permissions required by the features you enable.

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

### iOS

Provide user-facing permission descriptions in `Info.plist`.

```xml
<key>NSCameraUsageDescription</key>
<string>Required for taking profile pictures.</string>
```

## Package Map

```text
lib/
  app_stack.dart                 Navigation shell and menu model
  components/                    Reusable UI, layouts, forms, screens, widgets
  l10n/                          Package localisation delegates and strings
  providers/                     Riverpod state provider
  services/                      API URLs, network, notifications, storage
  utils/                         Country, device, and string helpers
```

## Development

Run the standard Flutter checks before publishing changes.

```sh
flutter analyze
flutter test
dart pub publish --dry-run
```

Generated code is used for providers and JSON models. When annotations change, rebuild with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Release Flow

1. Update `version` in `pubspec.yaml`.
2. Add the release notes to `CHANGELOG.md`.
3. Run analysis, tests, and publish dry-run locally.
4. Merge to `master`.
5. Push a matching tag, for example `v0.1.15`.

The repository publish workflow validates that the Git tag matches the package version before publishing to pub.dev.

## Links

- [Repository](https://github.com/esbozos/nets-core-flutter)
- [Issue tracker](https://github.com/esbozos/nets-core-flutter/issues)
- [License](LICENSE)
