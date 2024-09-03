part of 'app_icons.dart';

class AssetIconData with EquatableMixin {
  final String assetName;

  const AssetIconData(this.assetName);

  @override
  List<Object> get props => <Object>[assetName];
}
