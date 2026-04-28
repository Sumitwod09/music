import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../blocs/music/music_bloc.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    final bloc = context.read<MusicBloc>();
    _positionSub = bloc.audioService.positionStream.listen((pos) {
      if (mounted && pos != null) setState(() => _position = pos);
    });
    _durationSub = bloc.audioService.durationStream.listen((dur) {
      if (mounted && dur != null) setState(() => _duration = dur);
    });

    if (bloc.state is MusicPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _positionSub?.cancel();
    _durationSub?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicBloc, MusicState>(
      listener: (context, state) {
        if (state is MusicPlaying) {
          _rotationController.repeat();
        } else {
          _rotationController.stop();
        }
      },
      builder: (context, state) {
        final song = state is MusicPlaying
            ? state.currentSong
            : state is MusicPaused
                ? state.currentSong
                : null;
        final isPlaying = state is MusicPlaying;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
            ),
            title: Column(
              children: [
                Text(
                  'NOW PLAYING',
                  style: TextStyle(
                    color: AppColors.warmBeige.withValues(alpha: 0.6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                if (song != null)
                  Text(
                    song.album,
                    style: TextStyle(
                      color: AppColors.warmBeige.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A1A22), Color(0xFF1A0E11), Color(0xFF0D0709)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: song == null
                ? const Center(
                    child: Text('No song selected',
                        style: TextStyle(color: AppColors.warmBeige)))
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          const Spacer(flex: 1),
                          // Album art disc
                          RotationTransition(
                            turns: _rotationController,
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.wine,
                                    AppColors.deepBurgundy,
                                    AppColors.cardBg,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.deepBurgundy.withValues(alpha: 0.4),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.darkBg,
                                    border: Border.all(
                                      color: AppColors.warmBeige.withValues(alpha: 0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.music_note_rounded,
                                    color: AppColors.warmBeige,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 1),
                          // Song info
                          Text(
                            song.title,
                            style: AppTextStyles.h2.copyWith(fontSize: 24),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            song.artist,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.warmBeige.withValues(alpha: 0.8),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 36),
                          // Progress bar
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              value: _duration.inSeconds > 0
                                  ? _position.inSeconds.toDouble().clamp(
                                      0, _duration.inSeconds.toDouble())
                                  : 0,
                              max: _duration.inSeconds > 0
                                  ? _duration.inSeconds.toDouble()
                                  : 1,
                              activeColor: AppColors.warmBeige,
                              inactiveColor: AppColors.surfaceLight,
                              onChanged: (value) {
                                context.read<MusicBloc>().add(
                                    SeekTo(Duration(seconds: value.toInt())));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDuration(_position),
                                    style: TextStyle(
                                        color: AppColors.warmBeige.withValues(alpha: 0.6),
                                        fontSize: 12)),
                                Text(_formatDuration(_duration),
                                    style: TextStyle(
                                        color: AppColors.warmBeige.withValues(alpha: 0.6),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () =>
                                    context.read<MusicBloc>().add(PlayPrevious()),
                                icon: const Icon(Icons.skip_previous_rounded),
                                iconSize: 40,
                                color: AppColors.lightCream,
                              ),
                              // Play/Pause button
                              GestureDetector(
                                onTap: () {
                                  if (isPlaying) {
                                    context.read<MusicBloc>().add(PauseSong());
                                  } else {
                                    context.read<MusicBloc>().add(ResumeSong());
                                  }
                                },
                                child: Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.primaryGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.deepBurgundy
                                            .withValues(alpha: 0.5),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: AppColors.lightCream,
                                    size: 36,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    context.read<MusicBloc>().add(PlayNext()),
                                icon: const Icon(Icons.skip_next_rounded),
                                iconSize: 40,
                                color: AppColors.lightCream,
                              ),
                            ],
                          ),
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
