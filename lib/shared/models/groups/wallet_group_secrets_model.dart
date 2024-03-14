import 'package:crypto/crypto.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:uuid/uuid.dart';

class WalletGroupSecretsModel extends ASecretsModel {
  final String challenge;

  const WalletGroupSecretsModel({
    required super.containerPathModel,
    required this.challenge,
  });

  factory WalletGroupSecretsModel.fromJson(ContainerPathModel containerPathModel, Map<String, dynamic> json) {
    return WalletGroupSecretsModel(
      containerPathModel: containerPathModel,
      challenge: json['challenge'] as String,
    );
  }

  factory WalletGroupSecretsModel.generate(ContainerPathModel containerPathModel) {
    return WalletGroupSecretsModel(containerPathModel: containerPathModel, challenge: sha512.convert(const Uuid().v4().codeUnits).toString());
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'challenge': challenge,
    };
  }

  @override
  List<Object?> get props => <Object>[challenge];
}
