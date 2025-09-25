import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_details.dart';
import '../bloc/movie_details_bloc.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailsError) {
            return Scaffold(
              appBar: AppBar(
                title: Text(movie.title),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: UIConstants.defaultPadding),
                    ElevatedButton(
                      onPressed: () {
                        context.read<MovieDetailsBloc>().add(
                          GetMovieDetailsEvent(movie.id),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is MovieDetailsLoaded) {
            return _buildMovieDetails(context, state.movieDetails);
          }

          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        },
      ),
    );
  }

  Widget _buildMovieDetails(BuildContext context, MovieDetails movieDetails) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              movieDetails.title,
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                movieDetails.backdropPath != null
                    ? CachedNetworkImage(
                        imageUrl:
                            '${ApiConstants.originalImageBaseUrl}${movieDetails.backdropPath}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.movie,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(UIConstants.defaultPadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      UIConstants.borderRadius,
                    ),
                    child: SizedBox(
                      width: 120,
                      height: 180,
                      child: movieDetails.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${ApiConstants.imageBaseUrl}${movieDetails.posterPath}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.movie,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.movie,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: UIConstants.defaultPadding),

                  // Movie Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 20,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movieDetails.voteAverage.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              ' (${movieDetails.voteCount})',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: UIConstants.smallPadding),

                        // Release Date
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '${movieDetails.releaseDate.day}/${movieDetails.releaseDate.month}/${movieDetails.releaseDate.year}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: UIConstants.smallPadding),

                        // Runtime
                        if (movieDetails.runtime > 0) ...[
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '${movieDetails.runtime} min',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: UIConstants.smallPadding),
                        ],

                        // Language
                        Row(
                          children: [
                            const Icon(Icons.language, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              movieDetails.originalLanguage.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: UIConstants.largePadding),

              // Genres
              if (movieDetails.genres.isNotEmpty) ...[
                Text(
                  'Genres',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: UIConstants.smallPadding),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: movieDetails.genres
                      .map(
                        (genre) => Chip(
                          label: Text(genre.name),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: UIConstants.largePadding),
              ],

              // Tagline
              if (movieDetails.tagline != null &&
                  movieDetails.tagline!.isNotEmpty) ...[
                Text(
                  'Tagline',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: UIConstants.smallPadding),
                Text(
                  movieDetails.tagline!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: UIConstants.largePadding),
              ],

              // Overview
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: UIConstants.smallPadding),
              Text(
                movieDetails.overview,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),

              const SizedBox(height: UIConstants.largePadding),

              // Additional Info
              if (movieDetails.homepage != null &&
                  movieDetails.homepage!.isNotEmpty) ...[
                Text(
                  'Additional Information',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: UIConstants.smallPadding),
                Row(
                  children: [
                    const Icon(Icons.web, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Homepage',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Icon(Icons.open_in_new, size: 16),
                  ],
                ),
                const SizedBox(height: UIConstants.smallPadding),
                Text(
                  'Status: ${movieDetails.status}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: UIConstants.largePadding),
              ],
            ]),
          ),
        ),
      ],
    );
  }
}
