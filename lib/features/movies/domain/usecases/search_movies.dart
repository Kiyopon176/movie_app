import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(
    String query, {
    int page = 1,
  }) async {
    return await repository.searchMovies(query, page: page);
  }
}
