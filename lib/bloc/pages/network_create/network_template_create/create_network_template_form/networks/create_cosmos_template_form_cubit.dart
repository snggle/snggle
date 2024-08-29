import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:flutter/material.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/a_create_network_template_form_cubit.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';

class CreateCosmosTemplateFormCubit extends ACreateNetworkTemplateFormCubit {
  static const List<LegacyDerivationPathSelectMenuItem> options = <LegacyDerivationPathSelectMenuItem>[
    LegacyDerivationPathSelectMenuItem(
      title: 'BIP 44',
      exampleAddress: 'cosmos1xxx...xxx',
      derivationPathTemplate: "m/44'/118'/0'/{{y}}/{{i}}",
    ),
    LegacyDerivationPathSelectMenuItem(
      title: 'Ledger',
      exampleAddress: 'cosmos1xxx...xxx',
      derivationPathTemplate: "m/44'/118'/0'/{{i}}",
      derivationPathName: 'Ledger',
    ),
  ];

  final TextEditingController hrpTextEditingController = TextEditingController();

  CreateCosmosTemplateFormCubit({super.onErrorValueChanged})
      : super(
          predefinedNetworkTemplateModel: DefaultNetworkTemplates.cosmos,
          baseDerivationPathSelectMenuItem: options.first,
        ) {
    hrpTextEditingController.text = 'cosmos';
  }

  @override
  Future<void> close() {
    hrpTextEditingController.dispose();
    return super.close();
  }

  @override
  Future<NetworkTemplateModel> buildNetworkTemplateModel() {
    NetworkTemplateModel customNetworkTemplateModel = predefinedNetworkTemplateModel.copyWith(
      name: nameTextEditingController.text,
      derivationPathTemplate: state.selectedDerivationPath.derivationPathTemplate,
      derivationPathName: state.selectedDerivationPath.derivationPathName,
      predefinedNetworkTemplateId: predefinedNetworkTemplateModel.id,
      addressEncoder: CosmosAddressEncoder(hrp: hrpTextEditingController.text),
    );

    return Future<NetworkTemplateModel>.value(customNetworkTemplateModel);
  }
}
