import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:snggle/shared/models/credentials/credential_model.dart';

part 'credential_entity.g.dart';

@Collection(
  accessor: 'credentials',
  ignore: <String>{'props', 'stringify', 'hashCode'},
)
class CredentialEntity extends Equatable {
  final Id id;

  @Index(unique: true)
  final String secretId;

  @Index()
  final String packageName;

  final String? displayName;

  final String? website;

  final DateTime createdAt;

  final DateTime updatedAt;

  const CredentialEntity({
    required this.id,
    required this.secretId,
    required this.packageName,
    required this.createdAt,
    required this.updatedAt,
    this.displayName,
    this.website,
  });

  factory CredentialEntity.fromCredentialModel(
    CredentialModel credentialModel,
  ) {
    return CredentialEntity(
      id: credentialModel.id,
      secretId: credentialModel.secretId,
      packageName: credentialModel.packageName,
      displayName: credentialModel.displayName,
      website: credentialModel.website,
      createdAt: credentialModel.createdAt,
      updatedAt: credentialModel.updatedAt,
    );
  }

  CredentialEntity copyWith({
    Id? id,
    String? secretId,
    String? packageName,
    String? displayName,
    String? website,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CredentialEntity(
      id: id ?? this.id,
      secretId: secretId ?? this.secretId,
      packageName: packageName ?? this.packageName,
      displayName: displayName ?? this.displayName,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
