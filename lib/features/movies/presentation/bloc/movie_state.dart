part of 'movie_bloc.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoadingMore extends MovieState {
  final List<Movie> movies;

  const MovieLoadingMore(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool hasReachedMax;
  final int currentPage;
  final String? searchQuery;

  const MovieLoaded({
    required this.movies,
    required this.hasReachedMax,
    required this.currentPage,
    this.searchQuery,
  });

  @override
  List<Object> get props => [
    movies,
    hasReachedMax,
    currentPage,
    searchQuery ?? '',
  ];

  MovieLoaded copyWith({
    List<Movie>? movies,
    bool? hasReachedMax,
    int? currentPage,
    String? searchQuery,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object> get props => [message];
}
