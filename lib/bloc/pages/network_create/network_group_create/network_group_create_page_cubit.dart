import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/factories/network_group_model_factory.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class NetworkGroupCreatePageCubit extends Cubit<void> {
  final NetworkGroupModelFactory _networkGroupModelFactory = globalLocator<NetworkGroupModelFactory>();
  final FilesystemPath _parentFilesystemPath;

  NetworkGroupCreatePageCubit({
    required FilesystemPath parentFilesystemPath,
  })  : _parentFilesystemPath = parentFilesystemPath,
        super(null);

  Future<void> createNetworkGroup(String name, NetworkTemplateModel networkTemplateModel) async {
    await _networkGroupModelFactory.createNewNetworkGroup(_parentFilesystemPath, name, networkTemplateModel);
  }
}
