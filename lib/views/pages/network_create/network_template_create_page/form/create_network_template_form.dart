import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/form/networks/create_ethereum_template_form.dart';

abstract class CreateNetworkTemplateForm extends StatefulWidget {
  final ValueChanged<bool> onErrorValueChanged;

  const CreateNetworkTemplateForm({required this.onErrorValueChanged, super.key});

  static CreateNetworkTemplateForm auto({
    required GlobalKey<CreateNetworkTemplateFormWidgetState> key,
    required NetworkTemplateModel networkTemplateModel,
    required ValueChanged<bool> onErrorValueChanged,
  }) {
    if (networkTemplateModel.name == DefaultNetworkTemplates.ethereum.name) {
      return CreateEthereumTemplateForm(key: key, onErrorValueChanged: onErrorValueChanged);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  CreateNetworkTemplateFormWidgetState createState();
}

abstract class CreateNetworkTemplateFormWidgetState extends State<CreateNetworkTemplateForm> {
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
