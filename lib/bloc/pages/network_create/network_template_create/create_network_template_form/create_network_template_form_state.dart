import 'package:equatable/equatable.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';

class CreateNetworkTemplateFormState extends Equatable {
  final LegacyDerivationPathSelectMenuItem selectedDerivationPath;
  final bool nameErrorBool;

  const CreateNetworkTemplateFormState({
    required this.selectedDerivationPath,
    this.nameErrorBool = false,
  });

  CreateNetworkTemplateFormState copyWith({
    LegacyDerivationPathSelectMenuItem? selectedDerivationPath,
    bool? nameErrorBool,
  }) {
    return CreateNetworkTemplateFormState(
      selectedDerivationPath: selectedDerivationPath ?? this.selectedDerivationPath,
      nameErrorBool: nameErrorBool ?? this.nameErrorBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedDerivationPath, nameErrorBool];
}
