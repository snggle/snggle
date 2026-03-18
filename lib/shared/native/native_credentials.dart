import 'package:flutter/services.dart';

class NativeCredentials {
  final String id;
  final String username;
  final String password;
  final String? packageName;

  const NativeCredentials({
    required this.id,
    required this.username,
    required this.password,
    required this.packageName,
  });

  factory NativeCredentials.fromMap(Map<String, dynamic> map) {
    return NativeCredentials(
      id: map['id'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      packageName: map['packageName'] as String?,
    );
  }
}

class NativeCredentialStore {
  static const MethodChannel _channel = MethodChannel('com.snggle.mobile/credentials');

  static Future<NativeCredentials> saveCredentials({
    required String username,
    required String password,
    String? packageName,
  }) async {
    Map<String, dynamic>? result = await _channel.invokeMapMethod<String, dynamic>(
      'saveCredentials',
      <String, String?>{
        'username': username,
        'password': password,
        'packageName': packageName,
      },
    );

    if (result == null) {
      throw Exception('Native saveCredentials returned null');
    }

    return NativeCredentials.fromMap(result);
  }

  static Future<List<NativeCredentials>> getAllCredentials() async {
    List<dynamic>? result = await _channel.invokeMethod<List<dynamic>>(
      'getAllCredentials',
    );

    if (result == null) {
      return const <NativeCredentials>[];
    }

    return result.map((dynamic item) => NativeCredentials.fromMap(item as Map<String, dynamic>)).toList();
  }

  static Future<bool> deleteCredential(String id) async {
    bool? result = await _channel.invokeMethod<bool>(
      'deleteCredential',
      <String, String>{'id': id},
    );

    return result ?? false;
  }

  static Future<void> clearCredentials() async {
    await _channel.invokeMethod('clearCredentials');
  }
}
