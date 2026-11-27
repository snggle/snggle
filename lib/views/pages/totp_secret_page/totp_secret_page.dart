import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/totp_secret_page/totp_secret_page_cubit.dart';
import 'package:snggle/bloc/pages/totp_secret_page/totp_secret_page_state.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/form/entry_form/entry_form_totp_secret_field.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_visibility_builder.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
class TotpSecretPage extends StatefulWidget {
  final bool totpExistsBool;

  const TotpSecretPage({required this.totpExistsBool, super.key});

  @override
  State<TotpSecretPage> createState() => _TotpSecretPageState();
}

class _TotpSecretPageState extends State<TotpSecretPage> {
  final ScrollController scrollController = ScrollController();
  final KeyboardValueNotifier keyboardValueNotifier = KeyboardValueNotifier();
  final TotpSecretPageCubit totpSecretPageCubit = TotpSecretPageCubit();

  bool _obscureSecretBool = true;

  @override
  void dispose() {
    scrollController.dispose();
    keyboardValueNotifier.dispose();
    totpSecretPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TotpSecretPageCubit, TotpSecretPageState>(
      bloc: totpSecretPageCubit,
      builder: (BuildContext context, TotpSecretPageState state) {
        return CustomScaffold(
          title: 'Manual Secret Input',
          popAvailableBool: false,
          customPopCallback: _handleBackPressed,
          resizeToAvoidBottomInsetBool: true,
          body: KeyboardVisibilityBuilder(
            keyboardValueNotifier: keyboardValueNotifier,
            builder: ({required bool customKeyboardVisibleBool, required bool nativeKeyboardVisibleBool}) {
              bool keyboardVisibleBool = customKeyboardVisibleBool || nativeKeyboardVisibleBool;

              return ScrollableLayout(
                scrollController: scrollController,
                bottomMarginVisibleBool: keyboardVisibleBool == false,
                tooltipVisibleBool: keyboardVisibleBool == false,
                tooltipItems: <Widget>[
                  BottomTooltipItem(
                    label: 'Confirm',
                    assetIconData: AppIcons.menu_save,
                    onTap: state.secretInvalidBool ? null : _confirm,
                  ),
                ],
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 100),
                  child: EntryFormTotpSecretField(
                    obscureSecretBool: _obscureSecretBool,
                    secretInvalidBool: state.secretInvalidBool,
                    secretTextEditingController: totpSecretPageCubit.secretTextEditingController,
                    onToggleSecretVisibility: _toggleSecretVisibility,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _confirm() {
    String? totpSecret = totpSecretPageCubit.confirm();
    bool secretInvalidBool = totpSecret == null;
    if (secretInvalidBool) {
      return;
    }

    bool removalRequestedBool = widget.totpExistsBool && totpSecret.isEmpty;
    if (removalRequestedBool) {
      _showDisableTotpDialog();
    } else {
      AutoRouter.of(context).pop<String>(totpSecret);
    }
  }

  void _handleBackPressed() {
    bool secretInputEmptyBool = totpSecretPageCubit.isSecretInputEmpty();
    if (secretInputEmptyBool) {
      AutoRouter.of(context).pop<String>();
    } else {
      _showDiscardDialog();
    }
  }

  void _showDisableTotpDialog() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext context) => CustomDialog(
        title: 'Disabling 2FA',
        content: const Text(
          'Saving an empty secret will disable 2FA.\n'
          'You may lose access to the service.\n'
          'Are you sure you want to continue?',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Cancel',
            onPressed: () {},
          ),
          CustomDialogOption(
            label: 'Confirm',
            onPressed: () => AutoRouter.of(context).pop<String>(''),
          ),
        ],
      ),
    );
  }

  void _showDiscardDialog() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (BuildContext dialogContext) => CustomDialog(
        title: 'Discard new 2FA?',
        content: const Text(
          'You will lose the secret you entered.',
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(label: 'Cancel', onPressed: () {}),
          CustomDialogOption(label: 'Discard', onPressed: () => AutoRouter.of(context).pop<String>()),
        ],
      ),
    );
  }

  void _toggleSecretVisibility() {
    setState(() => _obscureSecretBool = _obscureSecretBool == false);
  }
}
