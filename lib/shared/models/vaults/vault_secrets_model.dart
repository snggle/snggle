import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultSecretsModel extends ASecretsModel {
  final MnemonicModel mnemonicModel;

  const VaultSecretsModel({
    required super.filesystemPath,
    required this.mnemonicModel,
  });

  factory VaultSecretsModel.fromJson(FilesystemPath filesystemPath, Map<String, dynamic> json) {
    return VaultSecretsModel(
      filesystemPath: filesystemPath,
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
