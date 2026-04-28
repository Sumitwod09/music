import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/song.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/services/audio_service.dart';

part 'music_event.dart';
part 'music_state.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  final MusicRepository _musicRepository;
  final AudioService _audioService;
  List<Song> _allSongs = [];
  int _currentIndex = -1;

  MusicBloc({
    required MusicRepository musicRepository,
    required AudioService audioService,
  })  : _musicRepository = musicRepository,
        _audioService = audioService,
        super(MusicInitial()) {
    on<LoadSongs>(_onLoadSongs);
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<ResumeSong>(_onResumeSong);
    on<StopSong>(_onStopSong);
    on<SeekTo>(_onSeekTo);
    on<SearchSongs>(_onSearchSongs);
    on<PlayNext>(_onPlayNext);
    on<PlayPrevious>(_onPlayPrevious);
  }

  AudioService get audioService => _audioService;
  List<Song> get allSongs => _allSongs;
  int get currentIndex => _currentIndex;

  Future<void> _onLoadSongs(LoadSongs event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      _allSongs = _musicRepository.fetchSongs();
      emit(MusicLoaded(_allSongs));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onPlaySong(PlaySong event, Emitter<MusicState> emit) async {
    try {
      _currentIndex = _allSongs.indexWhere((s) => s.id == event.song.id);
      await _audioService.playSong(event.song);
      emit(MusicPlaying(
        currentSong: event.song,
        songs: _allSongs,
        currentIndex: _currentIndex,
      ));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onPauseSong(PauseSong event, Emitter<MusicState> emit) async {
    try {
      await _audioService.pause();
      if (state is MusicPlaying) {
        final s = state as MusicPlaying;
        emit(MusicPaused(
          currentSong: s.currentSong,
          songs: s.songs,
          currentIndex: s.currentIndex,
        ));
      }
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onResumeSong(ResumeSong event, Emitter<MusicState> emit) async {
    try {
      await _audioService.resume();
      if (state is MusicPaused) {
        final s = state as MusicPaused;
        emit(MusicPlaying(
          currentSong: s.currentSong,
          songs: s.songs,
          currentIndex: s.currentIndex,
        ));
      }
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onStopSong(StopSong event, Emitter<MusicState> emit) async {
    try {
      await _audioService.stop();
      emit(MusicLoaded(_allSongs));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onSeekTo(SeekTo event, Emitter<MusicState> emit) async {
    try {
      await _audioService.seekTo(event.position);
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onSearchSongs(SearchSongs event, Emitter<MusicState> emit) async {
    emit(MusicLoading());
    try {
      final songs = _musicRepository.searchSongs(event.query);
      emit(MusicLoaded(songs));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onPlayNext(PlayNext event, Emitter<MusicState> emit) async {
    if (_allSongs.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _allSongs.length;
    final nextSong = _allSongs[_currentIndex];
    try {
      await _audioService.playSong(nextSong);
      emit(MusicPlaying(
        currentSong: nextSong,
        songs: _allSongs,
        currentIndex: _currentIndex,
      ));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }

  Future<void> _onPlayPrevious(PlayPrevious event, Emitter<MusicState> emit) async {
    if (_allSongs.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _allSongs.length) % _allSongs.length;
    final prevSong = _allSongs[_currentIndex];
    try {
      await _audioService.playSong(prevSong);
      emit(MusicPlaying(
        currentSong: prevSong,
        songs: _allSongs,
        currentIndex: _currentIndex,
      ));
    } catch (e) {
      emit(MusicError(e.toString()));
    }
  }
}
