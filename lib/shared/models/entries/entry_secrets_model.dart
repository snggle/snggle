import 'package:snggle/shared/models/a_secrets_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class EntrySecretsModel extends ASecretsModel {
  final String email;
  final String username;
  final String password;
  final String totpSecret;

  const EntrySecretsModel({
    required super.filesystemPath,
    required this.email,
    required this.username,
    required this.password,
    required this.totpSecret,
  });

  factory EntrySecretsModel.fromJson(FilesystemPath filesystemPath, Map<String, dynamic> json) {
    return EntrySecretsModel(
      filesystemPath: filesystemPath,
      email: json['email'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      totpSecret: json['totpSecret'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'password': password,
      'totpSecret': totpSecret,
    };
  }

  @override
  List<Object?> get props => <Object?>[email, username, password, totpSecret];
}
