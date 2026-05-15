import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'package:snggle/infra/entities/credential_entity/credential_entity.dart';

class CredentialModel extends Equatable {
  final Id id;

  /// Reference to sensitive username/password stored outside Isar.
  final String secretId;

  /// Android package name, e.g. com.discord.
  final String packageName;

  /// Public display name, e.g. "Discord personal".
  final String? displayName;

  /// Optional public website/domain metadata.
  final String? website;

  final DateTime createdAt;

  final DateTime updatedAt;

  const CredentialModel({
    required this.id,
    required this.secretId,
    required this.packageName,
    required this.createdAt,
    required this.updatedAt,
    this.displayName,
    this.website,
  });

  factory CredentialModel.fromCredentialEntity(
    CredentialEntity credentialEntity,
  ) {
    return CredentialModel(
      id: credentialEntity.id,
      secretId: credentialEntity.secretId,
      packageName: credentialEntity.packageName,
      displayName: credentialEntity.displayName,
      website: credentialEntity.website,
      createdAt: credentialEntity.createdAt,
      updatedAt: credentialEntity.updatedAt,
    );
  }

  CredentialModel copyWith({
    Id? id,
    String? secretId,
    String? packageName,
    String? displayName,
    String? website,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CredentialModel(
      id: id ?? this.id,
      secretId: secretId ?? this.secretId,
      packageName: packageName ?? this.packageName,
      displayName: displayName ?? this.displayName,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get title {
    final String? trimmedDisplayName = displayName?.trim();

    if (trimmedDisplayName != null && trimmedDisplayName.isNotEmpty) {
      return trimmedDisplayName;
    }

    final String? trimmedWebsite = website?.trim();

    if (trimmedWebsite != null && trimmedWebsite.isNotEmpty) {
      return trimmedWebsite;
    }

    return packageName;
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        secretId,
        packageName,
        displayName,
        website,
        createdAt,
        updatedAt,
      ];
}
