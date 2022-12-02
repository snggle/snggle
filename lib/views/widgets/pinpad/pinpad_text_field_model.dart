import 'package:flutter/material.dart';

class PinpadTextFieldModel {
  final int index;
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();

  PinpadTextFieldModel({required this.index});
}
