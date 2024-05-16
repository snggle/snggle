import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_dot.dart';

class PinpadDotsArea extends StatefulWidget {
  final bool errorBool;
  final List<int> pinNumbers;

  const PinpadDotsArea({
    required this.errorBool,
    required this.pinNumbers,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PinpadDotsAreaState();
}

class _PinpadDotsAreaState extends State<PinpadDotsArea> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              for (int i = 0; i < 4; i++)
                Expanded(
                  child: PinpadDot(
                    errorBool: widget.errorBool,
                    number: widget.pinNumbers.length > i ? widget.pinNumbers[i] : null,
                  ),
                ),
            ],
          ),
        ),
        if (widget.pinNumbers.length > 4)
          Expanded(
            child: Row(
              children: <Widget>[
                for (int i = 4; i < 8; i++)
                  Expanded(
                    child: widget.pinNumbers.length > i
                        ? PinpadDot(
                            errorBool: widget.errorBool,
                            number: widget.pinNumbers[i],
                          )
                        : const SizedBox(),
                  ),
              ],
            ),
          )
        else
          const Spacer()
      ],
    );
  }
}
