import 'package:dio/dio.dart';
import '../../../../core/constants/constants.dart';
import '../models/movie_model.dart';
import '../models/movie_details_model.dart';
import '../models/movie_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<MovieDetailsModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final Dio dio;

  MovieRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.popularMovies,
        queryParameters: {'page': page},
      );

      final movieResponse = _movieResponseFromJson(response.data);
      return movieResponse.results;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    try {
      final response = await dio.get('${ApiConstants.movieDetails}/$movieId');
      return _movieDetailsModelFromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.searchMovies,
        queryParameters: {'query': query, 'page': page},
      );

      final movieResponse = _movieResponseFromJson(response.data);
      return movieResponse.results;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  MovieResponse _movieResponseFromJson(Map<String, dynamic> json) {
    return MovieResponse(
      page: json['page'],
      results: (json['results'] as List)
          .map((movie) => _movieModelFromJson(movie))
          .toList(),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  MovieModel _movieModelFromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDateString: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'],
      genreIdList: List<int>.from(json['genre_ids'] ?? []),
    );
  }

  MovieDetailsModel _movieDetailsModelFromJson(Map<String, dynamic> json) {
    return MovieDetailsModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDateString: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'],
      genres: (json['genres'] as List)
          .map((genre) => _genreModelFromJson(genre))
          .toList(),
      runtime: json['runtime'] ?? 0,
      homepage: json['homepage'],
      originalLanguage: json['original_language'],
      popularity: (json['popularity'] as num).toDouble(),
      status: json['status'],
      tagline: json['tagline'],
    );
  }

  GenreModel _genreModelFromJson(Map<String, dynamic> json) {
    return GenreModel(id: json['id'], name: json['name']);
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 404) {
          return Exception('Not found');
        }
        return Exception('Server error: ${e.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error');
    }
  }
}
