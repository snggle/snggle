import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_text_field_model.dart';

class PinpadTextFields extends StatelessWidget {
  final bool obscureText;
  final PinpadController pinpadController;
  const PinpadTextFields({required this.pinpadController, this.obscureText = true, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: pinpadController.pinpadTextFieldModelList.length,
        itemBuilder: (BuildContext context, int index) {
          PinpadTextFieldModel pinpadModel = pinpadController.pinpadTextFieldModelList[index];
          return Container(
            alignment: Alignment.center,
            width: 75.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              key: Key('pinpad_text_field_$index'),
              obscureText: obscureText,
              enabled: false,
              controller: pinpadModel.textEditingController,
              focusNode: pinpadModel.focusNode,
              keyboardType: TextInputType.number,
              maxLength: 1,
              readOnly: true,
              showCursor: false,
              autofocus: false,
              autocorrect: false,
              onTap: () => pinpadController.updateFocus(pinpadModel),
              enableInteractiveSelection: false,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: '-',
                counter: Offstage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
