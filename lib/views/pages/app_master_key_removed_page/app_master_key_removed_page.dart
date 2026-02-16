import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/icons/asset_animated_icon.dart';

@RoutePage()
class AppMasterKeyRemovedPage extends StatelessWidget {
  const AppMasterKeyRemovedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      title: 'SNGGLE',
      closeButtonVisible: false,
      popAvailableBool: true,
      popButtonVisible: false,
      body: Column(
        children: <Widget>[
          Spacer(flex: 60),
          Align(
            child: Column(
              children: <Widget>[
                AssetAnimatedIcon(
                  AppAnimatedIcons.snggle_face,
                  size: 124,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Master Key not found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 200),
        ],
      ),
    );
  }
}
