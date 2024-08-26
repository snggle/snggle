import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_page/network_template_create_page_cubit.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/a_network_template_create_form.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_single_select_menu.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class NetworkTemplateCreatePage extends StatefulWidget {
  const NetworkTemplateCreatePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetworkTemplateCreatePageState();
}

class _NetworkTemplateCreatePageState extends State<NetworkTemplateCreatePage> {
  static List<NetworkTemplateModel> options = DefaultNetworkTemplates.values;

  final GlobalKey<ANetworkTemplateCreateFormWidgetState> formKey = GlobalKey<ANetworkTemplateCreateFormWidgetState>();
  final NetworkTemplateCreatePageCubit networkTemplateCreatePageCubit = NetworkTemplateCreatePageCubit();
  final NetworkTemplateModel defaultNetworkTemplateModel = options.first;
  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> finishButtonActiveNotifier = ValueNotifier<bool>(true);
  late final ValueNotifier<NetworkTemplateModel> baseNetworkTemplateNotifier = ValueNotifier<NetworkTemplateModel>(defaultNetworkTemplateModel);

  @override
  void dispose() {
    formKey.currentState?.dispose();
    networkTemplateCreatePageCubit.close();
    scrollController.dispose();
    baseNetworkTemplateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return CustomScaffold(
      title: 'Network Template',
      resizeToAvoidBottomInsetBool: true,
      body: KeyboardVisibilityBuilder(
        builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
          return ScrollableLayout(
            scrollController: scrollController,
            tooltipVisibleBool: nativeKeyboardVisibleBool == false,
            tooltipItems: <Widget>[
              ValueListenableBuilder<bool>(
                valueListenable: finishButtonActiveNotifier,
                builder: (BuildContext context, bool finishButtonActiveBool, _) {
                  return BottomTooltipItem(
                    label: 'Save',
                    assetIconData: AppIcons.menu_save,
                    onTap: finishButtonActiveBool ? _saveNetworkTemplate : null,
                  );
                },
              ),
            ],
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  ValueListenableBuilder<NetworkTemplateModel>(
                    valueListenable: baseNetworkTemplateNotifier,
                    builder: (BuildContext context, NetworkTemplateModel selectedNetworkTemplateModel, _) {
                      return AssetIcon(size: 114, selectedNetworkTemplateModel.networkIconType.largeIcon);
                    },
                  ),
                  const SizedBox(height: 20),
                  ValueListenableBuilder<NetworkTemplateModel>(
                    valueListenable: baseNetworkTemplateNotifier,
                    builder: (BuildContext context, NetworkTemplateModel selectedBaseNetworkTemplateModel, _) {
                      return Column(
                        children: <Widget>[
                          LabelWrapperVertical(
                            label: 'Network Type',
                            child: CustomSingleSelectMenu<NetworkTemplateModel>(
                              selectedValue: selectedBaseNetworkTemplateModel,
                              options: options,
                              onSelected: (NetworkTemplateModel networkTemplateModel) => baseNetworkTemplateNotifier.value = networkTemplateModel,
                              itemBuilder: (BuildContext context, NetworkTemplateModel networkTemplateModel) {
                                return Text(
                                  networkTemplateModel.name,
                                  style: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
                                );
                              },
                            ),
                          ),
                          ANetworkTemplateCreateForm.auto(
                            key: formKey,
                            networkTemplateModel: selectedBaseNetworkTemplateModel,
                            onErrorValueChanged: (bool value) => finishButtonActiveNotifier.value = value == false,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _saveNetworkTemplate() async {
    await CustomLoadingDialog.show<NetworkTemplateModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: () async {
        NetworkTemplateModel? selectedNetworkTemplateModel = await formKey.currentState?.save();
        if (selectedNetworkTemplateModel != null) {
          await networkTemplateCreatePageCubit.save(selectedNetworkTemplateModel);
        }

        return selectedNetworkTemplateModel;
      },
      onSuccess: (NetworkTemplateModel? selectedNetworkTemplateModel) async {
        if (selectedNetworkTemplateModel != null) {
          await AutoRouter.of(context).pop();
        }
      },
    );
  }
}
