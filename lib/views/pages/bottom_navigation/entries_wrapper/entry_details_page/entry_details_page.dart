import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/bloc/pages/entry_details_editable/entry_page_type.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/native_autofill_auth.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/models/entries/entry_secrets_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/entry_list_page/entry_create_edit_status.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/generic/copy_wrapper.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/loading_container.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';

@RoutePage<EntryCreateEditStatus?>()
class EntryDetailsPage extends StatefulWidget {
  final EntryModel entryModel;

  const EntryDetailsPage({
    required this.entryModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryDetailsPageState();
}

class _EntryDetailsPageState extends State<EntryDetailsPage> {
  final ScrollController scrollController = ScrollController();

  late final EntryDetailsPageCubit entryDetailsPageCubit = EntryDetailsPageCubit(
    entryModel: widget.entryModel,
  );

  bool _obscurePasswordBool = true;

  @override
  void initState() {
    super.initState();
    entryDetailsPageCubit.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    entryDetailsPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool readOnlyBool = context.routeData.parent!.argsAs<EntriesSectionWrapperRouteArgs>().readOnlyBool;
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<EntryDetailsPageCubit, EntryDetailsPageState>(
      bloc: entryDetailsPageCubit,
      builder: (BuildContext context, EntryDetailsPageState entryDetailsPageState) {
        if (entryDetailsPageState.loadingBool) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: LoadingContainer(height: 30),
          );
        }

        return CustomScaffold(
          title: entryDetailsPageCubit.entryModel.name,
          actions: readOnlyBool
              ? null
              : <Widget>[
                  InkWell(
                    onTap: _openEditEntryPage,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: AssetIcon(AppIcons.menu_rename),
                    ),
                  ),
                ],
          body: GradientScrollbar(
            scrollController: scrollController,
            visibleBool: true,
            margin: const EdgeInsets.only(bottom: CustomBottomNavigationBar.height),
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 12),
                      _buildReadOnlyEntryField(
                        textTheme: textTheme,
                        label: 'Website',
                        textEditingController: entryDetailsPageCubit.websiteTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildReadOnlyEntryField(
                        textTheme: textTheme,
                        label: 'Email',
                        textEditingController: entryDetailsPageCubit.emailTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildReadOnlyEntryField(
                        textTheme: textTheme,
                        label: 'Username',
                        textEditingController: entryDetailsPageCubit.usernameTextEditingController,
                      ),
                      const SizedBox(height: 12),
                      _buildReadOnlyEntryField(
                        textTheme: textTheme,
                        label: 'Password',
                        textEditingController: entryDetailsPageCubit.passwordTextEditingController,
                        obscureTextBool: _obscurePasswordBool,
                        suffixWidget: InkWell(
                          onTap: () => setState(() => _obscurePasswordBool = !_obscurePasswordBool),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: AssetIcon(
                              _obscurePasswordBool ? AppIcons.details_hide : AppIcons.details_show,
                            ),
                          ),
                        ),
                        suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                      ),
                      const SizedBox(height: 48),
                      if (readOnlyBool)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48.0),
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadOnlyEntryField({
    required TextTheme textTheme,
    required String label,
    required TextEditingController textEditingController,
    bool obscureTextBool = false,
    Widget? suffixWidget,
    BoxConstraints? suffixWidgetConstraints,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CopyWrapper(
        value: textEditingController.text,
        copyWrapperBuilder: (BuildContext context, VoidCallback copy) {
          return LabelWrapperVertical.textField(
            label: label,
            labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
            labelPadding: EdgeInsets.zero,
            child: CustomTextField(
              readOnlyBool: true,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              textStyle: textTheme.bodyMedium,
              textEditingController: textEditingController,
              inputBorder: InputBorder.none,
              keyboardType: TextInputType.text,
              obscureTextBool: obscureTextBool,
              onTap: copy,
              suffixWidget: suffixWidget,
              suffixWidgetConstraints: suffixWidgetConstraints,
            ),
          );
        },
      ),
    );
  }

  Future<void> _openEditEntryPage() async {
    EntryCreateEditStatus? entryCreateEditStatus = await AutoRouter.of(context).push<EntryCreateEditStatus?>(
      EntryDetailsEditableRoute(
        entryPageType: EntryPageType.entryPageEdit,
        entryModel: entryDetailsPageCubit.entryModel,
        obscurePasswordBool: _obscurePasswordBool,
      ),
    );

    _obscurePasswordBool = true;

    await entryDetailsPageCubit.init();

    if (entryCreateEditStatus == EntryCreateEditStatus.modificationSuccessful && mounted) {
      await _handleEntryCreateEditStatus(entryCreateEditStatus);
    }
  }

  Future<void> _handleEntryCreateEditStatus(EntryCreateEditStatus? entryCreateEditStatus) async {
    if (entryCreateEditStatus == null) {
      return;
    }

    await showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) => CustomDialog(
        title: 'Success',
        content: Text(
          switch (entryCreateEditStatus) {
            EntryCreateEditStatus.creationSuccessful => 'The entry creation process has been completed',
            EntryCreateEditStatus.modificationSuccessful => 'The entry modification process has been completed',
          },
          textAlign: TextAlign.center,
        ),
        options: <CustomDialogOption>[
          CustomDialogOption(
            label: 'Done',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Future<void> _selectEntry(EntryModel entryModel) async {
    PasswordModel entryPasswordModel = await globalLocator<PasswordController>().getPasswordByFilesystemPath(entryModel.filesystemPath);

    EntrySecretsModel entrySecretsModel = await globalLocator<SecretsService>().get(
      entryModel.filesystemPath,
      entryPasswordModel,
    );

    await NativeAutofillAuth.selectCredential(
      username: entrySecretsModel.username!,
      password: entrySecretsModel.password!,
    );
  }
}
