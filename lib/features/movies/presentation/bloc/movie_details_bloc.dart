import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie_details.dart';
import '../../domain/usecases/get_movie_details.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;

  MovieDetailsBloc({required this.getMovieDetails})
    : super(MovieDetailsInitial()) {
    on<GetMovieDetailsEvent>(_onGetMovieDetails);
  }

  void _onGetMovieDetails(
    GetMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());

    final result = await getMovieDetails(event.movieId);

    result.fold(
      (failure) => emit(MovieDetailsError(_mapFailureToMessage(failure))),
      (movieDetails) => emit(MovieDetailsLoaded(movieDetails)),
    );
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server Failure';
      case const (ConnectionFailure):
        return 'Connection Failure';
      case const (NotFoundFailure):
        return 'Movie Not Found';
      default:
        return 'Unexpected Error';
    }
  }
}
