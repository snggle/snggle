import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/network_create/network_group_create/network_group_create_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_horizontal.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class NetworkGroupCreatePage extends StatefulWidget {
  final FilesystemPath parentFilesystemPath;
  final NetworkTemplateModel networkTemplateModel;

  const NetworkGroupCreatePage({
    required this.parentFilesystemPath,
    required this.networkTemplateModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _NetworkGroupCreatePageState();
}

class _NetworkGroupCreatePageState extends State<NetworkGroupCreatePage> {
  late final NetworkGroupCreatePageCubit networkGroupCreatePageCubit = NetworkGroupCreatePageCubit(parentFilesystemPath: widget.parentFilesystemPath);

  final ScrollController scrollController = ScrollController();
  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController derivationPathTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameTextEditingController.text = widget.networkTemplateModel.name;
    derivationPathTextEditingController.text = widget.networkTemplateModel.baseDerivationPath;
  }

  @override
  void dispose() {
    networkGroupCreatePageCubit.close();
    scrollController.dispose();
    nameTextEditingController.dispose();
    derivationPathTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return CustomScaffold(
      title: '${widget.networkTemplateModel.name} template'.toUpperCase(),
      body: KeyboardVisibilityBuilder(
        builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
          return ScrollableLayout(
            scrollController: scrollController,
            tooltipVisibleBool: nativeKeyboardVisibleBool == false,
            tooltipItems: <BottomTooltipItem>[
              BottomTooltipItem(
                label: 'Save',
                assetIconData: AppIcons.menu_save,
                onTap: _saveNetworkGroup,
              ),
            ],
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  AssetIcon(widget.networkTemplateModel.networkIconType.largeIcon, size: 114),
                  const SizedBox(height: 20),
                  LabelWrapperHorizontal(
                    label: 'Network Type',
                    child: GradientText(
                      widget.networkTemplateModel.name,
                      gradient: AppColors.primaryGradient,
                      textStyle: textTheme.labelMedium,
                    ),
                  ),
                  LabelWrapperVertical.textField(
                    label: 'Name',
                    child: CustomTextField(
                      textEditingController: nameTextEditingController,
                      inputBorder: InputBorder.none,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  LabelWrapperVertical.textField(
                    label: 'Derivation Path',
                    child: CustomTextField(
                      enabledBool: false,
                      textEditingController: derivationPathTextEditingController,
                      inputBorder: InputBorder.none,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveNetworkGroup() async {
    await CustomLoadingDialog.show<void>(
      context: context,
      title: 'Saving...',
      futureFunction: () async {
        await networkGroupCreatePageCubit.createNetworkGroup(nameTextEditingController.text, widget.networkTemplateModel);
      },
      onSuccess: (_) async {
        await AutoRouter.of(context).root.pop();
      },
    );
  }
}
