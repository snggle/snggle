import 'package:snuggle/infra/entity/i_collection_entity.dart';

class MockCollectionEntity extends ICollectionEntity {
  final String id;
  final String name;

  MockCollectionEntity({
    required this.id,
    required this.name,
  });

  factory MockCollectionEntity.fromJson(Map<String, dynamic> json) {
    return MockCollectionEntity(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }
  
  @override
  List<Object?> get props => <Object>[id, name];
}