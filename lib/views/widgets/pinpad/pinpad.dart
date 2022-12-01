import 'package:flutter/material.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_button.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_controller.dart';

class Pinpad extends StatefulWidget {
  final bool pinpadShuffle;
  final double height;
  final double width;
  final PinpadController pinpadController;
  final VoidCallback onChanged;

  const Pinpad({
    required this.pinpadController,
    required this.onChanged,
    this.pinpadShuffle = false,
    this.height = double.infinity,
    this.width = double.infinity,
    super.key,
  });

  @override
  State<Pinpad> createState() => _PinpadState();
}

class _PinpadState extends State<Pinpad> {
  bool sorted = true;
  final List<int> numbers = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  void initState() {
    super.initState();
    widget.pinpadController.addListener(_handlePinpadValueChanged);
  }

  @override
  void didUpdateWidget(covariant Pinpad oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.pinpadController.removeListener(_handlePinpadValueChanged);
    widget.pinpadController.addListener(_handlePinpadValueChanged);
  }

  @override
  Widget build(BuildContext context) {
    _onShuffle();
    return Container(
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildNumRow(context, <int>[numbers[1], numbers[2], numbers[3]]),
          _buildNumRow(context, <int>[numbers[4], numbers[5], numbers[6]]),
          _buildNumRow(context, <int>[numbers[7], numbers[8], numbers[9]]),
          _buildSpecialRow(context)
        ],
      ),
    );
  }

  Widget _buildNumRow(BuildContext context, List<int> numbers) {
    List<Widget> buttonList = numbers
        .map((int buttonNum) => PinpadButton.number(
              numberValue: buttonNum,
              onTap: () => _onTapButton(buttonNum),
            ))
        .toList();
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttonList,
      ),
    );
  }

  Widget _buildSpecialRow(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          PinpadButton.number(
            numberValue: numbers[0],
            onTap: () => _onTapButton(numbers[0]),
          ),
          PinpadButton.icon(key: const Key('pinpad_backspace_button'), iconData: Icons.backspace, onTap: _onTapBackspaceButton),
        ],
      ),
    );
  }

  void _handlePinpadValueChanged() {
    widget.onChanged();
  }

  void _onTapButton(int number) {
    _onShuffle();
    widget.pinpadController.addPin(number);
  }

  void _onTapBackspaceButton() {
    _onShuffle();
    widget.pinpadController.removePin();
  }

  void _onShuffle() {
    if (widget.pinpadShuffle) {
      setState(numbers.shuffle);
      sorted = false;
    } else if (sorted == false && widget.pinpadShuffle == false) {
      setState(numbers.sort);
      sorted = true;
    }
  }
}
