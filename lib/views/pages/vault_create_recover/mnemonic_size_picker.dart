import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';

typedef SizeSelectedCallback = void Function(MnemonicSize mnemonicSize);

class MnemonicSizePicker extends StatefulWidget {
  final SizeSelectedCallback onSizeSelected;
  final bool advancedWarningBool;

  const MnemonicSizePicker({
    required this.onSizeSelected,
    required this.advancedWarningBool,
    super.key,
  });

  @override
  _MnemonicSizePickerState createState() => _MnemonicSizePickerState();
}

class _MnemonicSizePickerState extends State<MnemonicSizePicker> {
  static List<MnemonicSize> standardMnemonicSizes = <MnemonicSize>[MnemonicSize.words12, MnemonicSize.words24];
  static List<MnemonicSize> advancedMnemonicSizes = <MnemonicSize>[MnemonicSize.words15, MnemonicSize.words18, MnemonicSize.words21];

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
          const SizedBox(height: 36),
          Text(
            'STANDARD',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.body3,
              letterSpacing: 1,
              height: 1,
            ),
          ),
          const SizedBox(height: 24),
          ...standardMnemonicSizes.map(
            (MnemonicSize mnemonicSize) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GradientOutlinedButton.large(
                  onPressed: () => widget.onSizeSelected(mnemonicSize),
                  label: mnemonicSize.wordCount.toString(),
                ),
              );
            },
          ),
          const SizedBox(height: 36),
          Container(
            height: 2,
            width: double.infinity,
            color: AppColors.lightGrey2,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          const SizedBox(height: 36),
          Text(
            'ADVANCED',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.body3,
              letterSpacing: 1,
              height: 1,
            ),
          ),
          const SizedBox(height: 24),
          ...advancedMnemonicSizes.map(
            (MnemonicSize mnemonicSize) {
              return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GradientOutlinedButton.large(
                    onPressed: () {
                      if (!widget.advancedWarningBool) {
                        widget.onSizeSelected(mnemonicSize);
                        return;
                      }

                      showDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (BuildContext context) => CustomDialog(
                          title: 'WARNING',
                          borderGradient: AppColors.warningOrangeGradient,
                          content: const Text(
                            'Non-standard mnemonic length may not be compatible with other wallets or signers.\nProceed?',
                            textAlign: TextAlign.center,
                          ),
                          options: <CustomDialogOption>[
                            CustomDialogOption(
                              label: 'No',
                              onPressed: () {},
                            ),
                            CustomDialogOption(
                              label: 'Yes',
                              labelColor: AppColors.warningOrange,
                              onPressed: () => widget.onSizeSelected(mnemonicSize),
                            ),
                          ],
                        ),
                      );
                    },
                    label: mnemonicSize.wordCount.toString(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
