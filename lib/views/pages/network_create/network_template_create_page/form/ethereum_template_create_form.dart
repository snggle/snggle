import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_form/network_template_create_form_state.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_form/networks/ethereum_template_create_form_cubit.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/a_network_template_create_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class EthereumTemplateCreateForm extends ANetworkTemplateCreateForm {
  const EthereumTemplateCreateForm({
    required super.onErrorValueChanged,
    super.key,
  });

  @override
  ANetworkTemplateCreateFormWidgetState createState() => EthereumTemplateCreateFormState();
}

class EthereumTemplateCreateFormState extends ANetworkTemplateCreateFormWidgetState {
  final FocusNode nameFocusNode = FocusNode();
  late final EthereumTemplateCreateFormCubit ethereumTemplateCreateFormCubit = EthereumTemplateCreateFormCubit(onErrorValueChanged: widget.onErrorValueChanged);

  @override
  void dispose() {
    nameFocusNode.dispose();
    ethereumTemplateCreateFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EthereumTemplateCreateFormCubit, NetworkTemplateCreateFormState>(
      bloc: ethereumTemplateCreateFormCubit,
      builder: (BuildContext context, NetworkTemplateCreateFormState networkTemplateCreateFormState) {
        return Column(
          children: <Widget>[
            LabelWrapperVertical.textField(
              label: 'Name',
              child: CustomTextField(
                textEditingController: ethereumTemplateCreateFormCubit.nameTextEditingController,
                inputBorder: InputBorder.none,
                keyboardType: TextInputType.text,
                focusNode: nameFocusNode,
                onFocusChanged: (_) => ensureFormFieldVisible(nameFocusNode),
              ),
            ),
            if (networkTemplateCreateFormState.nameErrorBool) ...<Widget>[
              const ErrorMessageListTile(message: 'Template name already exists, please choose a different name'),
            ],
            LabelWrapperVertical(
              label: 'Derivation Path',
              bottomBorderVisibleBool: false,
              child: LegacyDerivationPathSelectMenu(
                options: EthereumTemplateCreateFormCubit.options,
                onSelected: ethereumTemplateCreateFormCubit.changeDerivationPath,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Future<NetworkTemplateModel?> save() async {
    return ethereumTemplateCreateFormCubit.save();
  }
}
