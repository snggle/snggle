import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/views/widgets/generic/gradient_icon.dart';

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
            SizedBox(
              width: 14,
              height: 14,
              child: GradientIcon(
                networkTemplateModel.networkIconType.iconData,
                size: 14,
                gradient: AppColors.primaryGradient,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                networkTemplateModel.name,
                style: textTheme.labelMedium?.copyWith(
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
