import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:nets_core/nets_core.dart';

part 'nets_provider.freezed.dart';
part 'nets_provider.g.dart';

@freezed
/// Immutable state for the [NetsCoreProvider].
///
/// Holds generic key-value [data] persisted to secure storage, sync metadata,
/// and flags that control which keys survive across sessions.
abstract class NetsCoreState with _$NetsCoreState {
  const factory NetsCoreState({
    @Default(false) bool initialized,
    @Default(false) bool synced,
    DateTime? lastSync,
    @Default(0.1) double appVersion,
    @Default(false) bool appRegistered,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    @Default(<String, bool>{}) Map<String, bool> saveKeys,
  }) = _NetsCoreState;

  factory NetsCoreState.fromJson(Map<String, dynamic> json) =>
      _$NetsCoreStateFromJson(json);
}

/// Riverpod [StateNotifier] that manages persistent app-level key-value data.
///
/// Automatically loads state from [StorageService] on construction and
/// persists changes back to secure storage on every mutation.
class NetsCoreProvider extends StateNotifier<NetsCoreState> {
  final Ref ref;
  static const _initial = NetsCoreState();

  StorageService storageService = StorageService();
  NetsCoreProvider(this.ref, [NetsCoreState state = _initial]) : super(state) {
    // log('AuthClass constructor');
    loadFromStorage();
  }
  /// Loads the previously persisted [NetsCoreState] from secure storage
  /// and updates [state] accordingly.
  Future<void> loadFromStorage() async {
    // log('AuthClass loadFromStorage');
    var data = await storageService.readSecureData('netsCoreState');
    debugPrint('nestCoreState loaded from storage data: $data');
    if (data != null) {
      var jsonData = jsonDecode(data);

      var json = NetsCoreState.fromJson(jsonData);

      state = json;
    }

    saveState();
  }

  /// Persists the current state to secure storage.
  ///
  /// Only keys listed in [NetsCoreState.saveKeys] with value `true` are saved.
  void saveState() {
    // remove items that are not to be saved
    Map<String, dynamic> dataToSave = {};
    state.data.forEach((key, value) {
      if (state.saveKeys[key] == true) {
        dataToSave[key] = value;
      }
    });
    storageService.writeSecureData('netsCoreState', jsonEncode(dataToSave));
  }

  /// Stores [value] under [key] in the state data map.
  ///
  /// Set [saveKey] to `false` to prevent this key from being persisted
  /// across app restarts.
  void setItem(String key, dynamic value, {bool saveKey = true}) {
    state = state.copyWith(data: {
      ...state.data,
      key: value
    }, saveKeys: {
      ...state.saveKeys,
      key: saveKey,
    });
    saveState();
  }

  /// Removes the entry for [key] from the state data map.
  void removeItem(String key) {
    state = state.copyWith(
        data: {
      ...state.data,
    }..remove(key));
    saveState();
  }

  /// Clears all entries from the state data map and persists the empty state.
  void clearData() {
    state = state.copyWith(data: {});
    saveState();
  }
}

/// Global [StateNotifierProvider] exposing [NetsCoreProvider] and [NetsCoreState].
final netsCoreProvider =
    StateNotifierProvider<NetsCoreProvider, NetsCoreState>((ref) {
  return NetsCoreProvider(ref);
});
