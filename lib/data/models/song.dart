class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String assetPath;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.assetPath,
  });

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? assetPath,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      assetPath: assetPath ?? this.assetPath,
    );
  }

  /// Derive a display-friendly title from the asset file name
  static String titleFromPath(String path) {
    final fileName = path.split('/').last.replaceAll('.mp3', '');
    // Remove leading track numbers like "01_", "02_"
    final cleaned = fileName.replaceAll(RegExp(r'^\d+_'), '');
    return cleaned.replaceAll('_', ' ');
  }

  /// Derive artist display name from folder name
  static String artistFromFolder(String folder) {
    const mapping = {
      'Harry_Styles': 'Harry Styles',
      'liam_payne': 'Liam Payne',
      'louis_tomlinson': 'Louis Tomlinson',
      'niall_horan': 'Niall Horan',
      'one_direction': 'One Direction',
      'zayn_malik': 'Zayn Malik',
    };
    return mapping[folder] ?? folder.replaceAll('_', ' ');
  }

  /// Derive album display name from folder name
  static String albumFromFolder(String folder) {
    return folder.replaceAll('_', ' ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Song && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
