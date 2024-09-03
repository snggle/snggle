import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

class PredefinedNetworkTemplateListItem extends StatelessWidget {
  final NetworkTemplateModel networkTemplateModel;
  final VoidCallback? onPressed;

  const PredefinedNetworkTemplateListItem({
    required this.networkTemplateModel,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: <Widget>[
            AssetIcon(networkTemplateModel.networkIconType.networkTemplatesListIcon, size: 14),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                networkTemplateModel.name,
                style: textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.5,
                  color: AppColors.body3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
