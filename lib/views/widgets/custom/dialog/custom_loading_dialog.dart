import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/views/widgets/icons/asset_animated_icon.dart';

class CustomLoadingDialog extends StatefulWidget {
  final String title;

  const CustomLoadingDialog({
    required this.title,
    super.key,
  });

  static Future<void> show<T>({
    required BuildContext context,
    required String title,
    required FutureOr<T> Function() futureFunction,
    Color barrierColor = Colors.transparent,
    void Function(T)? onSuccess,
    void Function(Object)? onError,
  }) async {
    Completer<void> dialogVisibilityCompleter = Completer<void>();
    Duration minimumDuration = const Duration(milliseconds: 200);
    unawaited(Future<void>.delayed(minimumDuration).then((_) {
      if (dialogVisibilityCompleter.isCompleted == false) {
        dialogVisibilityCompleter.complete();
      }
    }));

    GlobalKey<_CustomLoadingDialogState> dialogKey = GlobalKey<_CustomLoadingDialogState>();

    unawaited(showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor,
      builder: (BuildContext context) {
        return CustomLoadingDialog(key: dialogKey, title: title);
      },
    ));

    try {
      T result = await futureFunction();

      await dialogVisibilityCompleter.future;
      await dialogKey.currentState?.close();
      onSuccess?.call(result);
    } catch (e) {
      await dialogVisibilityCompleter.future;
      await dialogKey.currentState?.close();
      onError?.call(e);
    }
  }

  @override
  State<StatefulWidget> createState() => _CustomLoadingDialogState();
}

class _CustomLoadingDialogState extends State<CustomLoadingDialog> {
  bool popAvailableBool = false;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: popAvailableBool,
      child: SizedBox.expand(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: Dialog(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                          color: AppColors.body2.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.middleGrey),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 11),
                              child: AssetAnimatedIcon(AppAnimatedIcons.snggle_eyes, height: 30),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.title,
                              style: textTheme.bodyMedium!.copyWith(color: AppColors.body3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> close() async {
    if (mounted) {
      setState(() => popAvailableBool = true);
      Navigator.of(context).pop();
    }
  }
}
