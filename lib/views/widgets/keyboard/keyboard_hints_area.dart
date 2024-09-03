import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class KeyboardHintsArea extends StatefulWidget {
  final ValueChanged<String> onHintSelected;
  final List<String> hints;

  const KeyboardHintsArea({
    required this.onHintSelected,
    required this.hints,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _KeyboardHintsAreaState();
}

class _KeyboardHintsAreaState extends State<KeyboardHintsArea> {
  final ScrollController hintsScrollController = ScrollController();

  @override
  void dispose() {
    hintsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: () => hintsScrollController.animateTo(
            hintsScrollController.offset - 150,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          ),
          icon: const AssetIcon(AppIcons.keyboard_arrow_left, size: 24),
        ),
        Expanded(
          child: Center(
            child: ListView.separated(
              shrinkWrap: true,
              controller: hintsScrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.hints.length,
              itemBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => widget.onHintSelected(widget.hints[index]),
                    borderRadius: BorderRadius.circular(9.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      child: Text(widget.hints[index]),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 16,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: VerticalDivider(color: AppColors.middleGrey, width: 1, thickness: 1),
                  ),
                );
              },
            ),
          ),
        ),
        IconButton(
          onPressed: () => hintsScrollController.animateTo(
            hintsScrollController.offset + 150,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          ),
          icon: const AssetIcon(AppIcons.keyboard_arrow_right, size: 24),
        ),
      ],
    );
  }
}
