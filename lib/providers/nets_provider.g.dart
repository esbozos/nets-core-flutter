// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nets_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NetsCoreStateImpl _$$NetsCoreStateImplFromJson(Map<String, dynamic> json) =>
    _$NetsCoreStateImpl(
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

Map<String, dynamic> _$$NetsCoreStateImplToJson(_$NetsCoreStateImpl instance) =>
    <String, dynamic>{
      'initialized': instance.initialized,
      'synced': instance.synced,
      'lastSync': instance.lastSync?.toIso8601String(),
      'appVersion': instance.appVersion,
      'appRegistered': instance.appRegistered,
      'data': instance.data,
      'saveKeys': instance.saveKeys,
    };
