import 'package:flutter_test/flutter_test.dart';
import 'package:musicflow_app/data/repositories/music_repository.dart';

void main() {
  test('MusicRepository returns all songs', () {
    final repo = MusicRepository();
    final songs = repo.fetchSongs();
    expect(songs.isNotEmpty, true);
    expect(songs.length, greaterThan(300));
  });

  test('MusicRepository search works', () {
    final repo = MusicRepository();
    final results = repo.searchSongs('Night Changes');
    expect(results.isNotEmpty, true);
    expect(results.first.title, contains('Night Changes'));
  });

  test('MusicRepository gets artists', () {
    final repo = MusicRepository();
    final artists = repo.getArtists();
    expect(artists.contains('Harry Styles'), true);
    expect(artists.contains('Zayn Malik'), true);
    expect(artists.contains('One Direction'), true);
  });
}
