import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/container_path.dart';

abstract class AContainerModel extends Equatable {
  final ContainerPathModel containerPathModel;

  const AContainerModel({required this.containerPathModel});
}
