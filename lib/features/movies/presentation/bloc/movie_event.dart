part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class GetPopularMoviesEvent extends MovieEvent {
  final int page;
  final bool isRefresh;

  const GetPopularMoviesEvent({this.page = 1, this.isRefresh = false});

  @override
  List<Object> get props => [page, isRefresh];
}

class SearchMoviesEvent extends MovieEvent {
  final String query;
  final int page;
  final bool isRefresh;

  const SearchMoviesEvent({
    required this.query,
    this.page = 1,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [query, page, isRefresh];
}

class ClearSearchEvent extends MovieEvent {}

class LoadMoreMoviesEvent extends MovieEvent {}
