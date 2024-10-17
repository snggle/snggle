enum VaultCreateRecoverStatus {
  creationSuccessful,
  recoverySuccessful,
  creationVaultRepeated,
  recoveryVaultRepeated,
}

extension VaultCreateRecoverStatusExtension on VaultCreateRecoverStatus {
  bool get isSuccessful {
    return this == VaultCreateRecoverStatus.creationSuccessful ||
        this == VaultCreateRecoverStatus.recoverySuccessful;
  }
}
