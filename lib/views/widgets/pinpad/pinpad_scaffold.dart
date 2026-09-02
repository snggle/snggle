import 'package:flutter/material.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_dots_area.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_keyboard.dart';

class PinpadScaffold extends StatefulWidget {
  final bool errorBool;
  final bool popButtonVisibleBool;
  final String title;
  final List<int> initialPinNumbersList;
  final List<Widget> actionButtonsList;
  final ValueChanged<List<int>> onChanged;
  final VoidCallback? customPopVoidCallback;
  final PinpadKeyboardState initPinpadKeyboardState;
  final ValueChanged<PinpadKeyboardState>? onKeyboardChanged;
  final int maxPinLength;
  final Widget? header;

  const PinpadScaffold({
    required this.errorBool,
    required this.popButtonVisibleBool,
    required this.title,
    required this.initialPinNumbersList,
    required this.actionButtonsList,
    required this.onChanged,
    this.customPopVoidCallback,
    this.initPinpadKeyboardState = PinpadKeyboardState.initPinpadKeyboardState,
    this.onKeyboardChanged,
    this.maxPinLength = 8,
    this.header,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PinpadScaffoldState();
}

class _PinpadScaffoldState extends State<PinpadScaffold> {
  final ValueNotifier<List<int>> pinNumbersNotifier = ValueNotifier<List<int>>(<int>[]);

  @override
  void didUpdateWidget(covariant PinpadScaffold oldWidget) {
    if (widget.initialPinNumbersList != oldWidget.initialPinNumbersList) {
      pinNumbersNotifier.value = widget.initialPinNumbersList;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    pinNumbersNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      popButtonVisible: widget.popButtonVisibleBool,
      customPopCallback: widget.customPopVoidCallback,
      title: widget.title,
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 22, left: 16, right: 16),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 16),
                if (widget.header != null) ...<Widget>[
                  widget.header!,
                  const SizedBox(height: 12),
                ],
                ValueListenableBuilder<List<int>>(
                  valueListenable: pinNumbersNotifier,
                  builder: (BuildContext context, List<int> enteredNumbers, _) {
                    return Expanded(
                      flex: 1,
                      child: PinpadDotsArea(
                        errorBool: widget.errorBool,
                        pinNumbers: enteredNumbers,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 3,
                  child: PinpadKeyboard(
                    onNumberPressed: _addPinNumber,
                    onBackspacePressed: _removePinLastNumber,
                    initPinpadKeyboardState: widget.initPinpadKeyboardState,
                    onKeyboardChanged: widget.onKeyboardChanged,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: Row(children: widget.actionButtonsList.map((Widget widget) => Expanded(child: widget)).toList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addPinNumber(int number) {
    if (pinNumbersNotifier.value.length < widget.maxPinLength) {
      List<int> newEnteredNumbers = <int>[...pinNumbersNotifier.value, number];
      pinNumbersNotifier.value = newEnteredNumbers;
      widget.onChanged.call(newEnteredNumbers);
    }
  }

  void _removePinLastNumber() {
    if (pinNumbersNotifier.value.isNotEmpty) {
      List<int> newEnteredNumbers = pinNumbersNotifier.value.sublist(0, pinNumbersNotifier.value.length - 1);
      pinNumbersNotifier.value = newEnteredNumbers;
      widget.onChanged.call(newEnteredNumbers);
    }
  }
}
