import 'package:equatable/equatable.dart';

class SingleSelectMenuItem extends Equatable {
  final String title;

  const SingleSelectMenuItem({
    required this.title,
  });

  SingleSelectMenuItem copyWith({
    String? title,
    String? id,
  }) {
    return SingleSelectMenuItem(
      title: title ?? this.title,
    );
  }

  @override
  List<Object?> get props => <Object?>[title];
}
