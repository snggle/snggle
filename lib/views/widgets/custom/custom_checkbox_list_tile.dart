import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';

class CustomCheckboxListTile extends StatefulWidget {
  final bool initialValue;
  final String title;
  final ValueChanged<bool> onChanged;
  final BoxBorder? selectedBorder;
  final BoxBorder? unselectedBorder;

  const CustomCheckboxListTile({
    required this.initialValue,
    required this.title,
    required this.onChanged,
    this.selectedBorder,
    this.unselectedBorder,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => CustomCheckboxListTileState();
}

class CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  late bool selectedBool = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: _pressCheckbox,
      child: Container(
        padding: (widget.selectedBorder != null || widget.unselectedBorder != null) ? const EdgeInsets.all(14) : null,
        decoration: BoxDecoration(
          border: selectedBool ? widget.selectedBorder : widget.unselectedBorder,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CustomCheckbox(selectedBool: selectedBool),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.title,
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.body3,
                  height: 1.16,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pressCheckbox() {
    setState(() => selectedBool = selectedBool == false);
    widget.onChanged(selectedBool);
  }
}
