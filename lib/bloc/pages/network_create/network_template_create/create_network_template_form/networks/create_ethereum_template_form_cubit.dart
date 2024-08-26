import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/a_create_network_template_form_cubit.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';

class CreateEthereumTemplateFormCubit extends ACreateNetworkTemplateFormCubit {
  static const List<LegacyDerivationPathSelectMenuItem> options = <LegacyDerivationPathSelectMenuItem>[
    LegacyDerivationPathSelectMenuItem(
      title: 'BIP 44',
      exampleAddress: '0x000...000',
      derivationPathTemplate: "m/44'/60'/0'/{{y}}/{{i}}",
    ),
    LegacyDerivationPathSelectMenuItem(
      title: 'Ledger',
      exampleAddress: '0x000...000',
      derivationPathTemplate: "m/44'/60'/0'/{{i}}",
      derivationPathName: 'Ledger',
    ),
  ];

  CreateEthereumTemplateFormCubit({super.onErrorValueChanged})
      : super(
          predefinedNetworkTemplateModel: DefaultNetworkTemplates.ethereum,
          baseDerivationPathSelectMenuItem: options.first,
        );

  @override
  Future<NetworkTemplateModel> buildNetworkTemplateModel() {
    NetworkTemplateModel customNetworkTemplateModel = predefinedNetworkTemplateModel.copyWith(
      name: nameTextEditingController.text,
      derivationPathTemplate: state.selectedDerivationPath.derivationPathTemplate,
      derivationPathName: state.selectedDerivationPath.derivationPathName,
      predefinedNetworkTemplateId: predefinedNetworkTemplateModel.id,
    );

    return Future<NetworkTemplateModel>.value(customNetworkTemplateModel);
  }
}
