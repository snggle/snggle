import 'package:blockies_svg/blockies_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class NetworkAddressListTile extends StatelessWidget {
  final String address;
  final NetworkTemplateModel networkTemplateModel;

  const NetworkAddressListTile({
    required this.address,
    required this.networkTemplateModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        SizedBox(
          width: 43,
          child: Stack(
            children: <Widget>[
              ClipOval(
                child: SvgPicture.string(
                  Blockies(seed: address).toSvg(size: 13),
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: AssetIcon(networkTemplateModel.networkIconType.largeIcon, size: 16),
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GradientText(
            address,
            gradient: AppColors.primaryGradient,
            textStyle: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
