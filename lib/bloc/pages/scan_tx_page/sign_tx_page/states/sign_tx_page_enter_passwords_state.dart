import 'package:snggle/bloc/pages/scan_tx_page/sign_tx_page/a_sign_tx_page_state.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';

class SignTxPageEnterPasswordsState extends ASignTxPageState {
  final List<AListItemModel> listItemModels;

  const SignTxPageEnterPasswordsState({required this.listItemModels});

  @override
  List<Object?> get props => <Object>[listItemModels];
}
