import 'package:equatable/equatable.dart';

class LegacyDerivationPathSelectMenuItem extends Equatable {
  final String title;
  final String exampleAddress;
  final String derivationPathTemplate;
  final String? derivationPathName;

  const LegacyDerivationPathSelectMenuItem({
    required this.title,
    required this.exampleAddress,
    required this.derivationPathTemplate,
    this.derivationPathName,
  });

  const LegacyDerivationPathSelectMenuItem.custom(this.derivationPathTemplate)
      : title = 'Custom',
        exampleAddress = '',
        derivationPathName = null;

  LegacyDerivationPathSelectMenuItem copyWith({
    String? title,
    String? exampleAddress,
    String? derivationPathTemplate,
    String? derivationPathName,
  }) {
    return LegacyDerivationPathSelectMenuItem(
      title: title ?? this.title,
      exampleAddress: exampleAddress ?? this.exampleAddress,
      derivationPathTemplate: derivationPathTemplate ?? this.derivationPathTemplate,
      derivationPathName: derivationPathName ?? this.derivationPathName,
    );
  }

  String get exampleDerivationPath {
    String parsedDerivationPath = derivationPathTemplate;
    parsedDerivationPath = parsedDerivationPath.replaceAll('{{a}}', 'x');
    parsedDerivationPath = parsedDerivationPath.replaceAll('{{y}}', 'x');
    parsedDerivationPath = parsedDerivationPath.replaceAll('{{i}}', 'x');

    return parsedDerivationPath;
  }

  @override
  List<Object?> get props => <Object?>[title, derivationPathTemplate, derivationPathName];
}
