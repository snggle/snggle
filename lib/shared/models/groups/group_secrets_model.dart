import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:crypto/crypto.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:uuid/uuid.dart';

class GroupSecretsModel extends ASecretsModel {
  final String challenge;

  const GroupSecretsModel({
    required super.containerPathModel,
    required this.challenge,
  });

  factory GroupSecretsModel.fromJson(ContainerPathModel containerPathModel, Map<String, dynamic> json) {
    return GroupSecretsModel(
      containerPathModel: containerPathModel,
      challenge: json['challenge'] as String,
    );
  }

  factory GroupSecretsModel.generate(ContainerPathModel containerPathModel) {
    return GroupSecretsModel(
      containerPathModel: containerPathModel,
      challenge: sha512.convert(const Uuid().v4().codeUnits).toString()
    );
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
