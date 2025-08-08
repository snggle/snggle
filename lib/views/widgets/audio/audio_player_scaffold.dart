import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/audio/audio_player_section.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/generic/data_export_scaffold_layout.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';

class AudioPlayerScaffold extends StatefulWidget {
  final String title;
  final Uint8List msgUint8List;
  final Widget child;
  final Widget tooltip;
  final bool closeButtonVisibleBool;
  final bool popButtonVisibleBool;
  final List<Widget>? actions;
  final String? subtitle;
  final VoidCallback? customPopCallback;
  final Widget? addressPreview;

  const AudioPlayerScaffold({
    required this.title,
    required this.msgUint8List,
    required this.child,
    required this.tooltip,
    this.closeButtonVisibleBool = false,
    this.popButtonVisibleBool = true,
    this.actions,
    this.subtitle,
    this.customPopCallback,
    this.addressPreview,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AudioPlayerScaffoldState();
}

class _AudioPlayerScaffoldState extends State<AudioPlayerScaffold> {
  final ScrollController scrollController = ScrollController();
  bool _tooltipDisabledBool = true;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return CustomScaffold(
      title: widget.title,
      actions: widget.actions,
      closeButtonVisible: widget.closeButtonVisibleBool,
      popButtonVisible: widget.popButtonVisibleBool,
      customPopCallback: widget.customPopCallback,
      body: DataExportScaffoldLayout(
        tooltip: widget.tooltip,
        tooltipDisabledBool: _tooltipDisabledBool,
        footer: widget.addressPreview,
        body: GradientScrollbar(
          scrollController: scrollController,
          margin: const EdgeInsets.only(bottom: CustomBottomNavigationBar.height),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  if (widget.subtitle != null) ...<Widget>[
                    Text(
                      widget.subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                    ),
                    const SizedBox(height: 20),
                  ],
                  AudioPlayerSection(
                    msgUint8List: widget.msgUint8List,
                    onFirstEmission: _enableTooltip,
                  ),
                  const SizedBox(height: 20),
                  widget.child,
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _enableTooltip() {
    setState(() {
      _tooltipDisabledBool = false;
    });
  }
}
