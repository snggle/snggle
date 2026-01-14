import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/entry_create/entry_create_page/entry_create_page_cubit.dart';
import 'package:snggle/bloc/pages/entry_create/entry_create_page/entry_create_page_state.dart';
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_loading_dialog.dart';
import 'package:snggle/views/widgets/generic/error_message_list_tile.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/scrollable_layout.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/tooltip/bottom_tooltip/bottom_tooltip_item.dart';

@RoutePage()
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
          title: widget.entryPageType == EntryPageType.entryPageCreate ? 'CREATE ENTRY' : 'EDIT ENTRY',
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
          await AutoRouter.of(context).root.pop();
        }
      },
    );
  }
}
