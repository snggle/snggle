import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';

@RoutePage()
class PasskeyDetailsPage extends StatefulWidget {
  final PasskeyModel passkeyModel;

  const PasskeyDetailsPage({
    required this.passkeyModel,
    super.key,
  });

  @override
  State<PasskeyDetailsPage> createState() => _PasskeyDetailsPageState();
}

class _PasskeyDetailsPageState extends State<PasskeyDetailsPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PasskeyModel passkeyModel = widget.passkeyModel;

    return CustomScaffold(
      title: passkeyModel.rpName.isNotEmpty
          ? passkeyModel.rpName
          : passkeyModel.rpId,
      body: GradientScrollbar(
        scrollController: scrollController,
        visibleBool: true,
        margin: const EdgeInsets.only(
          bottom: CustomBottomNavigationBar.contentHeight,
        ),
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildField(
                      label: 'Website',
                      value: passkeyModel.rpId,
                    ),
                    _buildField(
                      label: 'Name',
                      value: passkeyModel.rpName,
                    ),
                    _buildField(
                      label: 'Username',
                      value: passkeyModel.userName,
                    ),
                    _buildField(
                      label: 'Display name',
                      value: passkeyModel.userDisplayName,
                    ),
                    _buildField(
                      label: 'Credential ID',
                      value: base64Url.encode(passkeyModel.credentialId),
                    ),
                    _buildField(
                      label: 'Algorithm',
                      value: _getAlgorithmName(passkeyModel.algorithm),
                    ),
                    _buildField(
                      label: 'Sign count',
                      value: passkeyModel.signCount.toString(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String value,
  }) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          SelectableText(
            value,
            style: textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  String _getAlgorithmName(int algorithm) {
    return switch (algorithm) {
      -7 => 'ES256 (ECDSA P-256)',
      -8 => 'EdDSA',
      -257 => 'RS256 (RSA)',
      _ => 'Unknown ($algorithm)',
    };
  }
}