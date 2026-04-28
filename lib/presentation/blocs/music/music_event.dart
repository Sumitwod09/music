part of 'music_bloc.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object> get props => [];
}

class LoadSongs extends MusicEvent {}

class PlaySong extends MusicEvent {
  final Song song;
  const PlaySong(this.song);

  @override
  List<Object> get props => [song];
}

class PauseSong extends MusicEvent {}

class ResumeSong extends MusicEvent {}

class StopSong extends MusicEvent {}

class PlayNext extends MusicEvent {}

class PlayPrevious extends MusicEvent {}

class SeekTo extends MusicEvent {
  final Duration position;
  const SeekTo(this.position);

  @override
  List<Object> get props => [position];
}

class SearchSongs extends MusicEvent {
  final String query;
  const SearchSongs(this.query);

  @override
  List<Object> get props => [query];
}
