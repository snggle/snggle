import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';

typedef SizeSelectedCallback = void Function(int size);

class MnemonicSizePicker extends StatefulWidget {
  final SizeSelectedCallback onSizeSelected;

  const MnemonicSizePicker({
    required this.onSizeSelected,
    super.key,
  });

  @override
  _MnemonicSizePickerState createState() => _MnemonicSizePickerState();
}

class _MnemonicSizePickerState extends State<MnemonicSizePicker> {
  static const List<int> predefinedMnemonicSizes = <int>[12, 24];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Text(
            'Mnemonic words',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.body3,
              letterSpacing: 1,
              height: 1,
            ),
          ),
          const SizedBox(height: 24),
          ...predefinedMnemonicSizes.map(
            (int size) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GradientOutlinedButton.large(
                  onPressed: () => widget.onSizeSelected(size),
                  label: size.toString(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
