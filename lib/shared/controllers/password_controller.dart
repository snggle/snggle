import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/list_item_access_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasswordController {
  final List<ListItemAccessModel> _listItemAccessModelList = List<ListItemAccessModel>.empty(growable: true);

  void addPassword(PasswordModel passwordModel, FilesystemPath filesystemPath) {
    _listItemAccessModelList.add(ListItemAccessModel(
      filesystemPath: filesystemPath,
      passwordModel: passwordModel,
    ));
  }

  Future<PasswordModel> getPasswordByFilesystemPath(FilesystemPath filesystemPath) async {
    for (ListItemAccessModel accessInfo in _listItemAccessModelList) {
      if (accessInfo.filesystemPath == filesystemPath) {
        return accessInfo.passwordModel;
      }
    }

    bool unlockedBool = await _isUnlocked(filesystemPath);
    if (unlockedBool) {
      return PasswordModel.defaultPassword();
    } else {
      throw Exception('Cannot return password. The password was not provided for a locked element');
    }
  }

  void removeByFilesystemPath(FilesystemPath filesystemPath) {
    _listItemAccessModelList.removeWhere((ListItemAccessModel listItemAccessModel) => listItemAccessModel.filesystemPath == filesystemPath);
  }

  Future<bool> _isUnlocked(FilesystemPath filesystemPath) async {
    FilesystemPath encryptedFilesystemPath = await globalLocator<SecretsService>().getEncryptedPath(filesystemPath);
    if (encryptedFilesystemPath.pathSegments.isEmpty) {
      return true;
    }

    return _listItemAccessModelList.map((ListItemAccessModel e) => e.filesystemPath).contains(encryptedFilesystemPath);
  }
}
