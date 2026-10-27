import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class TextInputActivityMessenger extends ChangeNotifier implements BinaryMessenger {
  static const String _autofillMethod = 'TextInputClient.updateEditingStateWithTag';
  static const String _channelName = 'flutter/textinput';
  static const Set<String> _activityMethods = <String>{
    'TextInputClient.updateEditingState',
    'TextInputClient.updateEditingStateWithDeltas',
    'TextInputClient.performAction',
    'TextInputClient.performSelectors',
    'TextInputClient.updateFloatingCursor',
    _autofillMethod,
  };
  static const JSONMethodCodec _jsonMethodCodec = JSONMethodCodec();

  final BinaryMessenger _delegateBinaryMessenger;
  int? _clientId;

  TextInputActivityMessenger({required BinaryMessenger delegate}) : _delegateBinaryMessenger = delegate;

  @override
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? messageByteData,
    ui.PlatformMessageResponseCallback? platformMessageResponseCallback,
  ) async {
    ui.channelBuffers.push(channel, messageByteData, (ByteData? responseByteData) => platformMessageResponseCallback?.call(responseByteData));
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? messageByteData) {
    bool textInputChannelBool = channel == _channelName;
    if (textInputChannelBool) {
      _handleOutgoing(messageByteData);
    }
    return _delegateBinaryMessenger.send(channel, messageByteData);
  }

  @override
  void setMessageHandler(String channel, MessageHandler? messageHandler) {
    bool forwardedHandlerBool = channel != _channelName || messageHandler == null;
    if (forwardedHandlerBool) {
      _delegateBinaryMessenger.setMessageHandler(channel, messageHandler);
      return;
    }

    MessageHandler flutterMessageHandler = messageHandler;
    _delegateBinaryMessenger.setMessageHandler(channel, (ByteData? messageByteData) {
      try {
        _handleIncoming(messageByteData);
      } catch (_) {}
      return flutterMessageHandler(messageByteData);
    });
  }

  MethodCall? _decodeMessage(ByteData? messageByteData) {
    bool messageMissingBool = messageByteData == null;
    if (messageMissingBool) {
      return null;
    }
    try {
      return _jsonMethodCodec.decodeMethodCall(messageByteData);
    } catch (_) {
      return null;
    }
  }

  void _handleIncoming(ByteData? messageByteData) {
    MethodCall? methodCall = _decodeMessage(messageByteData);
    bool ignoredMessageBool = methodCall == null || _clientId == null;
    if (ignoredMessageBool) {
      return;
    }

    MethodCall decodedMethodCall = methodCall;
    Object? arguments = decodedMethodCall.arguments;
    bool invalidArgumentsBool = arguments is! List<dynamic> || arguments.isEmpty;
    if (invalidArgumentsBool) {
      return;
    }

    List<dynamic> argumentsList = arguments;
    bool autofillBool = decodedMethodCall.method == _autofillMethod;
    bool matchingClientBool = argumentsList.first == _clientId;
    bool debugClientBool = kDebugMode && argumentsList.first == -1;
    bool acceptedClientBool = autofillBool || matchingClientBool || debugClientBool;
    if (acceptedClientBool == false) {
      return;
    }

    bool connectionClosedBool = decodedMethodCall.method == 'TextInputClient.onConnectionClosed';
    if (connectionClosedBool) {
      _clientId = null;
      return;
    }

    bool userActivityBool = _activityMethods.contains(decodedMethodCall.method);
    if (userActivityBool) {
      notifyListeners();
    }
  }

  void _handleOutgoing(ByteData? messageByteData) {
    MethodCall? methodCall = _decodeMessage(messageByteData);
    switch (methodCall?.method) {
      case 'TextInput.setClient':
        _clientId = switch (methodCall!.arguments) {
          [int clientId, ...] => clientId,
          _ => null,
        };
        break;
      case 'TextInput.clearClient':
        _clientId = null;
        break;
    }
  }
}
