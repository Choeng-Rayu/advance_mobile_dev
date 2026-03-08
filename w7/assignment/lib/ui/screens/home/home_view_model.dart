import 'package:flutter/widgets.dart';

import '../../../data/repositories/songs/song_repository.dart';
import '../../../data/repositories/user_history/user_history_repository.dart';
import '../../../model/songs/song.dart';
import '../../states/player_state.dart';

class HomeViewModel extends ChangeNotifier {
  final SongRepository _songRepository;
  final UserHistoryRepository _userHistoryRepository;
  final PlayerState _playerState;

  List<Song> _recentSongs = [];
  List<Song> _recommendedSongs = [];

  List<Song> get recentSongs => _recentSongs;
  List<Song> get recommendedSongs => _recommendedSongs;
  Song? get currentSong => _playerState.currentSong;

  HomeViewModel({
    required SongRepository songRepository,
    required UserHistoryRepository userHistoryRepository,
    required PlayerState playerState,
  })  : _songRepository = songRepository,
        _userHistoryRepository = userHistoryRepository,
        _playerState = playerState {
    _load();
    _playerState.addListener(_onPlayerStateChanged);
  }

  void _load() {
    // Load recent songs from history
    final recentSongIds = _userHistoryRepository.fetchRecentSongIds();
    _recentSongs = recentSongIds
        .map((id) => _songRepository.fetchSongById(id))
        .whereType<Song>()
        .toList();

    // Load all songs and filter out the ones in recent songs for recommendations
    final allSongs = _songRepository.fetchSongs();
    _recommendedSongs = allSongs
        .where((song) => !recentSongIds.contains(song.id))
        .toList();

    notifyListeners();
  }

  void _onPlayerStateChanged() {
    notifyListeners();
  }

  void playSong(Song song) {
    _playerState.start(song);
    _userHistoryRepository.addToHistory(song.id);
    _load();
  }

  void stopSong() {
    _playerState.stop();
  }

  @override
  void dispose() {
    _playerState.removeListener(_onPlayerStateChanged);
    super.dispose();
  }
}
