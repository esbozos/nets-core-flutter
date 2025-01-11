import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nets_core/nets_core.dart';

part 'nets_provider.freezed.dart';
part 'nets_provider.g.dart';

@freezed
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

class NetsCoreProvider extends StateNotifier<NetsCoreState> {
  final Ref ref;
  static const _initial = NetsCoreState();

  StorageService storageService = StorageService();
  NetsCoreProvider(this.ref, [NetsCoreState state = _initial]) : super(state) {
    // log('AuthClass constructor');
    loadFromStorage();
  }
  loadFromStorage() async {
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

  saveState() {
    // remove items that are not to be saved
    Map<String, dynamic> dataToSave = {};
    state.data.forEach((key, value) {
      if (state.saveKeys[key] == true) {
        dataToSave[key] = value;
      }
    });
    storageService.writeSecureData('netsCoreState', jsonEncode(dataToSave));
  }

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

  void removeItem(String key) {
    state = state.copyWith(
        data: {
      ...state.data,
    }..remove(key));
    saveState();
  }

  void clearData() {
    state = state.copyWith(data: {});
    saveState();
  }
}

final netsCoreProvider =
    StateNotifierProvider<NetsCoreProvider, NetsCoreState>((ref) {
  return NetsCoreProvider(ref);
});
