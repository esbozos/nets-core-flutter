# nets_core

A Flutter package that provides a set of core UI components, services, and utilities shared across Nets projects. It standardizes navigation, network communication, secure storage, push notifications, and common UI patterns so every app in the Nets ecosystem starts from a solid, consistent foundation.

---

## Features

### 🧭 Navigation & App Shell
- **`AppStack`** – a `ConsumerStatefulWidget` that wraps the whole app with a convex bottom navigation bar (powered by [`convex_bottom_bar`](https://pub.dev/packages/convex_bottom_bar)) and integrates with `go_router`. Supports custom active/inactive colours, gradients, an optional `AppBar`, and a reactive listener callback.
- **`AppStackMenuItem`** – model class for each navigation item (icon, label, route location, optional badge and custom item builder).

### 🗂 Layouts
- **`FullscreenLayout`** – simple full-screen container.
- **`HeaderBodyScrollLayout`** – sticky header with a scrollable body.
- **`PageStepper`** – multi-step page flow.
- **`ProgressStepLayout`** – step-based progress indicator layout.

### 🧱 UI Components
- **`WideButton`** – full-width `ElevatedButton` with icon support, configurable colours, and automatic text capitalisation.
- **`ProfileAvatar`** – user avatar widget with network image caching via [`cached_network_image`](https://pub.dev/packages/cached_network_image).
- **`ListDecorated`**, **`OptionsList`**, **`OptionsListItem`** – pre-styled list containers and option row widgets.
- **`SliverHeader`** / **`SliverHeaderGeneric`** – customisable sliver headers for `CustomScrollView`.
- **`GradientShader`** – applies a gradient shader to any child widget.
- **`MenuItem`** – standard navigation menu item.
- **`WebViewScreen`** – in-app WebView screen backed by [`webview_flutter`](https://pub.dev/packages/webview_flutter).
- **`LoadingScreen`** – full-screen loading placeholder.

### 📸 Camera
- **`TakePictureScreen`** – ready-to-use camera screen built with the [`camera`](https://pub.dev/packages/camera) plugin. Accepts a `CameraDescription` and an `onPictureTaken(File)` callback.

### 📝 Forms
- **`FormBuilder`** – declarative form container.
- **`TextFormInput`** – styled text input field with built-in validation helpers.

### 🌐 Networking — `ApiService`
- Dot-notation URL resolution via `ApiUrls` (production and development base URLs, media URLs, and nested route trees).
- Automatic `Authorization` header injection with OAuth2 `client_credentials` token refresh.
- Secure cookie handling.
- `GET`, `POST`, `PATCH`, `DELETE`, and multipart file-upload support.
- Configurable self-signed certificate trust for development environments.

### 💾 Secure Storage — `StorageService`
- Thin wrapper around [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) with Android `EncryptedSharedPreferences`.
- CRUD helpers: `writeSecureData`, `readSecureData`, `deleteSecureData`, `readAllSecureData`, `deleteAllSecureData`, `containsKeyInSecureData`.

### 🔔 Push Notifications — `NotificationsService`
- Local notifications via [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications).
- Firebase Cloud Messaging integration via [`firebase_messaging`](https://pub.dev/packages/firebase_messaging).
- `NotificationChannel`, `NotificationMessage`, and `NotificationAction` model classes for composing rich notifications.

### 🗃 State Management — `NetsCoreProvider`
- `StateNotifier` (Riverpod) that holds global app state (`NetsCoreState`) including version, sync status, and an arbitrary key-value data map with configurable persistence.
- Automatically persists selected keys to secure storage on every state change.

### 🛠 Utilities
- **`StringExtension`** – `capitalize`, `capitalizeFirstofEach`, `capitalizeFirstofEachWord`, `capitalizeFirstofEachSentence`, and more.
- **`DeviceUtils`** – device information helpers via [`device_info_plus`](https://pub.dev/packages/device_info_plus).
- **`CountryUtils`** – country picker helpers via [`country_picker`](https://pub.dev/packages/country_picker).

### 🌍 Localisation
- Ships with English ARB strings (`app_en.arb`) and generated `AppLocalizations`.
- Exposes `NetsLocalizationsDelegate` so host apps can merge nets_core strings with their own.

---

## Getting started

### Requirements

| Tool | Minimum version |
|------|----------------|
| Dart SDK | `^3.5.0` |
| Flutter | `>=3.24.0` |

### 1. Add the dependency

```yaml
dependencies:
  nets_core: ^0.1.12
```

Then run:

```sh
flutter pub get
```

### 2. Firebase setup

`nets_core` depends on `firebase_core` and `firebase_messaging`. Make sure your host app already has Firebase initialised:

```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### 3. Platform permissions

**Android** (`AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

**iOS** (`Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Required for taking profile pictures.</string>
```

---

## Usage

### AppStack — main scaffold with bottom navigation

```dart
AppStack(
  title: 'My App',
  menu: [
    AppStackMenuItem(label: 'Home',    icon: Icons.home,    location: '/home'),
    AppStackMenuItem(label: 'Profile', icon: Icons.person,  location: '/profile'),
  ],
  child: child, // provided by go_router ShellRoute
)
```

### ApiService — HTTP client

```dart
final apiUrls = ApiUrls(
  baseUrl:        'https://api.example.com',
  baseUrlDev:     'https://dev.api.example.com',
  baseMediaUrl:   'https://media.example.com',
  baseMediaUrlDev:'https://dev.media.example.com',
  urls: [
    BaseUrl(name: 'users', path: '/api/users/', items: [
      BaseUrl(name: 'detail', path: '/api/users/{id}/'),
    ]),
  ],
);

final api = ApiService(
  urls:         apiUrls,
  clientId:     'my-client-id',
  clientSecret: 'my-client-secret',
);

final response = await api.get('users', {});
```

### StorageService — secure key-value storage

```dart
final storage = StorageService();
await storage.writeSecureData('token', 'abc123');
final token = await storage.readSecureData('token');
```

### TakePictureScreen — camera

```dart
final cameras = await availableCameras();
Navigator.push(context, MaterialPageRoute(
  builder: (_) => TakePictureScreen(
    camera: cameras.first,
    title: 'Profile photo',
    onPictureTaken: (file) {
      // handle the captured File
    },
  ),
));
```

### StringExtension

```dart
'hello world'.capitalize;               // 'Hello world'
'hello world'.capitalizeFirstofEach;   // 'Hello World'
```

---

## Additional information

- **Issues & contributions**: open an issue or pull request on the [GitHub repository](https://github.com/nets-dev/nets-core-flutter).
- **Licence**: see the [LICENSE](LICENSE) file.
- **Versioning**: this package follows [Semantic Versioning](https://semver.org/). Breaking changes increment the major version.

