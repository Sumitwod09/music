part of 'music_bloc.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object> get props => [];
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final List<Song> songs;
  const MusicLoaded(this.songs);

  @override
  List<Object> get props => [songs];
}

class MusicPlaying extends MusicState {
  final Song currentSong;
  final List<Song> songs;
  final int currentIndex;

  const MusicPlaying({
    required this.currentSong,
    required this.songs,
    required this.currentIndex,
  });

  @override
  List<Object> get props => [currentSong, songs, currentIndex];
}

class MusicPaused extends MusicState {
  final Song currentSong;
  final List<Song> songs;
  final int currentIndex;

  const MusicPaused({
    required this.currentSong,
    required this.songs,
    required this.currentIndex,
  });

  @override
  List<Object> get props => [currentSong, songs, currentIndex];
}

class MusicError extends MusicState {
  final String message;
  const MusicError(this.message);

  @override
  List<Object> get props => [message];
}
