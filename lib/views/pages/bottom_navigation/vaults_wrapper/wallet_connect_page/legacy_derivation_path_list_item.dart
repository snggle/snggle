import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/widgets/generic/gradient_text.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class LegacyDerivationPathListItem extends StatelessWidget {
  final String derivationPath;
  final NetworkTemplateModel networkTemplateModel;

  const LegacyDerivationPathListItem({
    required this.derivationPath,
    required this.networkTemplateModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<String> derivationPathList = derivationPath.split('/')
      ..removeLast()
      ..removeLast();
    String visibleDerivationPath = derivationPathList.join('/');

    return Row(
      children: <Widget>[
        SizedBox(
          width: 30,
          child: AssetIcon(networkTemplateModel.networkIconType.largeIcon, size: 30),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GradientText(
            visibleDerivationPath,
            gradient: AppColors.primaryGradient,
            textStyle: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
