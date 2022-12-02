import 'package:flutter/material.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_text_field_model.dart';

class PinpadController extends ChangeNotifier {
  final int pinpadTextFieldsSize;
  late PinpadTextFieldModel selectedPinpadTextFieldModel;
  late final List<PinpadTextFieldModel> pinpadTextFieldModelList;

  PinpadController({required this.pinpadTextFieldsSize}) {
    pinpadTextFieldModelList = List<PinpadTextFieldModel>.generate(pinpadTextFieldsSize, (int index) => PinpadTextFieldModel(index: index));
    selectedPinpadTextFieldModel = pinpadTextFieldModelList[0];
  }

  void addPin(int number) {
    if (selectedPinpadTextFieldModel.textEditingController.text.isEmpty) {
      selectedPinpadTextFieldModel.textEditingController.text = number.toString();
      _focusNextPinpadTextField();
      notifyListeners();
    }
  }

  void clear() {
    for (PinpadTextFieldModel pinpadTextFieldModel in pinpadTextFieldModelList) {
      pinpadTextFieldModel.textEditingController.clear();
    }
    selectedPinpadTextFieldModel = pinpadTextFieldModelList[0];
    requestFirstFocus();
  }

  void requestFirstFocus() {
    selectedPinpadTextFieldModel = pinpadTextFieldModelList.first;
    selectedPinpadTextFieldModel.focusNode.requestFocus();
  }

  void removePin() {
    if (selectedPinpadTextFieldModel.textEditingController.text.isEmpty) {
      _focusPreviousPinpadTextField();
    }
    selectedPinpadTextFieldModel.textEditingController.clear();
    notifyListeners();
  }

  void updateFocus(PinpadTextFieldModel pinpadTextFieldModel) {
    selectedPinpadTextFieldModel = pinpadTextFieldModel;
  }

  String get value {
    return pinpadTextFieldModelList.map((PinpadTextFieldModel pinpadTextFieldModel) => pinpadTextFieldModel.textEditingController.text).join();
  }

  void _focusPreviousPinpadTextField() {
    int selectedPosition = selectedPinpadTextFieldModel.index;
    bool canFocus = selectedPosition > 0;
    if (canFocus) {
      selectedPinpadTextFieldModel = pinpadTextFieldModelList[selectedPosition - 1];
      selectedPinpadTextFieldModel.focusNode.requestFocus();
    }
  }

  void _focusNextPinpadTextField() {
    int selectedPosition = selectedPinpadTextFieldModel.index;
    bool canFocus = selectedPosition < pinpadTextFieldModelList.length - 1;
    if (canFocus) {
      selectedPinpadTextFieldModel = pinpadTextFieldModelList[selectedPosition + 1];
      selectedPinpadTextFieldModel.focusNode.requestFocus();
    }
  }
}
