import '../utils/env_helper.dart';

class ApiConstants {
  static String get baseUrl => EnvHelper.getRequiredEnvValue('TMDB_BASE_URL');
  static String get apiKey => EnvHelper.getRequiredEnvValue('TMDB_API_KEY');
  static String get imageBaseUrl =>
      EnvHelper.getRequiredEnvValue('TMDB_IMAGE_BASE_URL');
  static String get originalImageBaseUrl =>
      EnvHelper.getRequiredEnvValue('TMDB_ORIGINAL_IMAGE_BASE_URL');

  static const String popularMovies = '/movie/popular';
  static const String movieDetails = '/movie';
  static const String searchMovies = '/search/movie';
}

class UIConstants {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
}
