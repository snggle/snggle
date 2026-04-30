import 'package:flutter/material.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class RepeatedVaultWarning extends StatelessWidget {
  final VaultModel repeatedVaultModel;
  final String title;
  final IconData iconData;
  final String? description;

  final double titleBottomSpacing;
  final double descriptionBottomSpacing;
  final double bottomSpacing;

  const RepeatedVaultWarning({
    required this.repeatedVaultModel,
    required this.title,
    required this.iconData,
    required this.description,
    this.titleBottomSpacing = 10,
    this.descriptionBottomSpacing = 10,
    this.bottomSpacing = 0,
    super.key,
  });

  const RepeatedVaultWarning.simple({
    required this.repeatedVaultModel,
    super.key,
  })  : title = 'The vault already exists',
        iconData = Icons.warning_amber_rounded,
        description = null,
        titleBottomSpacing = 10,
        descriptionBottomSpacing = 10,
        bottomSpacing = 10;

  const RepeatedVaultWarning.critical({
    required this.repeatedVaultModel,
    super.key,
  })  : title = 'CRITICAL WARNING',
        iconData = Icons.error_outline,
        description = 'The vault already exists. The randomization algorithm on your device may be compromised.',
        titleBottomSpacing = 5,
        descriptionBottomSpacing = 10,
        bottomSpacing = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(width: 6),
            Icon(
              iconData,
              color: Colors.red,
            ),
          ],
        ),
        SizedBox(height: titleBottomSpacing),
        if (description != null) ...<Widget>[
          Text(
            description!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: descriptionBottomSpacing),
        ],
        Text(
          'Repeated vault: ${repeatedVaultModel.name}',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
        if (bottomSpacing > 0) SizedBox(height: bottomSpacing),
      ],
    );
  }
}
