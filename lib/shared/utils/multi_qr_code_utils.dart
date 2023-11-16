import 'dart:convert';

import 'package:snggle/shared/models/multi_qr_code_item_model.dart';

class MultiQrCodeUtils {
  static List<String> splitQrCodeData({required String dataString, int maxCharacters = 200, String name = '', String type = ''}) {
    assert(name.length < 30, 'name must be less than 30 characters');
    assert(type.length < 30, 'type must be less than 30 characters');

    String encodeDataString = base64.encode(utf8.encode(dataString));
    List<String> splitDataString = _splitEncodedData(encodeDataString, maxCharacters);
    return _structureSplitData(name, type, splitDataString);
  }

  static List<String> _splitEncodedData(String encodedString, int maxCharacters) {
    assert(maxCharacters > 0, 'Max character must be greater than 0');

    RegExp regExp = RegExp('.{1,${maxCharacters.toStringAsFixed(0)}}');
    Iterable<Match> matchRegExp = regExp.allMatches(encodedString);
    return matchRegExp.map((Match m) => m.group(0)!).toList();
  }

  static List<String> _structureSplitData(String name, String type, List<String> encodedString) {
    List<String> structuredSplitData = <String>[];
    for (int i = 0; i < encodedString.length; i++) {
      int pageNumber = i + 1;
      MultiQrCodeItemModel multiQrCodeItemModel = MultiQrCodeItemModel(
        name: i == 0 ? name.toString() : '',
        type: i == 0 ? type.toString() : '',
        pageNumber: pageNumber,
        maxPages: encodedString.length,
        data: encodedString[i],
      );
      String jsonQrCodeString = jsonEncode(multiQrCodeItemModel.toJson());
      structuredSplitData.add(jsonQrCodeString);
    }
    return structuredSplitData;
  }
}
