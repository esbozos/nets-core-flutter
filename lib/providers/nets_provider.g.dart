// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nets_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NetsCoreState _$NetsCoreStateFromJson(Map<String, dynamic> json) =>
    _NetsCoreState(
      initialized: json['initialized'] as bool? ?? false,
      synced: json['synced'] as bool? ?? false,
      lastSync: json['lastSync'] == null
          ? null
          : DateTime.parse(json['lastSync'] as String),
      appVersion: (json['appVersion'] as num?)?.toDouble() ?? 0.1,
      appRegistered: json['appRegistered'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{},
      saveKeys: (json['saveKeys'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const <String, bool>{},
    );

Map<String, dynamic> _$NetsCoreStateToJson(_NetsCoreState instance) =>
    <String, dynamic>{
      'initialized': instance.initialized,
      'synced': instance.synced,
      'lastSync': instance.lastSync?.toIso8601String(),
      'appVersion': instance.appVersion,
      'appRegistered': instance.appRegistered,
      'data': instance.data,
      'saveKeys': instance.saveKeys,
    };
