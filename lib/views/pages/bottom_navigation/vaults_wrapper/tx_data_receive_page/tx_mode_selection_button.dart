import 'package:flutter/material.dart';

// Previously this widget was under TxDataReceivePage and allowed selecting between QR and audio mode
class TxModeSelectionButton extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const TxModeSelectionButton({
    required this.index,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.5), width: 0.9),
        ),
        child: SegmentedButton<int>(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
            minimumSize: MaterialStateProperty.all(const Size(0, 32)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            side: MaterialStateProperty.all(
              const BorderSide(color: Colors.white, width: 0.9),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) => states.contains(MaterialState.selected) ? Colors.white : Colors.transparent,
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) => states.contains(MaterialState.selected) ? Colors.black : Colors.white,
            ),
            visualDensity: VisualDensity.compact,
          ),
          showSelectedIcon: false,
          segments: const <ButtonSegment<int>>[
            ButtonSegment<int>(
              value: 0,
              label: Text(
                'QR',
                style: TextStyle(fontSize: 11, height: 1.1),
              ),
            ),
            ButtonSegment<int>(
              value: 1,
              label: Text(
                'AUDIO',
                style: TextStyle(fontSize: 11, height: 1.1),
              ),
            ),
          ],
          selected: <int>{index},
          onSelectionChanged: (Set<int> newSelection) {
            onChanged(newSelection.first);
          },
        ),
      ),
    );
  }
}
