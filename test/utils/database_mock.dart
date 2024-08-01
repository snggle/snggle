enum DatabaseMock {
  // Mocks of the real database that may occur in the application
  emptyDatabaseMock,
  fullDatabaseMock,
  masterKeyOnlyDatabaseMock,

  // Test only database mocks for classes with generic usage
  testSecretsMock,
  testEncryptedFilesystemMock,
  testDecryptedFilesystemMock,
}
