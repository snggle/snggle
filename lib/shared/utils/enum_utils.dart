class EnumUtils {
  static String parseToString(Object o) => o.toString().split('.').last;

  static Enum parseFromString<Enum>(List<Enum> enumValues, String key) => enumValues.firstWhere(
        (Enum element) => key.toLowerCase() == parseToString(element!).toLowerCase(),
  );
}