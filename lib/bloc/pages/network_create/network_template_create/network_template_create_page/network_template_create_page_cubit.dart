import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/network_templates_service.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

class NetworkTemplateCreatePageCubit extends Cubit<void> {
  final NetworkTemplatesService _networkTemplatesService = globalLocator<NetworkTemplatesService>();

  NetworkTemplateCreatePageCubit() : super(null);

  Future<void> save(NetworkTemplateModel networkTemplateModel) async {
    await _networkTemplatesService.save(networkTemplateModel);
  }
}
