import '../../domain/entities/movie.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDateString;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIdList;

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.releaseDateString,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIdList,
  });

  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: _parseDate(releaseDateString),
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIdList.map((id) => id.toString()).toList(),
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
