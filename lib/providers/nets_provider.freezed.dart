// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nets_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NetsCoreState _$NetsCoreStateFromJson(Map<String, dynamic> json) {
  return _NetsCoreState.fromJson(json);
}

/// @nodoc
mixin _$NetsCoreState {
  bool get initialized => throw _privateConstructorUsedError;
  bool get synced => throw _privateConstructorUsedError;
  DateTime? get lastSync => throw _privateConstructorUsedError;
  double get appVersion => throw _privateConstructorUsedError;
  bool get appRegistered => throw _privateConstructorUsedError;
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  Map<String, bool> get saveKeys => throw _privateConstructorUsedError;

  /// Serializes this NetsCoreState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NetsCoreStateCopyWith<NetsCoreState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetsCoreStateCopyWith<$Res> {
  factory $NetsCoreStateCopyWith(
          NetsCoreState value, $Res Function(NetsCoreState) then) =
      _$NetsCoreStateCopyWithImpl<$Res, NetsCoreState>;
  @useResult
  $Res call(
      {bool initialized,
      bool synced,
      DateTime? lastSync,
      double appVersion,
      bool appRegistered,
      Map<String, dynamic> data,
      Map<String, bool> saveKeys});
}

/// @nodoc
class _$NetsCoreStateCopyWithImpl<$Res, $Val extends NetsCoreState>
    implements $NetsCoreStateCopyWith<$Res> {
  _$NetsCoreStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialized = null,
    Object? synced = null,
    Object? lastSync = freezed,
    Object? appVersion = null,
    Object? appRegistered = null,
    Object? data = null,
    Object? saveKeys = null,
  }) {
    return _then(_value.copyWith(
      initialized: null == initialized
          ? _value.initialized
          : initialized // ignore: cast_nullable_to_non_nullable
              as bool,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as double,
      appRegistered: null == appRegistered
          ? _value.appRegistered
          : appRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      saveKeys: null == saveKeys
          ? _value.saveKeys
          : saveKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetsCoreStateImplCopyWith<$Res>
    implements $NetsCoreStateCopyWith<$Res> {
  factory _$$NetsCoreStateImplCopyWith(
          _$NetsCoreStateImpl value, $Res Function(_$NetsCoreStateImpl) then) =
      __$$NetsCoreStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool initialized,
      bool synced,
      DateTime? lastSync,
      double appVersion,
      bool appRegistered,
      Map<String, dynamic> data,
      Map<String, bool> saveKeys});
}

/// @nodoc
class __$$NetsCoreStateImplCopyWithImpl<$Res>
    extends _$NetsCoreStateCopyWithImpl<$Res, _$NetsCoreStateImpl>
    implements _$$NetsCoreStateImplCopyWith<$Res> {
  __$$NetsCoreStateImplCopyWithImpl(
      _$NetsCoreStateImpl _value, $Res Function(_$NetsCoreStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialized = null,
    Object? synced = null,
    Object? lastSync = freezed,
    Object? appVersion = null,
    Object? appRegistered = null,
    Object? data = null,
    Object? saveKeys = null,
  }) {
    return _then(_$NetsCoreStateImpl(
      initialized: null == initialized
          ? _value.initialized
          : initialized // ignore: cast_nullable_to_non_nullable
              as bool,
      synced: null == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as double,
      appRegistered: null == appRegistered
          ? _value.appRegistered
          : appRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      saveKeys: null == saveKeys
          ? _value._saveKeys
          : saveKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetsCoreStateImpl implements _NetsCoreState {
  const _$NetsCoreStateImpl(
      {this.initialized = false,
      this.synced = false,
      this.lastSync,
      this.appVersion = 0.1,
      this.appRegistered = false,
      final Map<String, dynamic> data = const <String, dynamic>{},
      final Map<String, bool> saveKeys = const <String, bool>{}})
      : _data = data,
        _saveKeys = saveKeys;

  factory _$NetsCoreStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetsCoreStateImplFromJson(json);

  @override
  @JsonKey()
  final bool initialized;
  @override
  @JsonKey()
  final bool synced;
  @override
  final DateTime? lastSync;
  @override
  @JsonKey()
  final double appVersion;
  @override
  @JsonKey()
  final bool appRegistered;
  final Map<String, dynamic> _data;
  @override
  @JsonKey()
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  final Map<String, bool> _saveKeys;
  @override
  @JsonKey()
  Map<String, bool> get saveKeys {
    if (_saveKeys is EqualUnmodifiableMapView) return _saveKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_saveKeys);
  }

  @override
  String toString() {
    return 'NetsCoreState(initialized: $initialized, synced: $synced, lastSync: $lastSync, appVersion: $appVersion, appRegistered: $appRegistered, data: $data, saveKeys: $saveKeys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetsCoreStateImpl &&
            (identical(other.initialized, initialized) ||
                other.initialized == initialized) &&
            (identical(other.synced, synced) || other.synced == synced) &&
            (identical(other.lastSync, lastSync) ||
                other.lastSync == lastSync) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.appRegistered, appRegistered) ||
                other.appRegistered == appRegistered) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            const DeepCollectionEquality().equals(other._saveKeys, _saveKeys));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      initialized,
      synced,
      lastSync,
      appVersion,
      appRegistered,
      const DeepCollectionEquality().hash(_data),
      const DeepCollectionEquality().hash(_saveKeys));

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetsCoreStateImplCopyWith<_$NetsCoreStateImpl> get copyWith =>
      __$$NetsCoreStateImplCopyWithImpl<_$NetsCoreStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetsCoreStateImplToJson(
      this,
    );
  }
}

abstract class _NetsCoreState implements NetsCoreState {
  const factory _NetsCoreState(
      {final bool initialized,
      final bool synced,
      final DateTime? lastSync,
      final double appVersion,
      final bool appRegistered,
      final Map<String, dynamic> data,
      final Map<String, bool> saveKeys}) = _$NetsCoreStateImpl;

  factory _NetsCoreState.fromJson(Map<String, dynamic> json) =
      _$NetsCoreStateImpl.fromJson;

  @override
  bool get initialized;
  @override
  bool get synced;
  @override
  DateTime? get lastSync;
  @override
  double get appVersion;
  @override
  bool get appRegistered;
  @override
  Map<String, dynamic> get data;
  @override
  Map<String, bool> get saveKeys;

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetsCoreStateImplCopyWith<_$NetsCoreStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
