import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class ListItemAccessModel extends Equatable {
  final PasswordModel passwordModel;
  final FilesystemPath filesystemPath;

  const ListItemAccessModel({
    required this.passwordModel,
    required this.filesystemPath,
  });

  @override
  List<Object?> get props => <Object>[passwordModel, filesystemPath];
}
