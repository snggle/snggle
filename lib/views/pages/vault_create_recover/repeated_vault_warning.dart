import 'package:flutter/material.dart';
import 'package:snggle/shared/models/vaults/vault_model.dart';

class RepeatedVaultWarning extends StatelessWidget {
  final String? description;
  final String title;
  final IconData iconData;
  final VaultModel repeatedVaultModel;

  final double bottomSpacing;
  final double descriptionBottomSpacing;
  final double titleBottomSpacing;

  const RepeatedVaultWarning({
    required this.description,
    required this.title,
    required this.iconData,
    required this.repeatedVaultModel,
    this.bottomSpacing = 0,
    this.descriptionBottomSpacing = 10,
    this.titleBottomSpacing = 10,
    super.key,
  });

  const RepeatedVaultWarning.simple({
    required this.repeatedVaultModel,
    super.key,
  })  : description = null,
        iconData = Icons.warning_amber_rounded,
        title = 'The vault already exists',
        bottomSpacing = 10,
        descriptionBottomSpacing = 10,
        titleBottomSpacing = 10;

  const RepeatedVaultWarning.critical({
    required this.repeatedVaultModel,
    super.key,
  })  : description = 'The vault already exists. The randomization algorithm on your device may be compromised.',
        iconData = Icons.error_outline,
        title = 'CRITICAL WARNING',
        bottomSpacing = 0,
        descriptionBottomSpacing = 10,
        titleBottomSpacing = 5;

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
