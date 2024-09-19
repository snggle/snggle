enum DatabaseMock {
  // Mocks of the real database that may occur in the application
  emptyDatabaseMock,
  fullDatabaseMock,
  fullDatabaseMockWithPasswords,
  masterKeyOnlyDatabaseMock,
  transactionsDatabaseMock,

  // Test only database mocks for classes with generic usage
  testSecretsMock,
  testEncryptedFilesystemMock,
  testDecryptedFilesystemMock,
}
