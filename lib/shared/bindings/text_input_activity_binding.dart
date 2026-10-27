import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:snggle/shared/platform/text_input_activity_messenger.dart';

class TextInputActivityBinding extends WidgetsFlutterBinding {
  @override
  BinaryMessenger createBinaryMessenger() {
    return TextInputActivityMessenger(delegate: super.createBinaryMessenger());
  }
}

