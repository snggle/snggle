import 'package:equatable/equatable.dart';

class SimpleSelectionModel<T> extends Equatable {
  final int allItemsCount;
  final List<T> selectedItems;

  const SimpleSelectionModel({
    required this.allItemsCount,
    required this.selectedItems,
  });

  SimpleSelectionModel.empty({required this.allItemsCount}) : selectedItems = <T>[];

  bool get areAllItemsSelected => selectedItems.length == allItemsCount;

  @override
  List<Object?> get props => <Object?>[allItemsCount, selectedItems];
}
