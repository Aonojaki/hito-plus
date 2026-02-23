import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'secret_store.dart';

class WindowsCredentialSecretStore implements SecretStore {
  static const String _targetName = 'hito_plus_openai_api_key';
  static const String _userName = 'hito_plus_user';

  @override
  Future<void> saveOpenAiApiKey(String key) async {
    final userNamePointer = _userName.toNativeUtf16();
    final targetNamePointer = _targetName.toNativeUtf16();
    final keyBytes = Uint8List.fromList(utf8.encode(key));
    final blobPointer = calloc<Uint8>(keyBytes.length);
    blobPointer.asTypedList(keyBytes.length).setAll(0, keyBytes);
    final credential = calloc<CREDENTIAL>()
      ..ref.Type = CRED_TYPE_GENERIC
      ..ref.TargetName = targetNamePointer
      ..ref.Persist = CRED_PERSIST_LOCAL_MACHINE
      ..ref.UserName = userNamePointer
      ..ref.CredentialBlob = blobPointer
      ..ref.CredentialBlobSize = keyBytes.length;

    try {
      if (CredWrite(credential, 0) != TRUE) {
        throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
      }
    } finally {
      free(blobPointer);
      free(credential);
      free(userNamePointer);
      free(targetNamePointer);
    }
  }

  @override
  Future<String?> readOpenAiApiKey() async {
    final targetNamePointer = _targetName.toNativeUtf16();
    final credentialPointer = calloc<Pointer<CREDENTIAL>>();

    try {
      if (CredRead(
            targetNamePointer,
            CRED_TYPE_GENERIC,
            0,
            credentialPointer,
          ) !=
          TRUE) {
        final errorCode = GetLastError();
        if (errorCode == ERROR_NOT_FOUND) {
          return null;
        }
        throw WindowsException(HRESULT_FROM_WIN32(errorCode));
      }

      final credential = credentialPointer.value.ref;
      final blob = credential.CredentialBlob.asTypedList(
        credential.CredentialBlobSize,
      );
      return utf8.decode(blob);
    } finally {
      if (credentialPointer.value.address != 0) {
        CredFree(credentialPointer.value);
      }
      free(credentialPointer);
      free(targetNamePointer);
    }
  }

  @override
  Future<void> deleteOpenAiApiKey() async {
    final targetNamePointer = _targetName.toNativeUtf16();

    try {
      if (CredDelete(targetNamePointer, CRED_TYPE_GENERIC, 0) != TRUE) {
        final errorCode = GetLastError();
        if (errorCode == ERROR_NOT_FOUND) {
          return;
        }
        throw WindowsException(HRESULT_FROM_WIN32(errorCode));
      }
    } finally {
      free(targetNamePointer);
    }
  }
}
