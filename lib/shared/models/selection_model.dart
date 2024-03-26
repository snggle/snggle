import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/vaults/vault_list_item_model.dart';

class SelectionModel<T> with EquatableMixin {
  final List<T> selectedItems;

  SelectionModel(this.selectedItems);

  SelectionModel.empty() : selectedItems = <T>[];

  @override
  List<Object?> get props => <Object?>[selectedItems];
}
