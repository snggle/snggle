import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class ListItemAccessModel extends Equatable {
  final FilesystemPath filesystemPath;

  const ListItemAccessModel({
    required this.filesystemPath,
  });

  @override
  List<Object?> get props => <Object>[filesystemPath];
}
