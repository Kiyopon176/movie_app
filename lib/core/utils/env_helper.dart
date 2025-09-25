import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  /// Получает значение переменной окружения с проверкой
  static String getRequiredEnvValue(String key) {
    final value = dotenv.env[key];

    if (value == null || value.isEmpty) {
      throw Exception(
        'Required environment variable "$key" is not set.\n'
        'Please check your .env file and make sure it contains:\n'
        '$key=your_actual_value_here',
      );
    }

    return value;
  }

  static String? getOptionalEnvValue(String key) {
    return dotenv.env[key];
  }

  static void validateRequiredEnvVariables(List<String> requiredKeys) {
    final missing = <String>[];

    for (final key in requiredKeys) {
      final value = dotenv.env[key];
      if (value == null || value.isEmpty) {
        missing.add(key);
      }
    }

    if (missing.isNotEmpty) {
      throw Exception(
        'Missing required environment variables: ${missing.join(', ')}\n'
        'Please check your .env file and make sure it contains:\n'
        '${missing.map((key) => '$key=your_actual_value_here').join('\n')}',
      );
    }
  }
}
