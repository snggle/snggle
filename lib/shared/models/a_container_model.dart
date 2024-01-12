import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/container_path_model.dart';

abstract class AContainerModel with EquatableMixin {
  final ContainerPathModel containerPathModel;

  const AContainerModel({required this.containerPathModel});
}
