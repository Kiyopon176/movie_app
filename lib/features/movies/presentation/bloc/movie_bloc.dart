import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/search_movies.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies getPopularMovies;
  final SearchMovies searchMovies;

  MovieBloc({required this.getPopularMovies, required this.searchMovies})
    : super(MovieInitial()) {
    on<GetPopularMoviesEvent>(_onGetPopularMovies);
    on<SearchMoviesEvent>(_onSearchMovies);
    on<ClearSearchEvent>(_onClearSearch);
    on<LoadMoreMoviesEvent>(_onLoadMoreMovies);
  }

  void _onGetPopularMovies(
    GetPopularMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    if (event.isRefresh || state is MovieInitial) {
      emit(MovieLoading());
    } else if (state is MovieLoaded) {
      final currentState = state as MovieLoaded;
      emit(MovieLoadingMore(currentState.movies));
    }

    final result = await getPopularMovies(page: event.page);

    result.fold((failure) => emit(MovieError(_mapFailureToMessage(failure))), (
      movies,
    ) {
      final hasReachedMax = movies.isEmpty;

      if (event.isRefresh || event.page == 1) {
        emit(
          MovieLoaded(
            movies: movies,
            hasReachedMax: hasReachedMax,
            currentPage: event.page,
          ),
        );
      } else if (state is MovieLoaded || state is MovieLoadingMore) {
        final previousMovies = state is MovieLoaded
            ? (state as MovieLoaded).movies
            : (state as MovieLoadingMore).movies;

        emit(
          MovieLoaded(
            movies: List.of(previousMovies)..addAll(movies),
            hasReachedMax: hasReachedMax,
            currentPage: event.page,
          ),
        );
      }
    });
  }

  void _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    if (event.isRefresh || event.page == 1) {
      emit(MovieLoading());
    } else if (state is MovieLoaded) {
      final currentState = state as MovieLoaded;
      emit(MovieLoadingMore(currentState.movies));
    }

    final result = await searchMovies(event.query, page: event.page);

    result.fold((failure) => emit(MovieError(_mapFailureToMessage(failure))), (
      movies,
    ) {
      final hasReachedMax = movies.isEmpty;

      if (event.isRefresh || event.page == 1) {
        emit(
          MovieLoaded(
            movies: movies,
            hasReachedMax: hasReachedMax,
            currentPage: event.page,
            searchQuery: event.query,
          ),
        );
      } else if (state is MovieLoaded || state is MovieLoadingMore) {
        final previousMovies = state is MovieLoaded
            ? (state as MovieLoaded).movies
            : (state as MovieLoadingMore).movies;

        emit(
          MovieLoaded(
            movies: List.of(previousMovies)..addAll(movies),
            hasReachedMax: hasReachedMax,
            currentPage: event.page,
            searchQuery: event.query,
          ),
        );
      }
    });
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<MovieState> emit) {
    add(const GetPopularMoviesEvent(isRefresh: true));
  }

  void _onLoadMoreMovies(LoadMoreMoviesEvent event, Emitter<MovieState> emit) {
    if (state is MovieLoaded) {
      final currentState = state as MovieLoaded;

      if (!currentState.hasReachedMax) {
        final nextPage = currentState.currentPage + 1;

        if (currentState.searchQuery != null &&
            currentState.searchQuery!.isNotEmpty) {
          add(
            SearchMoviesEvent(query: currentState.searchQuery!, page: nextPage),
          );
        } else {
          add(GetPopularMoviesEvent(page: nextPage));
        }
      }
    }
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server Failure';
      case const (ConnectionFailure):
        return 'Connection Failure';
      case const (NotFoundFailure):
        return 'Not Found';
      default:
        return 'Unexpected Error';
    }
  }
}
