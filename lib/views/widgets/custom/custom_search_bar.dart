import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CustomSearchBar({
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.lightGrey1),
        ),
      ),
      child: CustomTextField(
        onChanged: onChanged,
        prefixIcon: SizedBox(
          width: 30,
          child: Align(
            alignment: Alignment.centerLeft,
            child: AssetIcon(AppIcons.search, size: 16, color: AppColors.middleGrey),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 30),
        inputBorder: InputBorder.none,
        keyboardType: TextInputType.text,
      ),
    );
  }
}
