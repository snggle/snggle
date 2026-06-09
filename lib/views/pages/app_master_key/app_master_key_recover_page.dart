import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_master_key/app_master_key_recover_page/app_master_key_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/app_master_key/app_master_key_recover_page/app_master_key_recover_page_state.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/keyboard/keyboard_value_notifier.dart';
import 'package:snggle/views/widgets/mnemonic_form/mnemonic_form_editable.dart';

@RoutePage()
class AppMasterKeyRecoverPage extends StatefulWidget {
  const AppMasterKeyRecoverPage({super.key});

  @override
  State<AppMasterKeyRecoverPage> createState() => _AppMasterKeyRecoverPageState();
}

class _AppMasterKeyRecoverPageState extends State<AppMasterKeyRecoverPage> {
  final int _mnemonicSize = 24;
  late final AppMasterKeyRecoverPageCubit _appMasterKeyRecoverPageCubit = AppMasterKeyRecoverPageCubit();
  final KeyboardValueNotifier _keyboardValueNotifier = KeyboardValueNotifier();

  @override
  void initState() {
    super.initState();
    _appMasterKeyRecoverPageCubit.init(_mnemonicSize);
  }

  @override
  void dispose() {
    _keyboardValueNotifier.dispose();
    _appMasterKeyRecoverPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppMasterKeyRecoverPageCubit, AppMasterKeyRecoverPageState>(
      bloc: _appMasterKeyRecoverPageCubit,
      builder: (BuildContext context, AppMasterKeyRecoverPageState appMasterKeyRecoverState) {
        List<TextEditingController> textEditingControllerList = appMasterKeyRecoverState.textControllersList;
        if (textEditingControllerList.isEmpty) {
          return const SizedBox.shrink();
        }
        return CustomScaffold(
          title: 'RECOVER MASTER KEY',
          popButtonVisible: true,
          customPopCallback: () {
            context.router.pop();
          },
          body: MnemonicFormEditable(
            mnemonicSize: _mnemonicSize,
            textControllersList: textEditingControllerList,
            finishEnabledBool: appMasterKeyRecoverState.recoverButtonEnabledBool,
            keyboardValueNotifier: _keyboardValueNotifier,
            mnemonicErrorBool: appMasterKeyRecoverState.mnemonicErrorBool,
            onSaveMnemonic: _appMasterKeyRecoverPageCubit.saveMnemonic,
            onFinish: (List<String> words, _) async {
              MnemonicModel? mnemonicModel = _appMasterKeyRecoverPageCubit.state.mnemonicModel;
              await AutoRouter.of(context).push(
                AppSetUpPinRoute(mnemonicModel: mnemonicModel, appMasterKeyType: AppMasterKeyType.recover),
              );
            },
          ),
        );
      },
    );
  }
}
