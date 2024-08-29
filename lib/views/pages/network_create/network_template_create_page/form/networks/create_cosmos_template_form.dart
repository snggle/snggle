import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/create_network_template_form_state.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/networks/create_cosmos_template_form_cubit.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/create_network_template_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class CreateCosmosTemplateForm extends CreateNetworkTemplateForm {
  const CreateCosmosTemplateForm({
    required super.onErrorValueChanged,
    super.key,
  });

  @override
  CreateNetworkTemplateFormWidgetState createState() => CreateCosmosTemplateFormState();
}

class CreateCosmosTemplateFormState extends CreateNetworkTemplateFormWidgetState {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode hrpFocusNode = FocusNode();

  late final CreateCosmosTemplateFormCubit createCosmosTemplateFormCubit = CreateCosmosTemplateFormCubit(onErrorValueChanged: widget.onErrorValueChanged);

  @override
  void dispose() {
    nameFocusNode.dispose();
    hrpFocusNode.dispose();
    createCosmosTemplateFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCosmosTemplateFormCubit, CreateNetworkTemplateFormState>(
      bloc: createCosmosTemplateFormCubit,
      builder: (BuildContext context, CreateNetworkTemplateFormState createNetworkTemplateFormState) {
        return Column(
          children: <Widget>[
            LabelWrapperVertical.textField(
              label: 'Name',
              child: CustomTextField(
                textEditingController: createCosmosTemplateFormCubit.nameTextEditingController,
                inputBorder: InputBorder.none,
                keyboardType: TextInputType.text,
                focusNode: nameFocusNode,
                onFocusChanged: (_) => ensureFormFieldVisible(nameFocusNode),
              ),
            ),
            if (createNetworkTemplateFormState.nameErrorBool) ...<Widget>[
              const ErrorMessageListTile(message: 'Template name already exists, please choose a different name'),
            ],
            LabelWrapperVertical.textField(
              label: 'Address hrp',
              child: CustomTextField(
                textEditingController: createCosmosTemplateFormCubit.hrpTextEditingController,
                inputBorder: InputBorder.none,
                keyboardType: TextInputType.text,
                focusNode: hrpFocusNode,
                onFocusChanged: (_) => ensureFormFieldVisible(hrpFocusNode),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: createCosmosTemplateFormCubit.hrpTextEditingController,
              builder: (BuildContext context, TextEditingValue textEditingValue, _) {
                return LabelWrapperVertical(
                  label: 'Derivation Path',
                  bottomBorderVisibleBool: false,
                  child: LegacyDerivationPathSelectMenu(
                    options: CreateCosmosTemplateFormCubit.options
                        .map((LegacyDerivationPathSelectMenuItem e) => e.copyWith(exampleAddress: '${textEditingValue.text}1xxx...xxx'))
                        .toList(),
                    onSelected: createCosmosTemplateFormCubit.changeDerivationPath,
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
    return createCosmosTemplateFormCubit.save();
  }
}
