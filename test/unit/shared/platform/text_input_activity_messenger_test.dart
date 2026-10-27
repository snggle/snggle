import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/shared/platform/text_input_activity_messenger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const String textInputChannel = 'flutter/textinput';
  const JSONMethodCodec codec = JSONMethodCodec();

  late _FakeBinaryMessenger delegate;
  late TextInputActivityMessenger messenger;
  late int activityCount;
  late int forwardedCount;
  ByteData? handlerResponse;

  Future<void> setClient(int clientId) async {
    await messenger.send(
      textInputChannel,
      codec.encodeMethodCall(MethodCall('TextInput.setClient', <Object?>[clientId, const <String, Object?>{}])),
    );
  }

  Future<ByteData?> sendIncoming(String method, Object? arguments) {
    return delegate.dispatch(textInputChannel, codec.encodeMethodCall(MethodCall(method, arguments)));
  }

  setUp(() {
    delegate = _FakeBinaryMessenger();
    messenger = TextInputActivityMessenger(delegate: delegate);
    activityCount = 0;
    forwardedCount = 0;
    handlerResponse = null;

    messenger
      ..addListener(() {
        activityCount++;
      })
      ..setMessageHandler(textInputChannel, (ByteData? message) async {
        forwardedCount++;
        return handlerResponse;
      });
  });

  tearDown(() {
    messenger.dispose();
  });

  group('Tests of TextInputActivityMessenger.send()', () {
    test('Should [forward unchanged bytes and response] for [another channel]', () async {
      // Arrange
      ByteData request = ByteData(1)..setUint8(0, 7);
      ByteData response = ByteData(1)..setUint8(0, 9);
      delegate.sendResponse = response;

      // Act
      ByteData? actualResponse = await messenger.send('snggle/example', request);

      // Assert
      expect(delegate.sentChannels, <String>['snggle/example']);
      expect(delegate.sentMessages.single, same(request));
      expect(actualResponse, same(response));
      expect(activityCount, 0);
    });

    test('Should [forward TextInput.setClient] and [track its client]', () async {
      // Act
      await setClient(12);
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(delegate.sentChannels, <String>[textInputChannel]);
      expect(activityCount, 1);
      expect(forwardedCount, 1);
    });

    test('Should [ignore malformed outgoing bytes] without [losing the active client]', () async {
      // Arrange
      await setClient(12);
      ByteData malformedMessage = ByteData(1);

      // Act
      await messenger.send(textInputChannel, malformedMessage);
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(delegate.sentMessages.last, same(malformedMessage));
      expect(activityCount, 1);
    });

    for (Object? invalidArguments in <Object?>[
      null,
      <Object?>[],
      <Object?>['12'],
      12,
    ]) {
      test('Should [clear the active client] if [setClient arguments are $invalidArguments]', () async {
        // Arrange
        await setClient(12);

        // Act
        await messenger.send(textInputChannel, codec.encodeMethodCall(MethodCall('TextInput.setClient', invalidArguments)));
        await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

        // Assert
        expect(activityCount, 0);
        expect(forwardedCount, 1);
      });
    }

    test('Should [stop tracking] after [TextInput.clearClient]', () async {
      // Arrange
      await setClient(12);
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Act
      await messenger.send(textInputChannel, codec.encodeMethodCall(const MethodCall('TextInput.clearClient')));
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(activityCount, 1);
      expect(forwardedCount, 2);
    });

    test('Should [replace the previous client] when [setClient is called again]', () async {
      // Arrange
      await setClient(12);

      // Act
      await setClient(34);
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[34, <String, Object?>{}]);

      // Assert
      expect(activityCount, 1);
      expect(forwardedCount, 2);
    });
  });

  group('Tests of TextInputActivityMessenger.setMessageHandler()', () {
    test('Should [forward non-text-input handler] without [wrapping it]', () async {
      // Arrange
      ByteData response = ByteData(1);
      Future<ByteData?>? handler(ByteData? message) async => response;

      // Act
      messenger.setMessageHandler('snggle/example', handler);
      ByteData? actualResponse = await delegate.dispatch('snggle/example', ByteData(1));

      // Assert
      expect(delegate.handlers['snggle/example'], same(handler));
      expect(actualResponse, same(response));
      expect(activityCount, 0);
    });

    test('Should [remove the registered handler] when [handler is null]', () async {
      // Act
      messenger.setMessageHandler(textInputChannel, null);
      ByteData? actualResponse = await delegate.dispatch(textInputChannel, ByteData(1));

      // Assert
      expect(delegate.handlers[textInputChannel], isNull);
      expect(actualResponse, isNull);
      expect(forwardedCount, 0);
    });

    test('Should [forward incoming messages and original response] after [detecting activity]', () async {
      // Arrange
      ByteData expectedResponse = ByteData(1)..setUint8(0, 9);
      handlerResponse = expectedResponse;
      await setClient(12);

      // Act
      ByteData? actualResponse = await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(activityCount, 1);
      expect(forwardedCount, 1);
      expect(actualResponse, same(expectedResponse));
    });

    test('Should [forward messages] even when [activity is ignored]', () async {
      // Act
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(activityCount, 0);
      expect(forwardedCount, 1);
    });
  });

  group('Tests of TextInputActivityMessenger activity notifications', () {
    for (String activityMethod in const <String>[
      'TextInputClient.updateEditingState',
      'TextInputClient.updateEditingStateWithDeltas',
      'TextInputClient.performAction',
      'TextInputClient.performSelectors',
      'TextInputClient.updateFloatingCursor',
      'TextInputClient.updateEditingStateWithTag',
    ]) {
      test('Should [notify once] for [$activityMethod] from [the active client]', () async {
        // Arrange
        await setClient(12);

        // Act
        await sendIncoming(activityMethod, <Object?>[12, <String, Object?>{}]);

        // Assert
        expect(activityCount, 1);
        expect(forwardedCount, 1);
      });
    }

    test('Should [ignore activity] if [no client has been registered]', () async {
      // Act
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(activityCount, 0);
      expect(forwardedCount, 1);
    });

    test('Should [ignore activity] if [the client identifier does not match]', () async {
      // Arrange
      await setClient(12);

      // Act
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[34, <String, Object?>{}]);

      // Assert
      expect(activityCount, 0);
      expect(forwardedCount, 1);
    });

    test('Should [accept debug client -1] only in [debug mode]', () async {
      // Arrange
      await setClient(12);

      // Act
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[-1, <String, Object?>{}]);

      // Assert
      expect(activityCount, kDebugMode ? 1 : 0);
      expect(forwardedCount, 1);
    });

    test('Should [accept autofill] from [a different client identifier]', () async {
      // Arrange
      await setClient(12);

      // Act
      await sendIncoming('TextInputClient.updateEditingStateWithTag', <Object?>[34, <String, Object?>{}]);

      // Assert
      expect(activityCount, 1);
      expect(forwardedCount, 1);
    });

    test('Should [ignore autofill] if [there is no active client]', () async {
      // Act
      await sendIncoming('TextInputClient.updateEditingStateWithTag', <Object?>[34, <String, Object?>{}]);

      // Assert
      expect(activityCount, 0);
      expect(forwardedCount, 1);
    });

    test('Should [not notify] for [an unrelated TextInputClient method]', () async {
      // Arrange
      await setClient(12);

      // Act
      await sendIncoming('TextInputClient.requestExistingInputState', <Object?>[12]);

      // Assert
      expect(activityCount, 0);
      expect(forwardedCount, 1);
    });

    test('Should [clear the active client] after [TextInputClient.onConnectionClosed]', () async {
      // Arrange
      await setClient(12);

      // Act
      await sendIncoming('TextInputClient.onConnectionClosed', <Object?>[12]);
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(activityCount, 0);
      expect(forwardedCount, 2);
    });

    test('Should [not clear the active client] when [another connection closes]', () async {
      // Arrange
      await setClient(12);

      // Act
      await sendIncoming('TextInputClient.onConnectionClosed', <Object?>[34]);
      await sendIncoming('TextInputClient.updateEditingState', <Object?>[12, <String, Object?>{}]);

      // Assert
      expect(activityCount, 1);
      expect(forwardedCount, 2);
    });

    test('Should [ignore malformed incoming messages] and [forward all of them]', () async {
      // Arrange
      await setClient(12);
      List<ByteData?> incomingMessages = <ByteData?>[
        null,
        ByteData(1),
        codec.encodeMethodCall(const MethodCall('TextInputClient.updateEditingState')),
        codec.encodeMethodCall(const MethodCall('TextInputClient.updateEditingState', 12)),
        codec.encodeMethodCall(const MethodCall('TextInputClient.updateEditingState', <Object?>[])),
      ];

      // Act
      for (ByteData? incomingMessage in incomingMessages) {
        await delegate.dispatch(textInputChannel, incomingMessage);
      }

      // Assert
      expect(activityCount, 0);
      expect(forwardedCount, incomingMessages.length);
    });
  });

  group('Tests of TextInputActivityMessenger.handlePlatformMessage()', () {
    test('Should [deliver platform message and response] through [channel buffers]', () async {
      // Arrange
      const String channel = 'snggle/test/text_input_activity_messenger';
      ByteData request = ByteData(1)..setUint8(0, 1);
      ByteData response = ByteData(1)..setUint8(0, 2);
      ByteData? receivedResponse;

      ui.channelBuffers.setListener(channel, (ByteData? message, ui.PlatformMessageResponseCallback callback) {
        expect(message, same(request));
        callback(response);
      });
      addTearDown(() => ui.channelBuffers.clearListener(channel));

      // Act
      await messenger.handlePlatformMessage(channel, request, (ByteData? value) {
        receivedResponse = value;
      });

      // Assert
      expect(receivedResponse, same(response));
    });
  });
}

class _FakeBinaryMessenger implements BinaryMessenger {
  final Map<String, MessageHandler?> handlers = <String, MessageHandler?>{};
  final List<String> sentChannels = <String>[];
  final List<ByteData?> sentMessages = <ByteData?>[];

  ByteData? sendResponse;

  @override
  Future<ByteData?>? send(String channel, ByteData? message) {
    sentChannels.add(channel);
    sentMessages.add(message);
    return Future<ByteData?>.value(sendResponse);
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) {
    handlers[channel] = handler;
  }

  @override
  Future<void> handlePlatformMessage(
    String channel,
    ByteData? message,
    ui.PlatformMessageResponseCallback? callback,
  ) async {
    ByteData? response = await dispatch(channel, message);
    callback?.call(response);
  }

  Future<ByteData?> dispatch(String channel, ByteData? message) async {
    MessageHandler? handler = handlers[channel];
    if (handler == null) {
      return null;
    }
    return handler(message);
  }
}
