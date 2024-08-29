import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/bitcoin_template_create_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/cosmos_template_create_form.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/ethereum_template_create_form.dart';

abstract class ANetworkTemplateCreateForm extends StatefulWidget {
  final ValueChanged<bool> onErrorValueChanged;

  const ANetworkTemplateCreateForm({required this.onErrorValueChanged, super.key});

  static ANetworkTemplateCreateForm auto({
    required GlobalKey<ANetworkTemplateCreateFormWidgetState> key,
    required NetworkTemplateModel networkTemplateModel,
    required ValueChanged<bool> onErrorValueChanged,
  }) {
    if (networkTemplateModel.name == DefaultNetworkTemplates.ethereum.name) {
      return EthereumTemplateCreateForm(key: key, onErrorValueChanged: onErrorValueChanged);
    } else if (networkTemplateModel.name == DefaultNetworkTemplates.cosmos.name) {
      return CosmosTemplateCreateForm(key: key, onErrorValueChanged: onErrorValueChanged);
    } else if (networkTemplateModel.name == DefaultNetworkTemplates.bitcoin.name) {
      return BitcoinTemplateCreateForm(key: key, onErrorValueChanged: onErrorValueChanged);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  ANetworkTemplateCreateFormWidgetState createState();
}

abstract class ANetworkTemplateCreateFormWidgetState extends State<ANetworkTemplateCreateForm> {
  Future<NetworkTemplateModel?> save();

  Future<void> ensureFormFieldVisible(FocusNode focusNode) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (focusNode.hasFocus && focusNode.context != null) {
      await Scrollable.ensureVisible(
        focusNode.context!,
        alignment: 0.4,
        duration: const Duration(milliseconds: 150),
      );
    }
  }
}
