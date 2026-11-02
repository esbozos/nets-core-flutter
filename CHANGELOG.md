## Unreleased

* Add opt-in `AppStack.useMaterialNavigation` with labelled, non-overlapping
  Material navigation, badges and keyboard-aware visibility.
* Refresh menu labels on widget updates and match nested Material destinations.
* Respect navigation visibility in both bottom-bar and rail layouts.

## 0.1.15

* Update package dependencies and metadata for the current Flutter ecosystem.
* Remove the obsolete Android `EncryptedSharedPreferences` secure-storage option.
* Refresh the README with a modern package overview and updated usage guidance.

## 0.1.14

* Replace deprecated Radio APIs with RadioGroup in list option widgets.
* Increase public API documentation coverage with dartdoc across core services and providers.
* Harden pub.dev publish workflow version parsing and credentials handling for CI.

## 0.1.13

* Update package metadata to the new public GitHub repository.
* Repository links now point to `https://github.com/esbozos/nets-core-flutter`.
* Clean repository for public maintenance by removing local/generated artifacts from version control.

## 0.1.12

* Public release.
* Full README with usage examples for all major features.
* `AppStack` navigation shell with `convex_bottom_bar` and `go_router` integration.
* `ApiService` with OAuth2 token refresh, dot-notation URL resolution, and multipart upload support.
* `StorageService` secure key-value storage backed by `flutter_secure_storage`.
* `NotificationsService` with local notifications and Firebase Cloud Messaging support.
* `NetsCoreProvider` Riverpod state notifier with selective secure-storage persistence.
* UI components: `WideButton`, `ProfileAvatar`, `TakePictureScreen`, `WebViewScreen`, `LoadingScreen`, `FormBuilder`, `TextFormInput`, list widgets, and layout helpers.
* `StringExtension` utilities for capitalisation.
* `DeviceUtils` and `CountryUtils` helpers.
* English localisation (ARB-based).

## 0.0.1

* Initial private release.
