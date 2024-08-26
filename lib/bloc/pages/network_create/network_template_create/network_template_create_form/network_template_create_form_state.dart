import 'package:equatable/equatable.dart';
import 'package:snggle/views/pages/network_create/network_template_create_page/legacy_derivation_path_select_menu/legacy_derivation_path_select_menu_item.dart';

class NetworkTemplateCreateFormState extends Equatable {
  final LegacyDerivationPathSelectMenuItem selectedDerivationPath;
  final bool nameErrorBool;

  const NetworkTemplateCreateFormState({
    required this.selectedDerivationPath,
    this.nameErrorBool = false,
  });

  NetworkTemplateCreateFormState copyWith({
    LegacyDerivationPathSelectMenuItem? selectedDerivationPath,
    bool? nameErrorBool,
  }) {
    return NetworkTemplateCreateFormState(
      selectedDerivationPath: selectedDerivationPath ?? this.selectedDerivationPath,
      nameErrorBool: nameErrorBool ?? this.nameErrorBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedDerivationPath, nameErrorBool];
}
