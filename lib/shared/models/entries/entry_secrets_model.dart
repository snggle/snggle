import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntrySecretsModel extends ASecretsModel {
  final String? email;
  final String? username;
  final String? password;

  const EntrySecretsModel({
    required super.filesystemPath,
    this.email,
    this.username,
    this.password,
  });

  factory EntrySecretsModel.fromJson(FilesystemPath filesystemPath, Map<String, String?> json) {
    return EntrySecretsModel(
      filesystemPath: filesystemPath,
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  Map<String, String?> toJson() {
    return <String, String?>{
      'email': email,
      'username': username,
      'password': password,
    };
  }

  @override
  List<Object?> get props => <Object?>[email, username, password];
}
