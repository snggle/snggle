import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';

class VaultSecretsModel extends ASecretsModel {
  final MnemonicModel mnemonicModel;

  const VaultSecretsModel({
    required super.containerPathModel,
    required this.mnemonicModel,
  });

  factory VaultSecretsModel.fromJson(ContainerPathModel containerPathModel, Map<String, dynamic> json) {
    return VaultSecretsModel(
      containerPathModel: containerPathModel,
      mnemonicModel: MnemonicModel.fromString(json['mnemonic'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mnemonic': mnemonicModel.toString(),
    };
  }

  @override
  List<Object?> get props => <Object>[mnemonicModel];
}
