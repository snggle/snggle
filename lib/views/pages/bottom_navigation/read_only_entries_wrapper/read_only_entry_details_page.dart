import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entries_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/native/native_autofill_auth.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/form/entry_form/entry_form.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage()
class ReadOnlyEntryDetailsPage extends StatefulWidget {
  final EntryModel entryModel;

  const ReadOnlyEntryDetailsPage({
    required this.entryModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ReadOnlyEntryDetailsPageState();
}

class _ReadOnlyEntryDetailsPageState extends State<ReadOnlyEntryDetailsPage> {
  final ScrollController scrollController = ScrollController();

  late final EntryDetailsPageCubit entryDetailsPageCubit = EntryDetailsPageCubit(entryModel: widget.entryModel);

  bool _obscurePasswordBool = true;

  @override
  void initState() {
    super.initState();
    entryDetailsPageCubit.refresh();
  }

  @override
  void dispose() {
    scrollController.dispose();
    entryDetailsPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryDetailsPageCubit, EntryDetailsPageState>(
      bloc: entryDetailsPageCubit,
      builder: (BuildContext context, EntryDetailsPageState entryDetailsPageState) {
        return CustomScaffold(
          title: entryDetailsPageCubit.entryModel.name,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        EntryForm(
                          websiteTextEditingController: entryDetailsPageCubit.websiteTextEditingController,
                          emailTextEditingController: entryDetailsPageCubit.emailTextEditingController,
                          usernameTextEditingController: entryDetailsPageCubit.usernameTextEditingController,
                          passwordTextEditingController: entryDetailsPageCubit.passwordTextEditingController,
                          readOnlyBool: true,
                          obscurePasswordBool: _obscurePasswordBool,
                          onTogglePasswordVisibility: () => setState(
                                () => _obscurePasswordBool = !_obscurePasswordBool,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: GradientOutlinedButton.large(
                            onPressed: () async {
                              await _selectEntry(widget.entryModel);
                            },
                            label: 'Export Entry',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectEntry(EntryModel entryModel) async {
    PasswordModel entryPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(entryModel.filesystemPath);

    EntrySecretsModel entrySecretsModel = await globalLocator<SecretsService>().get(
      entryModel.filesystemPath,
      entryPasswordModel,
    );

    await NativeAutofillAuth.selectCredential(
      username: entrySecretsModel.username,
      email: entrySecretsModel.email,
      password: entrySecretsModel.password,
    );
  }
}
