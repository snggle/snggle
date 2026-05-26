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
          border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 0.9),
        ),
        child: SegmentedButton<int>(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            ),
            minimumSize: WidgetStateProperty.all(const Size(0, 32)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            side: WidgetStateProperty.all(
              const BorderSide(color: Colors.white, width: 0.9),
            ),
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) => states.contains(WidgetState.selected) ? Colors.white : Colors.transparent,
            ),
            foregroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) => states.contains(WidgetState.selected) ? Colors.black : Colors.white,
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
