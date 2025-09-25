import 'package:equatable/equatable.dart';

class MovieDetails extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<Genre> genres;
  final int runtime;
  final String? homepage;
  final String originalLanguage;
  final double popularity;
  final String status;
  final String? tagline;

  const MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    required this.runtime,
    this.homepage,
    required this.originalLanguage,
    required this.popularity,
    required this.status,
    this.tagline,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    overview,
    posterPath,
    backdropPath,
    releaseDate,
    voteAverage,
    voteCount,
    genres,
    runtime,
    homepage,
    originalLanguage,
    popularity,
    status,
    tagline,
  ];
}

class Genre extends Equatable {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}
