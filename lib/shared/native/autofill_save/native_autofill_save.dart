import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/shared/native/autofill_save/autofill_save_context.dart';

class NativeAutofillSave {
  NativeAutofillSave._();

  static const MethodChannel _channel = MethodChannel(
    'snggle/autofill_save',
  );

  static Future<AutofillSaveContext> getContext() async {
    final Map<Object?, Object?>? result =
    await _channel.invokeMapMethod<Object?, Object?>(
      'getAutofillSaveContext',
    );

    debugPrint('AUTOFILL SAVE CONTEXT: $result');

    if (result == null) {
      throw StateError('Autofill save context is missing');
    }

    return AutofillSaveContext.fromMap(result);
  }

  static Future<void> finish() async {
    await _channel.invokeMethod<void>(
      'finishAutofillSave',
    );
  }

  static Future<void> cancel() async {
    await _channel.invokeMethod<void>(
      'cancelAutofillSave',
    );
  }
}