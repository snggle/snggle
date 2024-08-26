import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/formatters/legacy_derivation_path_input_formatter.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';
import 'package:snggle/views/widgets/custom/custom_single_select_menu.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';

class LegacyDerivationPathSelectMenu extends StatefulWidget {
  final List<LegacyDerivationPathSelectMenuItem> options;
  final ValueChanged<LegacyDerivationPathSelectMenuItem> onSelected;

  const LegacyDerivationPathSelectMenu({
    required this.options,
    required this.onSelected,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LegacyDerivationPathSelectMenuState();
}

class _LegacyDerivationPathSelectMenuState extends State<LegacyDerivationPathSelectMenu> {
  final TextEditingController customDerivationPathController = TextEditingController();
  late final ValueNotifier<LegacyDerivationPathSelectMenuItem> derivationPathNotifier = ValueNotifier<LegacyDerivationPathSelectMenuItem>(widget.options.first);

  @override
  void initState() {
    super.initState();
    customDerivationPathController.addListener(_handleCustomDerivationPathChanged);
  }

  @override
  void dispose() {
    customDerivationPathController.dispose();
    derivationPathNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ValueListenableBuilder<LegacyDerivationPathSelectMenuItem>(
      valueListenable: derivationPathNotifier,
      builder: (BuildContext context, LegacyDerivationPathSelectMenuItem selectedDerivationPathSelectMenuItem, _) {
        return CustomSingleSelectMenu<LegacyDerivationPathSelectMenuItem>(
          selectedValue: selectedDerivationPathSelectMenuItem,
          options: widget.options,
          defaultCustomValue: const LegacyDerivationPathSelectMenuItem.custom('m/'),
          onSelected: _handlePredefinedDerivationPathChanged,
          itemBuilder: (BuildContext context, LegacyDerivationPathSelectMenuItem derivationPathSelectMenuItem) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    derivationPathSelectMenuItem.title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GradientText(
                        derivationPathSelectMenuItem.exampleAddress,
                        gradient: AppColors.primaryGradient,
                        textStyle: theme.textTheme.labelMedium?.copyWith(height: 1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        derivationPathSelectMenuItem.exampleDerivationPath,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.labelMedium?.copyWith(color: AppColors.middleGrey, height: 1),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
          customOptionBuilder: (BuildContext context, _, ValueChanged<LegacyDerivationPathSelectMenuItem> onChanged) {
            return CustomTextField(
              keyboardType: TextInputType.text,
              textEditingController: customDerivationPathController,
              prefixIcon: Align(
                alignment: Alignment.centerLeft,
                child: Text('m/', style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.middleGrey)),
              ),
              prefixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 25),
              inputBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightGrey1)),
              inputFormatters: <TextInputFormatter>[
                LegacyDerivationPathInputFormatter(),
              ],
            );
          },
        );
      },
    );
  }

  void _handlePredefinedDerivationPathChanged(LegacyDerivationPathSelectMenuItem derivationPathSelectMenuItem) {
    derivationPathNotifier.value = derivationPathSelectMenuItem;
    widget.onSelected(derivationPathSelectMenuItem);
  }

  void _handleCustomDerivationPathChanged() {
    String customDerivationPath = 'm/${customDerivationPathController.text}';
    if (customDerivationPath.endsWith('/')) {
      customDerivationPath = customDerivationPath.substring(0, customDerivationPath.length - 1);
    }
    widget.onSelected(LegacyDerivationPathSelectMenuItem.custom(customDerivationPath));
  }
}
