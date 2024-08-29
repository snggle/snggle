import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_form/network_template_create_form_state.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/network_template_create_form/networks/bitcoin_template_create_form_cubit.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/a_network_template_create_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';

class BitcoinTemplateCreateForm extends ANetworkTemplateCreateForm {
  const BitcoinTemplateCreateForm({
    required super.onErrorValueChanged,
    super.key,
  });

  @override
  ANetworkTemplateCreateFormWidgetState createState() => _BitcoinTemplateCreateFormState();
}

class _BitcoinTemplateCreateFormState extends ANetworkTemplateCreateFormWidgetState {
  final FocusNode nameFocusNode = FocusNode();
  late final BitcoinTemplateCreateFormCubit bitcoinTemplateCreateFormCubit = BitcoinTemplateCreateFormCubit(onErrorValueChanged: widget.onErrorValueChanged);

  @override
  void dispose() {
    nameFocusNode.dispose();
    bitcoinTemplateCreateFormCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BitcoinTemplateCreateFormCubit, NetworkTemplateCreateFormState>(
      bloc: bitcoinTemplateCreateFormCubit,
      builder: (BuildContext context, NetworkTemplateCreateFormState networkTemplateCreateFormState) {
        return Column(
          children: <Widget>[
            LabelWrapperVertical.textField(
              label: 'Name',
              child: CustomTextField(
                textEditingController: bitcoinTemplateCreateFormCubit.nameTextEditingController,
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
                options: BitcoinTemplateCreateFormCubit.options,
                onSelected: bitcoinTemplateCreateFormCubit.changeDerivationPath,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Future<NetworkTemplateModel?> save() async {
    return bitcoinTemplateCreateFormCubit.save();
  }
}
