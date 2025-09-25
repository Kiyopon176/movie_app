import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;

  MovieRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final remoteMovies = await remoteDataSource.getPopularMovies(page: page);
      return Right(remoteMovies.map((model) => model.toEntity()).toList());
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MovieDetails>> getMovieDetails(int movieId) async {
    try {
      final remoteMovieDetails = await remoteDataSource.getMovieDetails(
        movieId,
      );
      return Right(remoteMovieDetails.toEntity());
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    try {
      final remoteMovies = await remoteDataSource.searchMovies(
        query,
        page: page,
      );
      return Right(remoteMovies.map((model) => model.toEntity()).toList());
    } on Exception catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Exception exception) {
    final message = exception.toString();

    if (message.contains('timeout')) {
      return const ConnectionFailure('Connection timeout');
    } else if (message.contains('Not found')) {
      return const NotFoundFailure();
    } else if (message.contains('Server error')) {
      return ServerFailure(message);
    } else {
      return const ConnectionFailure('Network error');
    }
  }
}
