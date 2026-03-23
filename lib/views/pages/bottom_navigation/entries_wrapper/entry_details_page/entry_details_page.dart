import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/entry_wrapper/entry_details_page/entry_details_page_state.dart';
import 'package:snggle/bloc/pages/entry_create/entry_page_type.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons/app_icons.dart';
import 'package:snggle/shared/models/entries/entry_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/button/gradient_outlined_button.dart';
import 'package:snggle/views/widgets/custom/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:snggle/views/widgets/custom/custom_scaffold.dart';
import 'package:snggle/views/widgets/custom/custom_text_field.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';
import 'package:snggle/views/widgets/generic/label_wrapper_vertical.dart';
import 'package:snggle/views/widgets/generic/public_address_preview.dart';
import 'package:snggle/views/widgets/icons/asset_icon.dart';
import 'package:snggle/views/widgets/qr/qr_result_scaffold.dart';

@RoutePage<void>()
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

  bool _obscureTextBool = true;

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
    TextTheme textTheme = Theme.of(context).textTheme;

    return BlocBuilder<EntryDetailsPageCubit, EntryDetailsPageState>(
      bloc: entryDetailsPageCubit,
      builder: (BuildContext context, EntryDetailsPageState entryDetailsPageState) {
        return CustomScaffold(
          title: widget.entryModel.name,
          actions: <Widget>[
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
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  sliver: SliverToBoxAdapter(
                    child: CustomTextField(
                      readOnlyBool: true,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      textStyle: textTheme.bodyMedium,
                      textEditingController: entryDetailsPageCubit.titleTextEditingController,
                      autofocusBool: false,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  sliver: SliverToBoxAdapter(
                    child: LabelWrapperVertical.textField(
                      label: 'Username',
                      labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                      labelPadding: const EdgeInsets.only(left: 0, right: 0, top: 14, bottom: 0),
                      child: CustomTextField(
                        readOnlyBool: true,
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        textStyle: textTheme.bodyMedium,
                        textEditingController: entryDetailsPageCubit.usernameTextEditingController,
                        inputBorder: InputBorder.none,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  sliver: SliverToBoxAdapter(
                    child: LabelWrapperVertical.textField(
                      label: 'Password',
                      labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.darkGrey),
                      labelPadding: const EdgeInsets.only(left: 0, right: 0, top: 14, bottom: 0),
                      child: CustomTextField(
                        readOnlyBool: true,
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        textStyle: textTheme.bodyMedium,
                        textEditingController: entryDetailsPageCubit.passwordTextEditingController,
                        inputBorder: InputBorder.none,
                        keyboardType: TextInputType.text,
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
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: Center(
                    child: GradientOutlinedButton.small(
                      width: 176,
                      label: 'Log in using QR',
                      onPressed: _showQrPage,
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

  Future<void> _showQrPage() async {
    TextTheme textTheme = Theme.of(context).textTheme;

    String qrData = entryDetailsPageCubit.buildQrData();

    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (BuildContext context) {
        return QRResultScaffold.fromPlaintext(
          title: widget.entryModel.name,
          plaintext: qrData,
          qrCodeGap: 0,
          child: LabelWrapperVertical(
            label: '',
            bottomBorderVisibleBool: false,
            child: PublicAddressPreview(
              address: widget.entryModel.name,
              textStyle: textTheme.bodyMedium?.copyWith(color: AppColors.body3),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openEditEntryPage() async {
    await AutoRouter.of(context).push(EntryCreateRoute(
      entryPageType: EntryPageType.entryPageEdit,
      entryModel: widget.entryModel,
    ));

    await entryDetailsPageCubit.init();
  }
}
