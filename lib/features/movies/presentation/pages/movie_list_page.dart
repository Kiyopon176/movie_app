import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../../../../injection_container.dart' as di;
import '../../domain/entities/movie.dart';
import '../bloc/movie_bloc.dart';
import '../bloc/movie_details_bloc.dart';
import '../widgets/movie_list_item.dart';
import 'movie_details_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MovieBloc>().add(LoadMoreMoviesEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<MovieBloc>().add(ClearSearchEvent());
    } else {
      context.read<MovieBloc>().add(SearchMoviesEvent(query: query));
    }
  }

  void _onMovieTapped(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) =>
              di.sl<MovieDetailsBloc>()..add(GetMovieDetailsEvent(movie.id)),
          child: MovieDetailsPage(movie: movie),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(UIConstants.defaultPadding),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(UIConstants.borderRadius),
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: UIConstants.defaultPadding),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MovieBloc>().add(
                        const GetPopularMoviesEvent(isRefresh: true),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is MovieLoaded || state is MovieLoadingMore) {
            final movies = state is MovieLoaded
                ? state.movies
                : (state as MovieLoadingMore).movies;

            return RefreshIndicator(
              onRefresh: () async {
                final currentState = context.read<MovieBloc>().state;
                if (currentState is MovieLoaded &&
                    currentState.searchQuery != null &&
                    currentState.searchQuery!.isNotEmpty) {
                  context.read<MovieBloc>().add(
                    SearchMoviesEvent(
                      query: currentState.searchQuery!,
                      isRefresh: true,
                    ),
                  );
                } else {
                  context.read<MovieBloc>().add(
                    const GetPopularMoviesEvent(isRefresh: true),
                  );
                }
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state is MovieLoadingMore
                    ? movies.length + 1
                    : movies.length,
                itemBuilder: (context, index) {
                  if (index >= movies.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(UIConstants.defaultPadding),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return MovieListItem(
                    movie: movies[index],
                    onTap: () => _onMovieTapped(movies[index]),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('No movies found'));
        },
      ),
    );
  }
}
