import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/mnemonic_form/mnemonic_form_generated.dart';

@RoutePage()
class AppMasterKeyCreatePage extends StatefulWidget {
  const AppMasterKeyCreatePage({super.key});

  @override
  State<AppMasterKeyCreatePage> createState() => _AppMasterKeyCreatePageState();
}

class _AppMasterKeyCreatePageState extends State<AppMasterKeyCreatePage> {
  final MnemonicModel mnemonicModel = MnemonicModel.masterKey();

  @override
  Widget build(BuildContext buildContext) {
    return CustomScaffold(
      title: 'SET UP MASTER KEY',
      popButtonVisible: true,
      customPopCallback: () {
        buildContext.router.pop();
      },
      body: MnemonicFormGenerated(
        mnemonicList: mnemonicModel.mnemonicList,
        onFinishPressed: (_) => _pressFinishButton(
          buildContext: buildContext,
          mnemonicModel: mnemonicModel,
        ),
      ),
    );
  }

  Future<void> _pressFinishButton({
    required BuildContext buildContext,
    required MnemonicModel mnemonicModel,
  }) async {
    await CustomLoadingDialog.show<void>(
      context: buildContext,
      title: 'Saving...',
      futureFunction: () {},
      onSuccess: (_) async {
        await AutoRouter.of(buildContext).push(
          AppSetUpPinRoute(
            mnemonicModel: mnemonicModel,
            appMasterKeyType: AppMasterKeyType.create,
          ),
        );
      },
    );
  }
}
