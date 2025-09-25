import '../../domain/entities/movie_details.dart';

class MovieDetailsModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDateString;
  final double voteAverage;
  final int voteCount;
  final List<GenreModel> genres;
  final int runtime;
  final String? homepage;
  final String originalLanguage;
  final double popularity;
  final String status;
  final String? tagline;

  const MovieDetailsModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDateString,
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

  MovieDetails toEntity() {
    return MovieDetails(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: _parseDate(releaseDateString),
      voteAverage: voteAverage,
      voteCount: voteCount,
      genres: genres.map((g) => g.toEntity()).toList(),
      runtime: runtime,
      homepage: homepage,
      originalLanguage: originalLanguage,
      popularity: popularity,
      status: status,
      tagline: tagline,
    );
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }
}

class GenreModel {
  final int id;
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  });

  Genre toEntity() {
    return Genre(id: id, name: name);
  }
}