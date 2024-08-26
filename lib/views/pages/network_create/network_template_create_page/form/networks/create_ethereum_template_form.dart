import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/create_network_template_form_state.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/networks/create_ethereum_template_form_cubit.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/create_network_template_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class CreateEthereumTemplateForm extends CreateNetworkTemplateForm {
  const CreateEthereumTemplateForm({
    required super.onErrorValueChanged,
    super.key,
  });

  @override
  CreateNetworkTemplateFormWidgetState createState() => CreateEthereumTemplateFormState();
}

class CreateEthereumTemplateFormState extends CreateNetworkTemplateFormWidgetState {
  final FocusNode nameFocusNode = FocusNode();
  late final CreateEthereumTemplateFormCubit createEthereumTemplateFormCubit = CreateEthereumTemplateFormCubit(onErrorValueChanged: widget.onErrorValueChanged);

  @override
  void dispose() {
    nameFocusNode.dispose();
    createEthereumTemplateFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEthereumTemplateFormCubit, CreateNetworkTemplateFormState>(
      bloc: createEthereumTemplateFormCubit,
      builder: (BuildContext context, CreateNetworkTemplateFormState createNetworkTemplateFormState) {
        return Column(
          children: <Widget>[
            LabelWrapperVertical.textField(
              label: 'Name',
              child: CustomTextField(
                textEditingController: createEthereumTemplateFormCubit.nameTextEditingController,
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
                options: CreateEthereumTemplateFormCubit.options,
                onSelected: createEthereumTemplateFormCubit.changeDerivationPath,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Future<NetworkTemplateModel?> save() async {
    return createEthereumTemplateFormCubit.save();
  }
}
