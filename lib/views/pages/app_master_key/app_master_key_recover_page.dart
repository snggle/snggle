import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_master_key_recover_page/app_master_key_recover_page_cubit.dart';
import 'package:snggle/bloc/pages/app_master_key_recover_page/app_master_key_recover_page_state.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/mnemonic_form/mnemonic_form_editable.dart';

@RoutePage()
class AppMasterKeyRecoverPage extends StatefulWidget {
  const AppMasterKeyRecoverPage({super.key});

  @override
  State<AppMasterKeyRecoverPage> createState() => _AppMasterKeyRecoverPageState();
}

class _AppMasterKeyRecoverPageState extends State<AppMasterKeyRecoverPage> {
  final int mnemonicSize = 24;
  late final AppMasterKeyRecoverPageCubit appMasterKeyRecoverCubit = AppMasterKeyRecoverPageCubit();

  @override
  void initState() {
    super.initState();
    appMasterKeyRecoverCubit.init(mnemonicSize);
  }

  @override
  void dispose() {
    appMasterKeyRecoverCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppMasterKeyRecoverPageCubit, AppMasterKeyRecoverPageState>(
      bloc: appMasterKeyRecoverCubit,
      builder: (BuildContext context, AppMasterKeyRecoverPageState appMasterKeyRecoverState) {
        List<TextEditingController>? textEditingControllerList = appMasterKeyRecoverState.textControllersList;
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
            mnemonicSize: mnemonicSize,
            textControllersList: textEditingControllerList,
            finishEnabledBool: recoverButtonEnabledBool,
            onSaveMnemonic: appMasterKeyRecoverCubit.saveMnemonic,
            onFinish: (List<String> words, _) async {
              MnemonicModel? mnemonicModel = appMasterKeyRecoverCubit.state.mnemonicModel;
              await AutoRouter.of(context).push(
                AppSetUpPinRoute(mnemonicModel: mnemonicModel, appMasterKeyType: AppMasterKeyType.recover),
              );
            },
          ),
        );
      },
    );
  }

  bool get recoverButtonEnabledBool =>
      appMasterKeyRecoverCubit.state.mnemonicFilledBool == true && appMasterKeyRecoverCubit.state.mnemonicValidBool == true;
}
