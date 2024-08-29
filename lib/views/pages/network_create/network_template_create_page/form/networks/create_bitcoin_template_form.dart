import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/create_network_template_form_state.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/networks/create_bitcoin_template_form_cubit.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/create_network_template_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class CreateBitcoinTemplateForm extends CreateNetworkTemplateForm {
  const CreateBitcoinTemplateForm({
    required super.onErrorValueChanged,
    super.key,
  });

  @override
  CreateNetworkTemplateFormWidgetState createState() => _CreateBitcoinTemplateFormState();
}

class _CreateBitcoinTemplateFormState extends CreateNetworkTemplateFormWidgetState {
  final FocusNode nameFocusNode = FocusNode();
  late final CreateBitcoinTemplateFormCubit createBitcoinTemplateFormCubit = CreateBitcoinTemplateFormCubit(onErrorValueChanged: widget.onErrorValueChanged);

  @override
  void dispose() {
    nameFocusNode.dispose();
    createBitcoinTemplateFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBitcoinTemplateFormCubit, CreateNetworkTemplateFormState>(
      bloc: createBitcoinTemplateFormCubit,
      builder: (BuildContext context, CreateNetworkTemplateFormState createNetworkTemplateFormState) {
        return Column(
          children: <Widget>[
            LabelWrapperVertical.textField(
              label: 'Name',
              child: CustomTextField(
                textEditingController: createBitcoinTemplateFormCubit.nameTextEditingController,
                inputBorder: InputBorder.none,
                keyboardType: TextInputType.text,
                focusNode: nameFocusNode,
                onFocusChanged: (_) => ensureFormFieldVisible(nameFocusNode),
              ),
            ),
            if (createNetworkTemplateFormState.nameErrorBool) ...<Widget>[
              const ErrorMessageListTile(message: 'Template name already exists, please choose a different name'),
            ],
            LabelWrapperVertical(
              label: 'Derivation Path',
              bottomBorderVisibleBool: false,
              child: LegacyDerivationPathSelectMenu(
                options: CreateBitcoinTemplateFormCubit.options,
                onSelected: createBitcoinTemplateFormCubit.changeDerivationPath,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Future<NetworkTemplateModel?> save() async {
    return createBitcoinTemplateFormCubit.save();
  }
}
