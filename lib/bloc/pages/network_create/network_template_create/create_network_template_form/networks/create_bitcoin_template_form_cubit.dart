import 'package:cryptography_utils/cryptography_utils.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/a_create_network_template_form_cubit.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';

class CreateBitcoinTemplateFormCubit extends ACreateNetworkTemplateFormCubit {
  static const List<LegacyDerivationPathSelectMenuItem> options = <LegacyDerivationPathSelectMenuItem>[
    LegacyDerivationPathSelectMenuItem(
      title: 'BIP 44',
      exampleAddress: '1xxx...xxx',
      derivationPathTemplate: "m/44'/0'/0'/{{y}}/{{i}}",
    ),
    LegacyDerivationPathSelectMenuItem(
      title: 'Ledger BIP 44',
      exampleAddress: '1xxx...xxx',
      derivationPathTemplate: "m/44'/0'/0'/{{i}}",
      derivationPathName: 'Ledger',
    ),
    LegacyDerivationPathSelectMenuItem(
      title: 'BIP 49',
      exampleAddress: '3xxx...xxx',
      derivationPathTemplate: "m/49'/0'/0'/{{y}}/{{i}}",
    ),
    LegacyDerivationPathSelectMenuItem(
      title: 'BIP 84',
      exampleAddress: 'bc1xxx...xxx',
      derivationPathTemplate: "m/84'/0'/0'/{{y}}/{{i}}",
    ),
  ];

  CreateBitcoinTemplateFormCubit({super.onErrorValueChanged})
      : super(
          predefinedNetworkTemplateModel: DefaultNetworkTemplates.bitcoin,
          baseDerivationPathSelectMenuItem: options.first,
        );

  @override
  Future<NetworkTemplateModel> buildNetworkTemplateModel() {
    String derivationPathTemplate = state.selectedDerivationPath.derivationPathTemplate;
    late ABlockchainAddressEncoder<ABip32PublicKey> addressEncoder;

    if (derivationPathTemplate.startsWith('m/44')) {
      addressEncoder = BitcoinP2PKHAddressEncoder();
    } else if (derivationPathTemplate.startsWith('m/49')) {
      addressEncoder = BitcoinP2SHAddressEncoder();
    } else {
      addressEncoder = BitcoinP2WPKHAddressEncoder(hrp: Slip173.bitcoin);
    }

    NetworkTemplateModel customNetworkTemplateModel = predefinedNetworkTemplateModel.copyWith(
      name: nameTextEditingController.text,
      derivationPathTemplate: state.selectedDerivationPath.derivationPathTemplate,
      derivationPathName: state.selectedDerivationPath.derivationPathName,
      predefinedNetworkTemplateId: predefinedNetworkTemplateModel.id,
      addressEncoder: addressEncoder,
    );

    return Future<NetworkTemplateModel>.value(customNetworkTemplateModel);
  }
}
