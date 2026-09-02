import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/custom/custom_radio_button.dart';

typedef CustomSingleSelectItemBuilder<T> = Widget Function(BuildContext context, T option);
typedef CustomOptionBuilder<T> = Widget Function(BuildContext context, T customValue, ValueChanged<T> onChanged);

class CustomSingleSelectMenu<T> extends StatefulWidget {
  final T selectedValue;
  final List<T> options;
  final ValueChanged<T> onSelected;
  final CustomSingleSelectItemBuilder<T> itemBuilder;
  final CustomOptionBuilder<T>? customOptionBuilder;
  final T? defaultCustomValue;

  const CustomSingleSelectMenu({
    required this.selectedValue,
    required this.options,
    required this.onSelected,
    required this.itemBuilder,
    this.customOptionBuilder,
    this.defaultCustomValue,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomSingleSelectMenuState<T>();
}

class _CustomSingleSelectMenuState<T> extends State<CustomSingleSelectMenu<T>> {
  late T? customValue = widget.defaultCustomValue;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool customOptionAvailableBool = widget.customOptionBuilder != null;
    bool customOptionSelectedBool = widget.options.contains(widget.selectedValue) == false;

    return Column(
      children: <Widget>[
        for (T option in widget.options)
          GestureDetector(
            onTap: () => widget.onSelected(option),
            child: Container(
              height: 44,
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  CustomRadioButton(selectedBool: option == widget.selectedValue),
                  const SizedBox(width: 10),
                  Expanded(
                    child: widget.itemBuilder(context, option),
                  ),
                ],
              ),
            ),
          ),
        if (customOptionAvailableBool)
          GestureDetector(
            onTap: () => widget.onSelected(customValue as T),
            child: Column(
              children: <Widget>[
                Container(
                  height: 44,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      CustomRadioButton(selectedBool: widget.options.contains(widget.selectedValue) == false),
                      const SizedBox(width: 10),
                      Text(
                        'Custom',
                        style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                      ),
                    ],
                  ),
                ),
                if (customOptionSelectedBool)
                  widget.customOptionBuilder!(
                    context,
                    customValue as T,
                    widget.onSelected,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
