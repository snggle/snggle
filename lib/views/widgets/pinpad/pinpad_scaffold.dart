import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_dots_area.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_keyboard.dart';

class PinpadScaffold extends StatefulWidget {
  final bool errorBool;
  final String title;
  final List<int> initialPinNumbers;
  final List<Widget> actionButtons;
  final ValueChanged<List<int>> onChanged;
  final int maxPinLength;
  final Widget? timerWidget;

  const PinpadScaffold({
    required this.errorBool,
    required this.title,
    required this.initialPinNumbers,
    required this.actionButtons,
    required this.onChanged,
    this.maxPinLength = 8,
    this.timerWidget,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PinpadScaffoldState();
}

class _PinpadScaffoldState extends State<PinpadScaffold> {
  final ValueNotifier<List<int>> pinNumbersNotifier = ValueNotifier<List<int>>(<int>[]);

  @override
  void didUpdateWidget(covariant PinpadScaffold oldWidget) {
    if (widget.initialPinNumbers != oldWidget.initialPinNumbers) {
      pinNumbersNotifier.value = widget.initialPinNumbers;
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
      popButtonVisible: false,
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
                if(widget.timerWidget != null)
                  widget.timerWidget!,
                const SizedBox(height: 16),
                Expanded(
                  flex: 3,
                  child: PinpadKeyboard(
                    onNumberPressed: _addPinNumber,
                    onBackspacePressed: _removeLastPinNumber,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: Row(children: widget.actionButtons.map((Widget widget) => Expanded(child: widget)).toList()),
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

  void _removeLastPinNumber() {
    if (pinNumbersNotifier.value.isNotEmpty) {
      List<int> newEnteredNumbers = pinNumbersNotifier.value.sublist(0, pinNumbersNotifier.value.length - 1);
      pinNumbersNotifier.value = newEnteredNumbers;
      widget.onChanged.call(newEnteredNumbers);
    }
  }
}
