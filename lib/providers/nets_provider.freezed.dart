// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nets_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NetsCoreState {
  bool get initialized;
  bool get synced;
  DateTime? get lastSync;
  double get appVersion;
  bool get appRegistered;
  Map<String, dynamic> get data;
  Map<String, bool> get saveKeys;

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NetsCoreStateCopyWith<NetsCoreState> get copyWith =>
      _$NetsCoreStateCopyWithImpl<NetsCoreState>(
          this as NetsCoreState, _$identity);

  /// Serializes this NetsCoreState to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NetsCoreState &&
            (identical(other.initialized, initialized) ||
                other.initialized == initialized) &&
            (identical(other.synced, synced) || other.synced == synced) &&
            (identical(other.lastSync, lastSync) ||
                other.lastSync == lastSync) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.appRegistered, appRegistered) ||
                other.appRegistered == appRegistered) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            const DeepCollectionEquality().equals(other.saveKeys, saveKeys));
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
      const DeepCollectionEquality().hash(data),
      const DeepCollectionEquality().hash(saveKeys));

  @override
  String toString() {
    return 'NetsCoreState(initialized: $initialized, synced: $synced, lastSync: $lastSync, appVersion: $appVersion, appRegistered: $appRegistered, data: $data, saveKeys: $saveKeys)';
  }
}

/// @nodoc
abstract mixin class $NetsCoreStateCopyWith<$Res> {
  factory $NetsCoreStateCopyWith(
          NetsCoreState value, $Res Function(NetsCoreState) _then) =
      _$NetsCoreStateCopyWithImpl;
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
class _$NetsCoreStateCopyWithImpl<$Res>
    implements $NetsCoreStateCopyWith<$Res> {
  _$NetsCoreStateCopyWithImpl(this._self, this._then);

  final NetsCoreState _self;
  final $Res Function(NetsCoreState) _then;

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
    return _then(_self.copyWith(
      initialized: null == initialized
          ? _self.initialized
          : initialized // ignore: cast_nullable_to_non_nullable
              as bool,
      synced: null == synced
          ? _self.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSync: freezed == lastSync
          ? _self.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appVersion: null == appVersion
          ? _self.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as double,
      appRegistered: null == appRegistered
          ? _self.appRegistered
          : appRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _self.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      saveKeys: null == saveKeys
          ? _self.saveKeys
          : saveKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

/// Adds pattern-matching-related methods to [NetsCoreState].
extension NetsCoreStatePatterns on NetsCoreState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NetsCoreState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NetsCoreState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NetsCoreState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetsCoreState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NetsCoreState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetsCoreState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            bool initialized,
            bool synced,
            DateTime? lastSync,
            double appVersion,
            bool appRegistered,
            Map<String, dynamic> data,
            Map<String, bool> saveKeys)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NetsCoreState() when $default != null:
        return $default(_that.initialized, _that.synced, _that.lastSync,
            _that.appVersion, _that.appRegistered, _that.data, _that.saveKeys);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            bool initialized,
            bool synced,
            DateTime? lastSync,
            double appVersion,
            bool appRegistered,
            Map<String, dynamic> data,
            Map<String, bool> saveKeys)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetsCoreState():
        return $default(_that.initialized, _that.synced, _that.lastSync,
            _that.appVersion, _that.appRegistered, _that.data, _that.saveKeys);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            bool initialized,
            bool synced,
            DateTime? lastSync,
            double appVersion,
            bool appRegistered,
            Map<String, dynamic> data,
            Map<String, bool> saveKeys)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetsCoreState() when $default != null:
        return $default(_that.initialized, _that.synced, _that.lastSync,
            _that.appVersion, _that.appRegistered, _that.data, _that.saveKeys);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NetsCoreState implements NetsCoreState {
  const _NetsCoreState(
      {this.initialized = false,
      this.synced = false,
      this.lastSync,
      this.appVersion = 0.1,
      this.appRegistered = false,
      final Map<String, dynamic> data = const <String, dynamic>{},
      final Map<String, bool> saveKeys = const <String, bool>{}})
      : _data = data,
        _saveKeys = saveKeys;
  factory _NetsCoreState.fromJson(Map<String, dynamic> json) =>
      _$NetsCoreStateFromJson(json);

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

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NetsCoreStateCopyWith<_NetsCoreState> get copyWith =>
      __$NetsCoreStateCopyWithImpl<_NetsCoreState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NetsCoreStateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NetsCoreState &&
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

  @override
  String toString() {
    return 'NetsCoreState(initialized: $initialized, synced: $synced, lastSync: $lastSync, appVersion: $appVersion, appRegistered: $appRegistered, data: $data, saveKeys: $saveKeys)';
  }
}

/// @nodoc
abstract mixin class _$NetsCoreStateCopyWith<$Res>
    implements $NetsCoreStateCopyWith<$Res> {
  factory _$NetsCoreStateCopyWith(
          _NetsCoreState value, $Res Function(_NetsCoreState) _then) =
      __$NetsCoreStateCopyWithImpl;
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
class __$NetsCoreStateCopyWithImpl<$Res>
    implements _$NetsCoreStateCopyWith<$Res> {
  __$NetsCoreStateCopyWithImpl(this._self, this._then);

  final _NetsCoreState _self;
  final $Res Function(_NetsCoreState) _then;

  /// Create a copy of NetsCoreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? initialized = null,
    Object? synced = null,
    Object? lastSync = freezed,
    Object? appVersion = null,
    Object? appRegistered = null,
    Object? data = null,
    Object? saveKeys = null,
  }) {
    return _then(_NetsCoreState(
      initialized: null == initialized
          ? _self.initialized
          : initialized // ignore: cast_nullable_to_non_nullable
              as bool,
      synced: null == synced
          ? _self.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSync: freezed == lastSync
          ? _self.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      appVersion: null == appVersion
          ? _self.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as double,
      appRegistered: null == appRegistered
          ? _self.appRegistered
          : appRegistered // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _self._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      saveKeys: null == saveKeys
          ? _self._saveKeys
          : saveKeys // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
    ));
  }
}

// dart format on
