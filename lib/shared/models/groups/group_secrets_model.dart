import 'package:crypto/crypto.dart';
import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:uuid/uuid.dart';

class GroupSecretsModel extends ASecretsModel {
  final String challenge;

  const GroupSecretsModel({
    required super.filesystemPath,
    required this.challenge,
  });

  factory GroupSecretsModel.fromJson(FilesystemPath filesystemPath, Map<String, dynamic> json) {
    return GroupSecretsModel(
      filesystemPath: filesystemPath,
      challenge: json['challenge'] as String,
    );
  }

  factory GroupSecretsModel.generate(FilesystemPath filesystemPath) {
    return GroupSecretsModel(filesystemPath: filesystemPath, challenge: sha512.convert(const Uuid().v4().codeUnits).toString());
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
