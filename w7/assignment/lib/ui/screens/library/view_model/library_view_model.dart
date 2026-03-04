import 'package:flutter/widgets.dart';

import '../../../states/player_state.dart';
import '../../../states/settings_state.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/songs/song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  final AppSettingsState appSettingsState;

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.appSettingsState,
  });

  // Fetch songs from the repository
  List<Song> getSongs() {
    return songRepository.fetchSongs();
  }

  // Listen to player state changes
  PlayerState get player => playerState;

  // Listen to app settings changes
  AppSettingsState get settings => appSettingsState;

  // Handle song selection (play action)
  void playSong(Song song) {
    playerState.start(song);
  }

  // Check if a song is currently playing
  bool isPlaying(Song song) {
    return playerState.currentSong == song;
  }
}
