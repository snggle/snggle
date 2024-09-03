part of 'app_animated_icons.dart';

class AssetAnimatedIconData with EquatableMixin {
  final String assetName;

  const AssetAnimatedIconData(this.assetName);

  @override
  List<Object> get props => <Object>[assetName];
}
