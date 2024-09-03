import 'package:snggle/config/app_icons.dart';

class CustomBottomNavigationBarItemModel {
  final AssetIconData assetIconData;
  final bool largeBool;

  const CustomBottomNavigationBarItemModel({
    required this.assetIconData,
    this.largeBool = false,
  });
}
