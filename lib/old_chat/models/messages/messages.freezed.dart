// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messages.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Message {
  String get sendMessages => throw _privateConstructorUsedError;
  String get receiveMessages => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  bool get isLoadingResponse => throw _privateConstructorUsedError;
  File? get file => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String sendMessages,
      String receiveMessages,
      String id,
      bool isLoadingResponse,
      File? file});
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sendMessages = null,
    Object? receiveMessages = null,
    Object? id = null,
    Object? isLoadingResponse = null,
    Object? file = freezed,
  }) {
    return _then(_value.copyWith(
      sendMessages: null == sendMessages
          ? _value.sendMessages
          : sendMessages // ignore: cast_nullable_to_non_nullable
              as String,
      receiveMessages: null == receiveMessages
          ? _value.receiveMessages
          : receiveMessages // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isLoadingResponse: null == isLoadingResponse
          ? _value.isLoadingResponse
          : isLoadingResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessagesImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessagesImplCopyWith(
          _$MessagesImpl value, $Res Function(_$MessagesImpl) then) =
      __$$MessagesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sendMessages,
      String receiveMessages,
      String id,
      bool isLoadingResponse,
      File? file});
}

/// @nodoc
class __$$MessagesImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessagesImpl>
    implements _$$MessagesImplCopyWith<$Res> {
  __$$MessagesImplCopyWithImpl(
      _$MessagesImpl _value, $Res Function(_$MessagesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sendMessages = null,
    Object? receiveMessages = null,
    Object? id = null,
    Object? isLoadingResponse = null,
    Object? file = freezed,
  }) {
    return _then(_$MessagesImpl(
      sendMessages: null == sendMessages
          ? _value.sendMessages
          : sendMessages // ignore: cast_nullable_to_non_nullable
              as String,
      receiveMessages: null == receiveMessages
          ? _value.receiveMessages
          : receiveMessages // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isLoadingResponse: null == isLoadingResponse
          ? _value.isLoadingResponse
          : isLoadingResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

/// @nodoc

class _$MessagesImpl with DiagnosticableTreeMixin implements _Messages {
  const _$MessagesImpl(
      {required this.sendMessages,
      required this.receiveMessages,
      required this.id,
      required this.isLoadingResponse,
      this.file});

  @override
  final String sendMessages;
  @override
  final String receiveMessages;
  @override
  final String id;
  @override
  final bool isLoadingResponse;
  @override
  final File? file;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Message(sendMessages: $sendMessages, receiveMessages: $receiveMessages, id: $id, isLoadingResponse: $isLoadingResponse, file: $file)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Message'))
      ..add(DiagnosticsProperty('sendMessages', sendMessages))
      ..add(DiagnosticsProperty('receiveMessages', receiveMessages))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('isLoadingResponse', isLoadingResponse))
      ..add(DiagnosticsProperty('file', file));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessagesImpl &&
            (identical(other.sendMessages, sendMessages) ||
                other.sendMessages == sendMessages) &&
            (identical(other.receiveMessages, receiveMessages) ||
                other.receiveMessages == receiveMessages) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isLoadingResponse, isLoadingResponse) ||
                other.isLoadingResponse == isLoadingResponse) &&
            (identical(other.file, file) || other.file == file));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, sendMessages, receiveMessages, id, isLoadingResponse, file);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessagesImplCopyWith<_$MessagesImpl> get copyWith =>
      __$$MessagesImplCopyWithImpl<_$MessagesImpl>(this, _$identity);
}

abstract class _Messages implements Message {
  const factory _Messages(
      {required final String sendMessages,
      required final String receiveMessages,
      required final String id,
      required final bool isLoadingResponse,
      final File? file}) = _$MessagesImpl;

  @override
  String get sendMessages;
  @override
  String get receiveMessages;
  @override
  String get id;
  @override
  bool get isLoadingResponse;
  @override
  File? get file;
  @override
  @JsonKey(ignore: true)
  _$$MessagesImplCopyWith<_$MessagesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
