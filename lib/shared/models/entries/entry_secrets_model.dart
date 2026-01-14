import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntrySecretsModel extends ASecretsModel {
  final String? username;
  final String? password;

  const EntrySecretsModel({
    required super.filesystemPath,
    this.username,
    this.password,
  });

  factory EntrySecretsModel.fromJson(FilesystemPath filesystemPath, Map<String, dynamic> json) {
    return EntrySecretsModel(
      filesystemPath: filesystemPath,
      username: json['username'] as String?,
      password: json['password'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
    };
  }

  @override
  List<Object?> get props => <Object?>[username, password];
}
