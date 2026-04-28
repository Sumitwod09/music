import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../blocs/music/music_bloc.dart';
import '../widgets/song_list_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _selectedArtist = 'All';

  @override
  void initState() {
    super.initState();
    context.read<MusicBloc>().add(LoadSongs());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildArtistChips(),
            Expanded(child: _buildSongsList()),
          ],
        ),
      ),
      // Mini player at bottom
      bottomNavigationBar: _buildMiniPlayer(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: AppColors.primaryGradient,
            ),
            child: const Center(
              child: Text(
                '1D',
                style: TextStyle(
                  color: AppColors.lightCream,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OneD', style: AppTextStyles.h3),
              Text(
                'Your music, your memories',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          BlocBuilder<MusicBloc, MusicState>(
            builder: (context, state) {
              final count = state is MusicLoaded ? state.songs.length : 0;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$count songs',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isSearching
                ? AppColors.warmBeige.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: TextField(
          controller: _searchController,
          onTap: () => setState(() => _isSearching = true),
          onChanged: (query) {
            if (query.isNotEmpty) {
              context.read<MusicBloc>().add(SearchSongs(query));
            } else {
              context.read<MusicBloc>().add(LoadSongs());
            }
          },
          style: AppTextStyles.body.copyWith(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search songs, artists, albums...',
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.warmBeige.withValues(alpha: 0.5),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.warmBeige.withValues(alpha: 0.5),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close, color: AppColors.warmBeige),
                    onPressed: () {
                      _searchController.clear();
                      context.read<MusicBloc>().add(LoadSongs());
                      setState(() => _isSearching = false);
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildArtistChips() {
    final artists = ['All', 'One Direction', 'Harry Styles', 'Zayn Malik',
                     'Niall Horan', 'Louis Tomlinson', 'Liam Payne'];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          final isSelected = _selectedArtist == artist;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedArtist = artist);
                if (artist == 'All') {
                  context.read<MusicBloc>().add(LoadSongs());
                } else {
                  context.read<MusicBloc>().add(SearchSongs(artist));
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.deepBurgundy : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.warmBeige.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  artist,
                  style: TextStyle(
                    color: isSelected ? AppColors.lightCream : AppColors.warmBeige,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSongsList() {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state is MusicLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.warmBeige),
          );
        }

        if (state is MusicError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 56, color: AppColors.error),
                const SizedBox(height: 16),
                Text('Something went wrong', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text(state.message, style: AppTextStyles.bodySmall,
                     textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.read<MusicBloc>().add(LoadSongs()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        List<dynamic> songs = [];
        if (state is MusicLoaded) songs = state.songs;
        if (state is MusicPlaying) songs = state.songs;
        if (state is MusicPaused) songs = state.songs;

        if (songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_off_rounded, size: 56,
                     color: AppColors.warmBeige.withValues(alpha: 0.4)),
                const SizedBox(height: 16),
                Text('No songs found', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Text('Try a different search', style: AppTextStyles.bodySmall),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 100),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return SongListItem(
              song: song,
              onTap: () {
                context.read<MusicBloc>().add(PlaySong(song));
                context.push('/player');
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMiniPlayer() {
    return BlocBuilder<MusicBloc, MusicState>(
      builder: (context, state) {
        if (state is! MusicPlaying && state is! MusicPaused) {
          return const SizedBox.shrink();
        }

        final song = state is MusicPlaying ? state.currentSong :
                     (state as MusicPaused).currentSong;
        final isPlaying = state is MusicPlaying;

        return GestureDetector(
          onTap: () => context.push('/player'),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.wine, AppColors.deepBurgundy],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepBurgundy.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.warmBeige.withValues(alpha: 0.15),
                  ),
                  child: const Icon(Icons.music_note_rounded,
                      color: AppColors.lightCream, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          color: AppColors.lightCream,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: TextStyle(
                          color: AppColors.warmBeige.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (isPlaying) {
                      context.read<MusicBloc>().add(PauseSong());
                    } else {
                      context.read<MusicBloc>().add(ResumeSong());
                    }
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: AppColors.lightCream,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<MusicBloc>().add(PlayNext()),
                  icon: const Icon(Icons.skip_next_rounded,
                      color: AppColors.lightCream, size: 24),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
