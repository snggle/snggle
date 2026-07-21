import 'package:cryptography_utils/cryptography_utils.dart';

abstract class ATransactionEntity {
  int get id;

  int get walletId;

  String get creationDate;

  SignDataType get signDataType;

  String? get amount;

  String? get message;

  String? get contractAddress;

  String? get senderAddress;

  String? get recipientAddress;

  String? get signature;

  String? get signDate;
}

T? enumByNameOrNull<T extends Enum>(List<T> values, String? name) {
  if (name == null) {
    return null;
  }

  for (final T value in values) {
    if (value.name == name) {
      return value;
    }
  }

  return null;
}
