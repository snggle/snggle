import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/container_path.dart';

abstract class AContainerModel with EquatableMixin {
  final ContainerPathModel containerPathModel;

  const AContainerModel({required this.containerPathModel});
}
