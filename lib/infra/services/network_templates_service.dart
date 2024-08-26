import 'package:snggle/config/default_network_templates.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/network_template_entity/network_template_entity.dart';
import 'package:snggle/infra/repositories/network_templates_repository.dart';
import 'package:snggle/shared/models/networks/network_template_model.dart';

class NetworkTemplatesService {
  final NetworkTemplatesRepository _networkTemplatesRepository = globalLocator<NetworkTemplatesRepository>();

  Future<bool> isNameUnique(String name) async {
    List<NetworkTemplateEntity> networkTemplateEntityList = await _networkTemplatesRepository.getAll();
    return networkTemplateEntityList.every((NetworkTemplateEntity e) => e.name != name);
  }

  Future<Map<NetworkTemplateModel, List<NetworkTemplateModel>>> getAllAsMap() async {
    List<NetworkTemplateEntity> networkTemplateEntityList = await _networkTemplatesRepository.getAll();
    List<NetworkTemplateModel> networkTemplateModelList = networkTemplateEntityList.map(NetworkTemplateModel.fromEntity).toList();

    Map<NetworkTemplateModel, List<NetworkTemplateModel>> networkTemplateModelMap = <NetworkTemplateModel, List<NetworkTemplateModel>>{};

    for (NetworkTemplateModel predefinedNetworkTemplateModel in DefaultNetworkTemplates.values) {
      List<NetworkTemplateModel> childNetworkTemplateModels = networkTemplateModelList.where((NetworkTemplateModel e) {
        return e.predefinedNetworkTemplateId == predefinedNetworkTemplateModel.name.hashCode;
      }).toList();

      networkTemplateModelMap[predefinedNetworkTemplateModel] = childNetworkTemplateModels;
    }

    return networkTemplateModelMap;
  }

  Future<NetworkTemplateModel> getById(int id) async {
    NetworkTemplateEntity networkTemplateEntity = await _networkTemplatesRepository.getById(id);
    return NetworkTemplateModel.fromEntity(networkTemplateEntity);
  }

  Future<int> save(NetworkTemplateModel networkTemplateModel) async {
    return _networkTemplatesRepository.save(NetworkTemplateEntity.fromNetworkTemplateModel(networkTemplateModel));
  }

  Future<void> deleteAll(List<NetworkTemplateModel> networkTemplateModelList) async {
    await _networkTemplatesRepository.deleteAll(networkTemplateModelList.map(NetworkTemplateEntity.fromNetworkTemplateModel).toList());
  }
}
