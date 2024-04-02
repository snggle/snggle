import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/entities/wallet_group_entity.dart';
import 'package:snggle/infra/repositories/wallet_groups_repository.dart';
import 'package:snggle/infra/services/secrets_service.dart';
import 'package:snggle/infra/services/wallets_service.dart';
import 'package:snggle/shared/models/container_path_model.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class WalletGroupsService {
  final WalletGroupsRepository _walletGroupsRepository;
  final SecretsService _secretsService;
  final WalletsService _walletsService;

  WalletGroupsService({
    WalletGroupsRepository? walletGroupsRepository,
    SecretsService? secretsService,
    WalletsService? walletsService,
  })  : _walletGroupsRepository = walletGroupsRepository ?? globalLocator<WalletGroupsRepository>(),
        _secretsService = secretsService ?? globalLocator<SecretsService>(),
        _walletsService = walletsService ?? globalLocator<WalletsService>();

  Future<List<WalletGroupModel>> getAll(String path, {bool strictBool = false}) async {
    List<WalletGroupEntity> walletGroupEntityList = await _walletGroupsRepository.getAll();

    walletGroupEntityList = walletGroupEntityList.where((WalletGroupEntity walletGroupEntity) {
      return strictBool ? walletGroupEntity.parentPath == path : walletGroupEntity.parentPath.startsWith(path);
    }).toList();

    List<WalletGroupModel> walletGroupModelList = walletGroupEntityList.map((WalletGroupEntity e) {
      return WalletGroupModel(pinnedBool: e.pinnedBool, id: e.id, parentPath: e.parentPath, name: e.name);
    }).toList();

    return walletGroupModelList;
  }

  Future<WalletGroupModel?> getByPath(String path) async {
    try {
      WalletGroupEntity walletGroupEntity = await _walletGroupsRepository.getByPath(path);
      return WalletGroupModel(
        pinnedBool: walletGroupEntity.pinnedBool,
        id: walletGroupEntity.id,
        parentPath: walletGroupEntity.parentPath,
        name: walletGroupEntity.name,
      );
    } catch (_) {
      AppLogger().log(message: 'Wallet group not found', logLevel: LogLevel.debug);
      return null;
    }
  }

  Future<void> moveGroup(ContainerPathModel previousPath, ContainerPathModel newPath) async {
    WalletGroupModel? previousWalletGroupModel = await getByPath(previousPath.fullPath);
    if (previousWalletGroupModel == null) {
      throw StateError('Wallet group not found');
    }

    WalletGroupModel movedWalletGroupModel = previousWalletGroupModel.copyWith(parentPath: newPath.parentPath);
    await saveGroup(movedWalletGroupModel);

    await _secretsService.moveSecrets(previousWalletGroupModel.containerPathModel, movedWalletGroupModel.containerPathModel);
  }

  Future<void> saveGroup(WalletGroupModel walletGroupModel) async {
    await _walletGroupsRepository.save(WalletGroupEntity.fromGroupModel(walletGroupModel));
  }

  Future<void> deleteByPath(String path, {bool recursiveBool = false}) async {
    if (recursiveBool) {
      List<WalletModel> walletModels = await _walletsService.getWalletList(path, strictBool: true);
      for (WalletModel walletModel in walletModels) {
        await _walletsService.deleteWalletById(walletModel.uuid);
      }

      List<WalletGroupModel> walletGroupModels = await getAll(path, strictBool: true);
      for (WalletGroupModel walletGroupModel in walletGroupModels) {
        await deleteByPath(walletGroupModel.containerPathModel.fullPath, recursiveBool: recursiveBool);
      }
    }
    await _secretsService.deleteSecrets(ContainerPathModel.fromString(path));
    await _walletGroupsRepository.deleteByPath(path);
  }
}
