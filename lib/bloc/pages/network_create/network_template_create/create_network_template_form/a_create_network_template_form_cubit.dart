import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/network_create/network_template_create/create_network_template_form/create_network_template_form_state.dart';
import 'package:snggle/infra/services/network_templates_service.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';

abstract class ACreateNetworkTemplateFormCubit extends Cubit<CreateNetworkTemplateFormState> {
  final NetworkTemplatesService _networkTemplatesService = NetworkTemplatesService();
  final TextEditingController nameTextEditingController = TextEditingController();

  final NetworkTemplateModel predefinedNetworkTemplateModel;
  final LegacyDerivationPathSelectMenuItem baseDerivationPathSelectMenuItem;
  final ValueChanged<bool>? onErrorValueChanged;

  ACreateNetworkTemplateFormCubit({
    required this.predefinedNetworkTemplateModel,
    required this.baseDerivationPathSelectMenuItem,
    this.onErrorValueChanged,
  }) : super(CreateNetworkTemplateFormState(selectedDerivationPath: baseDerivationPathSelectMenuItem)) {
    nameTextEditingController
      ..addListener(_handleNameChanged)
      ..text = predefinedNetworkTemplateModel.name;
  }

  @override
  Future<void> close() {
    nameTextEditingController.dispose();
    return super.close();
  }

  void changeDerivationPath(LegacyDerivationPathSelectMenuItem derivationPathSelectMenuItem) {
    emit(state.copyWith(selectedDerivationPath: derivationPathSelectMenuItem));
  }

  Future<NetworkTemplateModel?> save() async {
    String name = nameTextEditingController.text.trim();
    if ((await _networkTemplatesService.isNameUnique(name)) == false) {
      onErrorValueChanged?.call(true);
      emit(state.copyWith(nameErrorBool: true));
      return null;
    }

    NetworkTemplateModel customNetworkTemplateModel = await buildNetworkTemplateModel();
    await _networkTemplatesService.save(customNetworkTemplateModel);
    return customNetworkTemplateModel;
  }

  Future<void> _handleNameChanged() async {
    if (state.nameErrorBool == true) {
      onErrorValueChanged?.call(false);
      emit(state.copyWith(nameErrorBool: false));
    }
  }

  @protected
  Future<NetworkTemplateModel> buildNetworkTemplateModel();
}
