class MultiQrCodeItemModel {
  final int maxPages;
  final int pageNumber;
  final String data;
  final String name;
  final String type;

  MultiQrCodeItemModel({
    required this.maxPages,
    required this.pageNumber,
    required this.data,
    required this.name,
    required this.type,
  });

  MultiQrCodeItemModel.fromJson(List<dynamic> json)
      : name = json[0] as String,
        type = json[1] as String,
        pageNumber = json[2] as int,
        maxPages = json[3] as int,
        data = json[4] as String;

  List<dynamic> toJson() {
    return <dynamic>[name, type, pageNumber, maxPages, data];
  }
}
