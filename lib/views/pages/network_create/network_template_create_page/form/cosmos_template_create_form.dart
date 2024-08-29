import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_form/network_template_create_form_state.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_form/networks/cosmos_template_create_form_cubit.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/a_network_template_create_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class CosmosTemplateCreateForm extends ANetworkTemplateCreateForm {
  const CosmosTemplateCreateForm({
    required super.onErrorValueChanged,
    super.key,
  });

  @override
  ANetworkTemplateCreateFormWidgetState createState() => CosmosTemplateCreateFormState();
}

class CosmosTemplateCreateFormState extends ANetworkTemplateCreateFormWidgetState {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode hrpFocusNode = FocusNode();

  late final CosmosTemplateCreateFormCubit cosmosTemplateCreateFormCubit = CosmosTemplateCreateFormCubit(onErrorValueChanged: widget.onErrorValueChanged);

  @override
  void dispose() {
    nameFocusNode.dispose();
    hrpFocusNode.dispose();
    cosmosTemplateCreateFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CosmosTemplateCreateFormCubit, NetworkTemplateCreateFormState>(
      bloc: cosmosTemplateCreateFormCubit,
      builder: (BuildContext context, NetworkTemplateCreateFormState networkTemplateCreateFormState) {
        return Column(
          children: <Widget>[
            LabelWrapperVertical.textField(
              label: 'Name',
              child: CustomTextField(
                textEditingController: cosmosTemplateCreateFormCubit.nameTextEditingController,
                inputBorder: InputBorder.none,
                keyboardType: TextInputType.text,
                focusNode: nameFocusNode,
                onFocusChanged: (_) => ensureFormFieldVisible(nameFocusNode),
              ),
            ),
            if (networkTemplateCreateFormState.nameErrorBool) ...<Widget>[
              const ErrorMessageListTile(message: 'Template name already exists, please choose a different name'),
            ],
            LabelWrapperVertical.textField(
              label: 'Address hrp',
              child: CustomTextField(
                textEditingController: cosmosTemplateCreateFormCubit.hrpTextEditingController,
                inputBorder: InputBorder.none,
                keyboardType: TextInputType.text,
                focusNode: hrpFocusNode,
                onFocusChanged: (_) => ensureFormFieldVisible(hrpFocusNode),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: cosmosTemplateCreateFormCubit.hrpTextEditingController,
              builder: (BuildContext context, TextEditingValue textEditingValue, _) {
                return LabelWrapperVertical(
                  label: 'Derivation Path',
                  bottomBorderVisibleBool: false,
                  child: LegacyDerivationPathSelectMenu(
                    options: CosmosTemplateCreateFormCubit.options
                        .map((LegacyDerivationPathSelectMenuItem e) => e.copyWith(exampleAddress: '${textEditingValue.text}1xxx...xxx'))
                        .toList(),
                    onSelected: cosmosTemplateCreateFormCubit.changeDerivationPath,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Future<NetworkTemplateModel?> save() async {
    return cosmosTemplateCreateFormCubit.save();
  }
}
