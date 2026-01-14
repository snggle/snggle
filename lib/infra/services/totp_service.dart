import 'package:otp/otp.dart';

class TotpConfig {
  final String secret;
  final Algorithm algorithm;
  final int digits;
  final int period;

  const TotpConfig({
    required this.secret,
    required this.algorithm,
    required this.digits,
    required this.period,
  });

  TotpConfig copyWith({
    String? secret,
    Algorithm? algorithm,
    int? digits,
    int? period,
  }) {
    return TotpConfig(
      secret: secret ?? this.secret,
      algorithm: algorithm ?? this.algorithm,
      digits: digits ?? this.digits,
      period: period ?? this.period,
    );
  }

  String get algorithmName {
    switch (algorithm) {
      case Algorithm.SHA1:
        return 'SHA1';
      case Algorithm.SHA256:
        return 'SHA256';
      case Algorithm.SHA512:
        return 'SHA512';
    }
  }

  static TotpConfig fromInput(String input) {
    final String trimmed = input.trim();

    if (trimmed.startsWith('otpauth://')) {
      final Uri uri = Uri.parse(trimmed);
      final Map<String, String> qp = uri.queryParameters;

      final String secret = _normalizeSecret(qp['secret'] ?? '');
      if (secret.isEmpty) {
        throw ArgumentError('No secret found in otpauth URI.');
      }

      final Algorithm algorithm = _parseAlgorithm(qp['algorithm']);
      final int digits = int.tryParse(qp['digits'] ?? '') ?? 6;
      final int period = int.tryParse(qp['period'] ?? '') ?? 30;

      return TotpConfig(
        secret: secret,
        algorithm: algorithm,
        digits: digits,
        period: period,
      );
    }

    return TotpConfig(
      secret: _normalizeSecret(trimmed),
      algorithm: Algorithm.SHA1,
      digits: 6,
      period: 30,
    );
  }

  factory TotpConfig.fromJson(Map<String, dynamic> json) {
    return TotpConfig(
      secret: json['secret'] as String,
      algorithm: Algorithm.values.firstWhere(
        (Algorithm a) => a.name == json['algorithm'],
      ),
      digits: json['digits'] as int,
      period: json['period'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'secret': secret,
      'algorithm': algorithmName,
      'digits': digits,
      'period': period,
    };
  }

  static String _normalizeSecret(String s) {
    return s.replaceAll(RegExp(r'\s+'), '').toUpperCase();
  }

  static Algorithm _parseAlgorithm(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'SHA256':
        return Algorithm.SHA256;
      case 'SHA512':
        return Algorithm.SHA512;
      case 'SHA1':
      default:
        return Algorithm.SHA1;
    }
  }
}
