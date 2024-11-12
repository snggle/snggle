import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/shared/models/list_item_access_model.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasswordController {
  // TODO(Marcin): This class will be storing PasswordModels according to FilesystemPaths, to manage the PasswordModel flow through the application
  final List<ListItemAccessModel> _listItemAccessModelList = List<ListItemAccessModel>.empty(growable: true);

  void addPassword(PasswordModel passwordModel, FilesystemPath filesystemPath) {
    _listItemAccessModelList.add(ListItemAccessModel(
      filesystemPath: filesystemPath,
    ));
  }

  Future<bool> checkIfUnlocked(FilesystemPath filesystemPath) async {
    FilesystemPath encryptedPath = await globalLocator<SecretsService>().getEncryptedPath(filesystemPath);

    if (encryptedPath.pathSegments.isEmpty) {
      return true;
    } else {
      for (ListItemAccessModel accessInfo in _listItemAccessModelList) {
        if (accessInfo.filesystemPath == encryptedPath) {
          return true;
        }
      }
      return false;
    }
  }

  void removeByFilesystemPath(FilesystemPath filesystemPath) {
    _listItemAccessModelList.removeWhere((ListItemAccessModel listItemAccessModel) => listItemAccessModel.filesystemPath == filesystemPath);
  }
}
