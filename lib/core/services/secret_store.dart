import 'dart:io';

import 'secret_store_windows.dart';

abstract class SecretStore {
  Future<void> saveOpenAiApiKey(String key);

  Future<String?> readOpenAiApiKey();

  Future<void> deleteOpenAiApiKey();
}

class InMemorySecretStore implements SecretStore {
  String? _key;

  @override
  Future<void> deleteOpenAiApiKey() async {
    _key = null;
  }

  @override
  Future<String?> readOpenAiApiKey() async {
    return _key;
  }

  @override
  Future<void> saveOpenAiApiKey(String key) async {
    _key = key;
  }
}

SecretStore createDefaultSecretStore() {
  if (Platform.isWindows) {
    return WindowsCredentialSecretStore();
  }
  return InMemorySecretStore();
}
