import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/views/widgets/drag/dragged_item/dragged_item_wrapper.dart';

class DragConfig extends Equatable {
  final AListItemModel data;
  final DraggedItemWrapper draggedItem;

  const DragConfig({
    required this.data,
    required this.draggedItem,
  });

  @override
  List<Object?> get props => <Object?>[data];
}
