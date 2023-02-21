import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/salt_model.dart';

class SaltEntity extends Equatable {
  final bool isDefaultPassword;
  final String value;

  const SaltEntity({
    required this.isDefaultPassword,
    required this.value,
  });

  factory SaltEntity.fromModel(SaltModel model) {
    return SaltEntity(
      isDefaultPassword: model.isDefaultPassword,
      value: model.value,
    );
  }

  factory SaltEntity.fromJson(Map<String, dynamic> json) {
    return SaltEntity(
      isDefaultPassword: json['isDefaultPassword'] as bool,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'isDefaultPassword': isDefaultPassword,
      'value': value,
    };
  }

  @override
  List<Object?> get props => <Object>[isDefaultPassword, value];
}
