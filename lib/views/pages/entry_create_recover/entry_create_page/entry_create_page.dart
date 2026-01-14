import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_create/entry_create_page/entry_create_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_create/entry_create_page/entry_create_page_state.dart';
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entries_create_recover_status.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/bottom_navigation/entries_wrapper/scan_totp_qr_page/scan_totp_qr_page.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/circular_indicator.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage<EntryCreateRecoverStatus?>()
class EntryCreatePage extends StatefulWidget {
  final FilesystemPath? parentFilesystemPath;
  final EntryModel? entryModel;
  final EntryPageType entryPageType;

  const EntryCreatePage({
    required this.entryPageType,
    this.parentFilesystemPath,
    this.entryModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EntryCreatePageState();
}

class _EntryCreatePageState extends State<EntryCreatePage> {
  final ScrollController scrollController = ScrollController();

  bool _obscureTextBool = true;

  late final EntryCreatePageCubit entryCreatePageCubit = EntryCreatePageCubit(
    parentFilesystemPath: widget.parentFilesystemPath,
    entryModel: widget.entryModel,
    mode: widget.entryPageType,
  );

  @override
  void initState() {
    super.initState();
    entryCreatePageCubit.init();
  }

  @override
  void dispose() {
    scrollController.dispose();
    entryCreatePageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryCreatePageCubit, EntryCreatePageState>(
      bloc: entryCreatePageCubit,
      builder: (BuildContext context, EntryCreatePageState state) {
        return CustomScaffold(
          title: widget.entryPageType == EntryPageType.create ? 'CREATE ENTRY' : 'EDIT ENTRY',
          body: ScrollableLayout(
            scrollController: scrollController,
            tooltipItems: <Widget>[
              BottomTooltipItem(
                label: 'Finish',
                assetIconData: AppIcons.menu_save,
                onTap: _finishButtonEnabledBool ? _save : null,
              ),
            ],
            child: CustomScrollView(
              controller: scrollController,
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      LabelWrapperVertical.textField(
                        label: 'Name',
                        child: CustomTextField(
                          textEditingController: entryCreatePageCubit.nameTextEditingController,
                          inputBorder: InputBorder.none,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      if (state.entryNameEmptyBool == true)
                        const ErrorMessageListTile(
                          message: 'Entry name cannot be empty',
                        ),
                      LabelWrapperVertical(
                        label: 'Login',
                        child: CustomTextField(
                          textEditingController: entryCreatePageCubit.loginTextEditingController,
                          inputBorder: InputBorder.none,
                          keyboardType: TextInputType.text,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      LabelWrapperVertical(
                        label: 'Password',
                        child: CustomTextField(
                          textEditingController: entryCreatePageCubit.passwordTextEditingController,
                          inputBorder: InputBorder.none,
                          keyboardType: TextInputType.text,
                          padding: EdgeInsets.zero,
                          obscureTextBool: _obscureTextBool,
                          suffixWidget: InkWell(
                            onTap: () => setState(() => _obscureTextBool = !_obscureTextBool),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: AssetIcon(
                                _obscureTextBool ? AppIcons.details_hide : AppIcons.details_show,
                              ),
                            ),
                          ),
                          suffixWidgetConstraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                        ),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                if (state.totpExistsBool)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    sliver: SliverToBoxAdapter(
                      child: LabelWrapperVertical.textField(
                        label: 'One-Time Password',
                        //labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                        labelPadding: const EdgeInsets.only(left: 0, right: 0, top: 14, bottom: 0),
                        child: CustomTextField(
                          readOnlyBool: true,
                          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          //textStyle: textTheme.bodyMedium,
                          textEditingController: entryCreatePageCubit.totpTextEditingController,
                          inputBorder: InputBorder.none,
                          keyboardType: TextInputType.text,
                          suffixWidgetConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          suffixWidget: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircularIndicator(
                              remainingSeconds: entryCreatePageCubit.state.totpRemainingSeconds,
                              period: entryCreatePageCubit.state.totpPeriod,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                if (state.totpExistsBool == false)
                  SliverToBoxAdapter(
                    child: Center(
                      child: GradientOutlinedButton.small(
                        width: 176,
                        label: 'Set up TOTP',
                        onPressed: _showScanTotpQRPage,
                      ),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Center(
                      child: GradientOutlinedButton.small(
                        width: 176,
                        label: 'Remove TOTP',
                        onPressed: _removeTotp,
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

  bool get _finishButtonEnabledBool => entryCreatePageCubit.state.entryNameEmptyBool == false;

  Future<void> _save() async {
    await CustomLoadingDialog.show<EntryModel?>(
      context: context,
      title: 'Saving...',
      futureFunction: entryCreatePageCubit.save,
      onSuccess: (EntryModel? entryModel) async {
        if (entryModel != null) {
          await AutoRouter.of(context).root.pop(
                EntryCreateRecoverStatus.creationSuccessful,
              );
        }
      },
    );
  }

  Future<void> _showScanTotpQRPage() async {
    bool? totpAdded = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      useSafeArea: false,
      builder: (BuildContext context) {
        return ScanTotpQRPage(
          entryModel: widget.entryModel,
          onTotpScanned: entryCreatePageCubit.setTotpConfig,
        );
      },
    );

    if (totpAdded == true) {
      await entryCreatePageCubit.init();
    }
  }

  Future<void> _removeTotp() async {
    await entryCreatePageCubit.removeTotp();
  }
}
