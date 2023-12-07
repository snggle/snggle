import 'package:equatable/equatable.dart';

class VaultModel extends Equatable {
  final int index;
  final String uuid;
  final String? name;

  const VaultModel({
    required this.index,
    required this.uuid,
    this.name,
  });

  VaultModel copyWith({
    int? index,
    bool? encryptedBool,
    String? uuid,
    String? name,
  }) {
    return VaultModel(
      index: index ?? this.index,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, uuid, name];
}
