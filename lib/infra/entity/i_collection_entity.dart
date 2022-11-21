import 'package:equatable/equatable.dart';

abstract class ICollectionEntity extends Equatable {
  Map<String, dynamic> toJson();
}