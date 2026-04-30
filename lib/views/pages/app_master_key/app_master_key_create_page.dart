import 'package:auto_route/auto_route.dart';
import 'package:cryptography_utils/cryptography_utils.dart' as crypto_utils;
import 'package:flutter/material.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/mnemonic_form/mnemonic_form_generated.dart';

@RoutePage()
class AppMasterKeyCreatePage extends StatefulWidget {
  final crypto_utils.MnemonicSize mnemonicSize = crypto_utils.MnemonicSize.words24;

  AppMasterKeyCreatePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AppMasterKeyCreatePage();
}

class _AppMasterKeyCreatePage extends State<AppMasterKeyCreatePage> {
  late MnemonicModel _mnemonicModel;

  @override
  void initState() {
    super.initState();
    _mnemonicModel = MnemonicModel.generate();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'SET UP MASTER KEY',
      popButtonVisible: true,
      customPopCallback: () {
        context.router.pop();
      },
      body: MnemonicFormGenerated(
        mnemonicSize: widget.mnemonicSize,
        mnemonicList: _mnemonicModel.mnemonicList,
        onFinishPressed: (ScrollController _) => _pressFinishButton(),
      ),
    );
  }

  Future<void> _pressFinishButton() async {
    await CustomLoadingDialog.show<void>(
      context: context,
      title: 'Saving...',
      futureFunction: () {},
      onSuccess: (_) async {
        await AutoRouter.of(context).push(AppSetUpPinRoute(mnemonicModel: _mnemonicModel, appMasterKeyType: AppMasterKeyType.create));
      },
    );
  }
}
