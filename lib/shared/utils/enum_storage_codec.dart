class EnumStorageCodec<T extends Enum> {
  final Map<T, String> _idsByValue;
  late final Map<String, T> _valuesById = <String, T>{
    for (MapEntry<T, String> entry in _idsByValue.entries) entry.value: entry.key,
  };

  EnumStorageCodec(this._idsByValue);

  String? toStorageValue(T? value) {
    if (value == null) {
      return null;
    }

    return _idsByValue[value];
  }

  T? fromStorageValue(String? storageValue) {
    if (storageValue == null) {
      return null;
    }

    T? valueFromId = _valuesById[storageValue];
    if (valueFromId != null) {
      return valueFromId;
    }

    for (T value in _idsByValue.keys) {
      if (value.name == storageValue) {
        return value;
      }
    }

    return null;
  }
}
